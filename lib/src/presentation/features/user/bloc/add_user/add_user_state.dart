part of 'add_user_bloc.dart';

enum StatusAddUser { initial, loading, success, failed }

class AddUserState extends Equatable {
  final String userID;
  final String name;
  final String username;
  final String password;
  final Role? role;
  final StatusAddUser status;
  final String message;

  const AddUserState({
    this.userID = '',
    this.name = '',
    this.username = '',
    this.password = '',
    this.role,
    this.message = '',
    this.status = StatusAddUser.initial,
  });

  AddUserState copyWith({
    String? userID,
    String? name,
    String? username,
    String? password,
    Role? role,
    String? message,
    StatusAddUser? status,
  }) {
    return AddUserState(
      userID: userID ?? this.userID,
      name: name ?? this.name,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      message: message ?? this.message,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props {
    return [
      userID,
      name,
      username,
      password,
      role,
      message,
      status,
    ];
  }
}
