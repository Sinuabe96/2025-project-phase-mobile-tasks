import 'package:auth_chat/features/auth/data/models/login_req_params.dart';
import 'package:auth_chat/features/auth/data/models/signup_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, UserModel>> signup(SignupReqParams signupRec);
  Future<Either<String, UserModel>> login(LoginReqParams loginRec);
  Future<Either<String, void>> logout();
  Future<Either<String, UserModel>> getProfile();
  Future<bool> isLoggedIn();
  Future<UserModel?> getCurrentUser();
}