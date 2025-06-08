part of 'edit_user_bloc.dart';

enum StatusEditUser { initial, loading, success, failed, successFetch, edit }

class EditUserState extends Equatable {
  final String userID;
  final String name;
  final String username;
  final String password;
  final Role? role;
  final StatusEditUser status;
  final String message;

  const EditUserState({
    this.userID = '',
    this.name = '',
    this.username = '',
    this.password = '',
    this.role,
    this.message = '',
    this.status = StatusEditUser.initial,
  });

  EditUserState copyWith({
    String? userID,
    String? name,
    String? username,
    String? password,
    Role? role,
    String? message,
    StatusEditUser? status,
  }) {
    return EditUserState(
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
