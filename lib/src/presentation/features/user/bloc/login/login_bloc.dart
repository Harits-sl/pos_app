import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/data/dataSources/remote/web/user_service.dart';
import 'package:pos_app/src/data/models/user_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<OnNameChanged>(_onNameChanged);
    on<OnUsernameChanged>(_onUsernameChanged);
    on<OnPasswordChanged>(_onPasswordChanged);
    on<OnRoleChanged>(_onRoleChanged);
    on<OnTapLogin>(_onTapLogin);
  }

  void _onUsernameChanged(OnUsernameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(username: event.username));
  }

  void _onNameChanged(OnNameChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(name: event.name));
  }

  void _onPasswordChanged(OnPasswordChanged event, Emitter<LoginState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onRoleChanged(OnRoleChanged event, Emitter<LoginState> emit) {
    Role role = Role.getTypeByTitle(event.role);

    emit(state.copyWith(role: role));
  }

  void _onTapLogin(OnTapLogin event, Emitter<LoginState> emit) async {
    try {
      emit(state.copyWith(status: EnumStatus.loading));

      UserModel user =
          await UserService().login(state.username, state.password);
      log('user: ${user.id}');

      await SessionManager().set("role", Role.getValue(user.role));
      // Role role = await SessionManager().get("role");
      // log('role: ${role}');
      emit(state.copyWith(
          userID: user.id, role: user.role, status: EnumStatus.success));

      // save role to session
    } catch (e) {
      debugPrint(e.toString());
      emit(state.copyWith(message: e.toString(), status: EnumStatus.initial));
    }
  }
}
