import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/chat_provider.dart';
import '../../data/datasource/chat_socket_data_source.dart';
import '../../data/repository/chat_repository_impl.dart';

class ChatPage extends StatelessWidget {
  final String token;
  final String chatId;

  const ChatPage({super.key, required this.token, required this.chatId});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = ChatProvider(
          ChatRepositoryImpl(ChatSocketDataSource()),
        );
        provider.connect(token);
        provider.fetchMessages(chatId, token);
        return provider;
      },
      child: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          return Scaffold(
            appBar: AppBar(title: Text('Chat')),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chatProvider.messages[index];
                      final isMe =
                          msg['sender']?['id'] == chatProvider.currentUserId;
                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 4,
                            horizontal: 8,
                          ),
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe
                                ? Colors.deepPurple[100]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 16,
                                backgroundImage: AssetImage(
                                  'assets/images/profile.png',
                                ),
                              ),
                              SizedBox(width: 8),
                              Flexible(child: Text(msg['content'] ?? '')),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: chatProvider.messageController,
                          decoration: InputDecoration(
                            hintText: 'Write your message',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          chatProvider.sendMessage({
                            'chatId': chatId,
                            'content': chatProvider.messageController.text,
                            'type': 'text',
                          });
                          chatProvider.messageController.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
