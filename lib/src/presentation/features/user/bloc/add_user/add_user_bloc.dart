import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/data/dataSources/remote/web/user_service.dart';
import 'package:pos_app/src/data/models/user_model.dart';

part 'add_user_event.dart';
part 'add_user_state.dart';

class AddUserBloc extends Bloc<AddUserEvent, AddUserState> {
  AddUserBloc() : super(const AddUserState()) {
    on<OnAddNameChanged>(_onAddNameChanged);
    on<OnAddUsernameChanged>(_onAddUsernameChanged);
    on<OnAddPasswordChanged>(_onAddPasswordChanged);
    on<OnAddRoleChanged>(_onAddRoleChanged);
    on<OnTapAddUser>(_onTapAddUser);
    on<ClearState>(_onClearState);
  }

  void _onAddUsernameChanged(
      OnAddUsernameChanged event, Emitter<AddUserState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onAddNameChanged(OnAddNameChanged event, Emitter<AddUserState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onAddPasswordChanged(
      OnAddPasswordChanged event, Emitter<AddUserState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onAddRoleChanged(OnAddRoleChanged event, Emitter<AddUserState> emit) {
    Role role = Role.getTypeByTitle(event.role);

    emit(state.copyWith(role: role));
  }

  void _onTapAddUser(OnTapAddUser event, Emitter<AddUserState> emit) async {
    try {
      emit(state.copyWith(status: StatusAddUser.loading));
      log('state.role: ${state.role}');

      UserModel user = UserModel(
        id: '',
        name: state.name,
        username: state.username,
        role: state.role!,
        password: state.password,
      );

      bool addUser = await UserService().addUser(user);
      log('user: ${user}');
      log('addUser: ${addUser}');

      emit(state.copyWith(
        userID: user.id,
        role: user.role,
        status: StatusAddUser.success,
        message: 'Success Add User',
      ));
    } catch (e) {
      log(e.toString());
      emit(state.copyWith(message: e.toString(), status: StatusAddUser.failed));
    }
  }

  void _onClearState(ClearState event, Emitter<AddUserState> emit) {
    emit(
      state.copyWith(
        userID: '',
        name: '',
        username: '',
        password: '',
        role: null,
        message: '',
        status: StatusAddUser.initial,
      ),
    );
  }
}
