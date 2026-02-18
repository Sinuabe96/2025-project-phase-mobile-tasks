import 'package:auth_chat/core/usecase/usecase.dart';
import 'package:auth_chat/core/constants/no_params.dart';
import 'package:auth_chat/features/auth/data/models/user_model.dart';
import 'package:auth_chat/features/auth/domain/repository/auth.dart';
import 'package:auth_chat/service_locator.dart';

class GetUserUseCase implements UseCase<UserModel, NoParams> {
  @override
  Future<UserModel> call({NoParams? param}) async {
    final user = await sl<AuthRepository>().getCurrentUser();
    return user ?? UserModel(id: '', name: '', email: '');
  }
} 