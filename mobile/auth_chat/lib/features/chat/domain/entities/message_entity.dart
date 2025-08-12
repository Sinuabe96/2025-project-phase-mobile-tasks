class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String senderName;
  final String content;
  final String type;
  final DateTime? createdAt;

  MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.type,
    this.createdAt,
  });
}
