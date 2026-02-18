import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_chat/core/constants/no_params.dart';
import 'package:auth_chat/features/auth/data/models/login_req_params.dart';
import 'package:auth_chat/features/auth/data/models/signup_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/domain/usecases/get_user.dart';
import 'package:auth_chat/features/auth/domain/usecases/is_logged_in.dart';
import 'package:auth_chat/features/auth/domain/usecases/login.dart';
import 'package:auth_chat/features/auth/domain/usecases/logout.dart';
import 'package:auth_chat/features/auth/domain/usecases/signup.dart';
import 'package:auth_chat/service_locator.dart';

// Events
abstract class AuthEvent {}

class CheckAuthStatus extends AuthEvent {}

class SignupEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignupEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  LoginEvent({
    required this.email,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserModel user;

  AuthAuthenticated(this.user);
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<SignupEvent>(_onSignup);
    on<LoginEvent>(_onLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final isLoggedIn = await sl<IsLoggedInUseCase>().call(param: const NoParams());
    
    if (isLoggedIn) {
      final user = await sl<GetUserUseCase>().call(param: const NoParams());
      if (user.id.isNotEmpty) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthUnauthenticated());
      }
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onSignup(
    SignupEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    print('Starting signup process...');
    print('Email: ${event.email}');
    print('Name: ${event.name}');
    
    final params = SignupReqParams(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    
    print('Calling signup use case...');
    final result = await sl<SignupUseCase>().call(param: params);
    
    print('Signup result received');
    result.fold(
      (error) {
        print('Signup error: $error');
        emit(AuthError(error));
      },
      (user) {
        print('Signup success: ${user.name}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    print('Starting login process...');
    print('Email: ${event.email}');
    
    final params = LoginReqParams(
      email: event.email,
      password: event.password,
    );
    
    print('Calling login use case...');
    final result = await sl<LoginUseCase>().call(param: params);
    
    print('Login result received');
    result.fold(
      (error) {
        print('Login error: $error');
        emit(AuthError(error));
      },
      (user) {
        print('Login success: ${user.name}');
        emit(AuthAuthenticated(user));
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    
    final result = await sl<LogoutUseCase>().call(param: const NoParams());
    
    result.fold(
      (error) => emit(AuthError(error)),
      (_) => emit(AuthUnauthenticated()),
    );
  }
} 