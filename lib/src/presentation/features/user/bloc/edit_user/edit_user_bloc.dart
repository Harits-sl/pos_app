import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/data/dataSources/remote/web/user_service.dart';
import 'package:pos_app/src/data/models/user_model.dart';

part 'edit_user_event.dart';
part 'edit_user_state.dart';

class EditUserBloc extends Bloc<EditUserEvent, EditUserState> {
  EditUserBloc() : super(const EditUserState()) {
    on<FetchUserById>(_fetchUserById);
    on<OnEditNameChanged>(_onEditNameChanged);
    on<OnEditUsernameChanged>(_onEditUsernameChanged);
    on<OnEditPasswordChanged>(_onEditPasswordChanged);
    on<OnEditRoleChanged>(_onEditRoleChanged);
    on<OnTapEditUser>(_onTapEditUser);
    on<ClearEditState>(_onClearState);
  }

  void _fetchUserById(FetchUserById event, Emitter<EditUserState> emit) async {
    try {
      emit(state.copyWith(status: StatusEditUser.loading));

      UserModel user = await UserService().getUserByID(event.id);

      emit(state.copyWith(
        userID: user.id,
        name: user.name,
        username: user.username,
        password: user.password,
        role: user.role,
        status: StatusEditUser.successFetch,
      ));
    } catch (e) {}
  }

  void _onEditUsernameChanged(
      OnEditUsernameChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(
      username: event.username,
      status: StatusEditUser.edit,
    ));
  }

  void _onEditNameChanged(
      OnEditNameChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(
      name: event.name,
      status: StatusEditUser.edit,
    ));
  }

  void _onEditPasswordChanged(
      OnEditPasswordChanged event, Emitter<EditUserState> emit) {
    emit(state.copyWith(
      password: event.password,
      status: StatusEditUser.edit,
    ));
  }

  void _onEditRoleChanged(
      OnEditRoleChanged event, Emitter<EditUserState> emit) {
    Role role = Role.getTypeByTitle(event.role);

    emit(state.copyWith(
      role: role,
      status: StatusEditUser.edit,
    ));
  }

  void _onTapEditUser(OnTapEditUser event, Emitter<EditUserState> emit) async {
    try {
      // emit(state.copyWith(status: StatusEditUser.loading));
      log('state.role: ${state.role}');

      UserModel user = UserModel(
        id: state.userID,
        name: state.name,
        username: state.username,
        role: state.role!,
        password: state.password,
      );

      bool editUser = await UserService().editUser(user);
      log('user: ${user}');

      if (editUser) {
        emit(state.copyWith(
          status: StatusEditUser.success,
          message: 'Success Edit User',
        ));
      }
    } catch (e) {
      log(e.toString());
      emit(
          state.copyWith(message: e.toString(), status: StatusEditUser.failed));
    }
  }

  void _onClearState(ClearEditState event, Emitter<EditUserState> emit) {
    emit(
      state.copyWith(
        userID: '',
        name: '',
        username: '',
        password: '',
        role: null,
        message: '',
        status: StatusEditUser.initial,
      ),
    );
  }
}
