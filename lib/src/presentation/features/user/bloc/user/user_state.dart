part of 'user_cubit.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserSuccess extends UserState {
  final List<UserModel> users;

  const UserSuccess(this.users);

  @override
  List<Object> get props => [users];
}

class UserDeleteSuccess extends UserState {
  const UserDeleteSuccess(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class UserFailed extends UserState {
  final String error;

  const UserFailed(this.error);

  @override
  List<Object> get props => [error];
}
