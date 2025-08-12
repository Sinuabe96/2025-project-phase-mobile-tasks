import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_list_event.dart';
import 'user_list_state.dart';
import '../pages/user_list_page.dart'; // For User and Chat models
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserListBloc extends Bloc<UserListEvent, UserListState> {
  UserListBloc() : super(UserListInitial()) {
    on<FetchUsers>(_onFetchUsers);
    on<FetchUserChats>(_onFetchUserChats);
  }

  Future<void> _onFetchUsers(
    FetchUsers event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    try {
      final url = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/users',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${event.token}',
          'Content-Type': 'application/json',
        },
      );
      debugPrint('${response.body} token ${event.token}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final usersList = data['data'] as List;
        final users = usersList
            .map(
              (u) => User(
                id: u['_id'],
                name: u['name'],
                status: '',
                email: u['email'],
              ),
            )
            .toList();
        emit(UserListLoaded(users: users, chats: []));
      } else {
        emit(UserListError('Failed to load users'));
      }
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }

  Future<void> _onFetchUserChats(
    FetchUserChats event,
    Emitter<UserListState> emit,
  ) async {
    emit(UserListLoading());
    try {
      final url = Uri.parse(
        'https://g5-flutter-learning-path-be-tvum.onrender.com/api/v3/chats',
      );
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer ${event.token}',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final chatsList = data['data'] as List;
        final chats = chatsList
            .map((c) => Chat.fromJson(c))
            .where(
              (chat) =>
                  chat.user1.id == event.currentUserId ||
                  chat.user2.id == event.currentUserId,
            )
            .toList();
        emit(UserListLoaded(users: [], chats: chats));
      } else {
        emit(UserListError('Failed to load chats'));
      }
    } catch (e) {
      emit(UserListError(e.toString()));
    }
  }
}
