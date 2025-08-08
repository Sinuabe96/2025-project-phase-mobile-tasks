import 'package:auth_chat/core/usecase/usecase.dart';
import 'package:auth_chat/features/auth/data/models/login_req_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:dartz/dartz.dart';

class LoginUseCase implements UseCase<Either<String, UserModel>, LoginReqParams> {
  @override
  Future<Either<String, UserModel>> call({LoginReqParams? param}) async {
    return await sl<AuthRepository>().login(param!);
  }
} 