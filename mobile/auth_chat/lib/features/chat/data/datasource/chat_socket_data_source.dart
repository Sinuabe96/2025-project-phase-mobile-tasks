import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatSocketDataSource {
  late IO.Socket socket;

  void connect(String token) {
    socket = IO.io(
      'https://g5-flutter-learning-path-be.onrender.com',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );
  }

  void sendMessage(Map<String, dynamic> message) {
    socket.emit('message:send', message);
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    socket.on('message:received', (data) => callback(data));
  }

  void disconnect() {
    socket.disconnect();
  }
}
