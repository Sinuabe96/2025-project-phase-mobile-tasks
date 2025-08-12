import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../data/repository/chat_repository_impl.dart';

class ChatProvider extends ChangeNotifier {
  final ChatRepositoryImpl repository;
  List<Map<String, dynamic>> messages = [];
  final TextEditingController messageController = TextEditingController();
  String currentUserId = '';
  bool isLoading = false;

  ChatProvider(this.repository);

  void connect(String token) {
    repository.connect(token);
    repository.onMessageReceived((msg) {
      messages.add(msg);
      notifyListeners();
    });
  }

  void sendMessage(Map<String, dynamic> message) {
    repository.sendMessage(message);
    messages.add(message);
    notifyListeners();
  }

  void disconnect() {
    repository.disconnect();
  }

  void setCurrentUserId(String id) {
    currentUserId = id;
    notifyListeners();
  }

  Future<void> fetchMessages(String chatId, String token) async {
    isLoading = true;
    notifyListeners();
    final url = Uri.parse(
      'https://g5-flutter-learning-path-be.onrender.com/api/v3/chats/$chatId/messages',
    );
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      messages = List<Map<String, dynamic>>.from(data);
    }
    isLoading = false;
    notifyListeners();
  }
}
