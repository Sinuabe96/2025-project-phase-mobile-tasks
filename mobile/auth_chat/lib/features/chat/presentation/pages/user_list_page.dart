import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'chat_page.dart';
import '../bloc/user_list_bloc.dart';
import '../bloc/user_list_event.dart';
import '../bloc/user_list_state.dart';

class User {
  final String id;
  final String name;
  final String status;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.status,
    required this.email,
  });
}

class Chat {
  final String id;
  final User user1;
  final User user2;
  final String? lastMessage;
  final String? lastMessageTime;

  Chat({
    required this.id,
    required this.user1,
    required this.user2,
    this.lastMessage,
    this.lastMessageTime,
  });

  User getOtherUser(String currentUserId) {
    return user1.id == currentUserId ? user2 : user1;
  }

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['_id'],
      user1: User(
        id: json['user1']['_id'],
        name: json['user1']['name'],
        status: '',
        email: json['user1']['email'],
      ),
      user2: User(
        id: json['user2']['_id'],
        name: json['user2']['name'],
        status: '',
        email: json['user2']['email'],
      ),
      lastMessage: json['lastMessage']?['content'],
      lastMessageTime: json['lastMessage']?['createdAt'],
    );
  }
}

class UserListPage extends StatelessWidget {
  final String token;
  final String currentUserId;
  UserListPage({required this.token, required this.currentUserId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UserListBloc()
        ..add(FetchUsers(token))
        ..add(FetchUserChats(token, currentUserId)),
      child: Scaffold(
        backgroundColor: Color(0xFF377DFF),
        body: SafeArea(
          child: BlocBuilder<UserListBloc, UserListState>(
            builder: (context, state) {
              if (state is UserListLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is UserListLoaded) {
                return Column(
                  children: [
                    // Blue part: Scrollable row of all registered users
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 80,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.users.length,
                                itemBuilder: (context, index) {
                                  final user = state.users[index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                    ),
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: 28,
                                          backgroundImage: AssetImage(
                                            'assets/images/profile.png',
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Icon(Icons.search, color: Colors.white),
                        ],
                      ),
                    ),
                    // White part: List of chats initiated by the logged-in user
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(32),
                            topRight: Radius.circular(32),
                          ),
                        ),
                        child: state.chats.isEmpty
                            ? Center(child: Text('No chats found'))
                            : ListView.builder(
                                itemCount: state.chats.length,
                                itemBuilder: (context, index) {
                                  final chat = state.chats[index];
                                  final otherUser = chat.getOtherUser(
                                    currentUserId,
                                  );
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: AssetImage(
                                        'assets/images/profile.png',
                                      ),
                                    ),
                                    title: Text(otherUser.name),
                                    subtitle: Text(chat.lastMessage ?? ''),
                                    trailing: Text(chat.lastMessageTime ?? ''),
                                    onTap: () async {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => ChatPage(
                                            token: token,
                                            chatId: chat.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ],
                );
              } else if (state is UserListError) {
                return Center(child: Text(state.message));
              } else {
                return Center(child: Text('Unknown state'));
              }
            },
          ),
        ),
      ),
    );
  }
}
