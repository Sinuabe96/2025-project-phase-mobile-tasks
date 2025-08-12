import '../datasource/chat_socket_data_source.dart';

class ChatRepositoryImpl {
  final ChatSocketDataSource socketDataSource;

  ChatRepositoryImpl(this.socketDataSource);

  void connect(String token) => socketDataSource.connect(token);

  void sendMessage(Map<String, dynamic> message) =>
      socketDataSource.sendMessage(message);

  void onMessageReceived(Function(Map<String, dynamic>) callback) =>
      socketDataSource.onMessageReceived(callback);

  void disconnect() => socketDataSource.disconnect();
}
