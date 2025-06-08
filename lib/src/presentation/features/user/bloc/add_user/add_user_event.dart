part of 'add_user_bloc.dart';

abstract class AddUserEvent extends Equatable {
  const AddUserEvent();

  @override
  List<Object> get props => [];
}

class OnAddUsernameChanged extends AddUserEvent {
  final String username;

  const OnAddUsernameChanged({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}

class OnAddNameChanged extends AddUserEvent {
  final String name;

  const OnAddNameChanged({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class OnAddRoleChanged extends AddUserEvent {
  final String role;

  const OnAddRoleChanged({
    required this.role,
  });

  @override
  List<Object> get props => [role];
}

class OnAddPasswordChanged extends AddUserEvent {
  final String password;

  const OnAddPasswordChanged({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class OnTapAddUser extends AddUserEvent {
  @override
  List<Object> get props => [];
}

class ClearState extends AddUserEvent {
  @override
  List<Object> get props => [];
}
