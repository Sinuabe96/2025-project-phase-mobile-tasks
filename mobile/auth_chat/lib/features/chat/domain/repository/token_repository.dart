import '../../../authentication/data/datasource/auth_local_data_source.dart';

abstract class TokenRepository {
  Future<String> getToken();
}

class TokenRepositoryImpl implements TokenRepository {
  final AuthLocalDataSource localDataSource;
  TokenRepositoryImpl({required this.localDataSource});

  @override
  Future<String> getToken() async {
    return await localDataSource.getAuthToken();
  }
}
