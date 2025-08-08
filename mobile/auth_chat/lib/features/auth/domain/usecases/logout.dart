import 'package:auth_chat/core/usecase/usecase.dart';
import 'package:auth_chat/core/constants/no_params.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';
import 'package:dartz/dartz.dart';

class LogoutUseCase implements UseCase<Either<String, void>, NoParams> {
  @override
  Future<Either<String, void>> call({NoParams? param}) async {
    return await sl<AuthRepository>().logout();
  }
} 