import 'package:auth_chat/features/auth/data/models/login_req_params.dart';
import 'package:auth_chat/features/auth/data/models/signup_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/data/source/auth_api_service.dart';
import 'package:auth_chat/features/auth/data/source/auth_local_service.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:dartz/dartz.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either<String, UserModel>> signup(SignupReqParams params) async {
    final result = await sl<AuthApiService>().signup(params);
    return result.fold(
      (error) => Left(error),
      (response) async {
        if (response.data != null && response.data!.token != null) {
          await sl<AuthLocalService>().saveUser(response.data!);
          await sl<AuthLocalService>().saveToken(response.data!.token!);
        }
        return Right(response.data!);
      },
    );
  }

  @override
  Future<Either<String, UserModel>> login(LoginReqParams params) async {
    final result = await sl<AuthApiService>().login(params);
    return result.fold(
      (error) => Left(error),
      (response) async {
        if (response.data != null && response.data!.token != null) {
          await sl<AuthLocalService>().saveUser(response.data!);
          await sl<AuthLocalService>().saveToken(response.data!.token!);
        }
        return Right(response.data!);
      },
    );
  }

  @override
  Future<Either<String, void>> logout() async {
    final result = await sl<AuthApiService>().logout();
    await sl<AuthLocalService>().clearAuth();
    return result.fold(
      (error) => Left(error),
      (_) => const Right(null),
    );
  }

  @override
  Future<Either<String, UserModel>> getProfile() async {
    return await sl<AuthApiService>().getProfile();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await sl<AuthLocalService>().isLoggedIn();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return await sl<AuthLocalService>().getUser();
  }
}