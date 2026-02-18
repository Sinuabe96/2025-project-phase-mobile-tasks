import '../entities/message_entity.dart';

abstract class ChatRepository {
  void connect(String token);
  void sendMessage(MessageEntity message);
  void onMessageReceived(Function(MessageEntity) callback);
  void disconnect();
}
