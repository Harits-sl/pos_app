part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final Map<DateStatus, int> totalList;
  final String role;

  const HomeSuccess(this.totalList, this.role);

  @override
  List<Object?> get props => [totalList, role];
}

class HomeFailed extends HomeState {
  final String error;

  const HomeFailed(this.error);

  @override
  List<Object> get props => [error];
}
