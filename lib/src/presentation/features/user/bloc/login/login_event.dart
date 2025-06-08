part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class OnUsernameChanged extends LoginEvent {
  final String username;

  const OnUsernameChanged({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}

class OnNameChanged extends LoginEvent {
  final String name;

  const OnNameChanged({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class OnRoleChanged extends LoginEvent {
  final String role;

  const OnRoleChanged({
    required this.role,
  });

  @override
  List<Object> get props => [role];
}

class OnPasswordChanged extends LoginEvent {
  final String password;

  const OnPasswordChanged({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class OnTapLogin extends LoginEvent {}
