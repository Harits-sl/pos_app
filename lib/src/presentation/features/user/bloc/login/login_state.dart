part of 'login_bloc.dart';

enum EnumStatus { initial, loading, success, failed }

class LoginState extends Equatable {
  final String userID;
  final String name;
  final String username;
  final String password;
  final Role? role;
  final EnumStatus status;
  final String message;

  const LoginState({
    this.userID = '',
    this.name = '',
    this.username = '',
    this.password = '',
    this.role,
    this.message = '',
    this.status = EnumStatus.initial,
  });

  LoginState copyWith({
    String? userID,
    String? name,
    String? username,
    String? password,
    Role? role,
    String? message,
    EnumStatus? status,
  }) {
    return LoginState(
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
