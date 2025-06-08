part of 'edit_user_bloc.dart';

abstract class EditUserEvent extends Equatable {
  const EditUserEvent();

  @override
  List<Object> get props => [];
}

class OnEditUsernameChanged extends EditUserEvent {
  final String username;

  const OnEditUsernameChanged({
    required this.username,
  });

  @override
  List<Object> get props => [username];
}

class OnEditNameChanged extends EditUserEvent {
  final String name;

  const OnEditNameChanged({
    required this.name,
  });

  @override
  List<Object> get props => [name];
}

class OnEditRoleChanged extends EditUserEvent {
  final String role;

  const OnEditRoleChanged({
    required this.role,
  });

  @override
  List<Object> get props => [role];
}

class OnEditPasswordChanged extends EditUserEvent {
  final String password;

  const OnEditPasswordChanged({
    required this.password,
  });

  @override
  List<Object> get props => [password];
}

class OnTapEditUser extends EditUserEvent {
  @override
  List<Object> get props => [];
}

class ClearEditState extends EditUserEvent {
  @override
  List<Object> get props => [];
}

class FetchUserById extends EditUserEvent {
  final String id;

  const FetchUserById({
    required this.id,
  });

  @override
  List<Object> get props => [id];
}
