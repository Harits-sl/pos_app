import 'package:bloc/bloc.dart';
import 'package:pos_app/src/data/dataSources/remote/web/user_service.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/src/data/models/user_model.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  void fetchAllUsers() async {
    try {
      emit(UserLoading());

      List<UserModel> users = await UserService().getAllUsers();

      emit(UserSuccess(users));
    } catch (e, stackTrace) {
      emit(UserFailed('$e, \n$stackTrace'));
    }
  }

  void deleteUser(id) async {
    try {
      emit(UserLoading());

      UserService().deleteUser(id);

      emit(const UserDeleteSuccess('Success Deleted'));
    } catch (e) {
      emit(UserFailed('$e'));
    }
  }
}
