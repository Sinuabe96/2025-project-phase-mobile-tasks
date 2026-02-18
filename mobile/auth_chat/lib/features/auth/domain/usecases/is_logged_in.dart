import 'package:auth_chat/core/usecase/usecase.dart';
import 'package:auth_chat/core/constants/no_params.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';

class IsLoggedInUseCase implements UseCase<bool, NoParams> {
  @override
  Future<bool> call({NoParams? param}) async {
    return await sl<AuthRepository>().isLoggedIn();
  }
} 