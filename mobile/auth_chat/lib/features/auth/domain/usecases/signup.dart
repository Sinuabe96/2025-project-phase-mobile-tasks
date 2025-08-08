import 'package:auth_chat/core/usecase/usecase.dart';
import 'package:auth_chat/features/auth/data/models/signup_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:dartz/dartz.dart';

class SignupUseCase implements UseCase<Either<String, UserModel>, SignupReqParams> {
  @override
  Future<Either<String, UserModel>> call({SignupReqParams? param}) async {
    return await sl<AuthRepository>().signup(param!);
  }
}