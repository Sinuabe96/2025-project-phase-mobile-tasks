import '../repository/token_repository.dart';

class GetTokenUsecase {
  final TokenRepository repository;
  GetTokenUsecase({required this.repository});

  Future<String> call() async {
    return await repository.getToken();
  }
}
