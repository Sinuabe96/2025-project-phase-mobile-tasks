import 'package:equatable/equatable.dart';

class UserListEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserListEvent {
  final String token;
  FetchUsers(this.token);
  @override
  List<Object?> get props => [token];
}

class FetchUserChats extends UserListEvent {
  final String token;
  final String currentUserId;
  FetchUserChats(this.token, this.currentUserId);
  @override
  List<Object?> get props => [token, currentUserId];
}
