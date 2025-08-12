import 'package:equatable/equatable.dart';
import '../pages/user_list_page.dart';

class UserListState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserListInitial extends UserListState {}

class UserListLoading extends UserListState {}

class UserListLoaded extends UserListState {
  final List<User> users;
  final List<Chat> chats;
  UserListLoaded({required this.users, required this.chats});
  @override
  List<Object?> get props => [users, chats];
}

class UserListError extends UserListState {
  final String message;
  UserListError(this.message);
  @override
  List<Object?> get props => [message];
}
