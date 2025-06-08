import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:pos_app/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditFormUserScreen extends StatelessWidget {
  const EditFormUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    EditUserBloc editUserBloc = context.read<EditUserBloc>();

    TextEditingController _nameController = TextEditingController(text: '');
    TextEditingController _usernameController = TextEditingController(text: '');
    TextEditingController _passwordController = TextEditingController(text: '');
    String? valueRole;
    List<String> listRole = [
      Role.getValue(Role.owner),
      Role.getValue(Role.pelayan)
    ];

    Widget formEditName() {
      return CustomTextFormField(
        title: 'Name',
        controller: _nameController,
        keyboardType: TextInputType.text,
        hintText: 'Josh',
        textValidator: 'Please enter name',
        onChanged: (value) {
          editUserBloc.add(OnEditNameChanged(name: value));
        },
      );
    }

    Widget formEditUsername() {
      return CustomTextFormField(
        title: 'Username',
        controller: _usernameController,
        keyboardType: TextInputType.text,
        hintText: 'josh',
        textValidator: 'Please enter username',
        onChanged: (value) {
          editUserBloc.add(OnEditUsernameChanged(username: value));
        },
      );
    }

    Widget formEditPassword() {
      return CustomTextFormField(
        title: 'Password',
        controller: _passwordController,
        keyboardType: TextInputType.text,
        hintText: 'josh',
        textValidator: 'Please enter password',
        onChanged: (value) {
          editUserBloc.add(OnEditPasswordChanged(password: value));
        },
      );
    }

    Widget selectRole() {
      return CustomDropdownFormField(
        title: 'Role',
        value: valueRole,
        listDropdown: listRole,
        textValidator: 'Please select role',
        onChanged: (value) {
          editUserBloc.add(OnEditRoleChanged(role: value.toString()));
        },
      );
    }

    return BlocConsumer<EditUserBloc, EditUserState>(
      listener: (context, state) {
        if (state.status == StatusEditUser.successFetch) {
          _nameController = TextEditingController(text: state.name);
          _usernameController = TextEditingController(text: state.username);
          _passwordController = TextEditingController(text: state.password);
          valueRole = Role.getValue(state.role!);
        }
      },
      builder: (context, state) {
        if (state.status == StatusEditUser.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Column(
          children: [
            formEditName(),
            const SizedBox(height: 16),
            formEditUsername(),
            const SizedBox(height: 16),
            formEditPassword(),
            const SizedBox(height: 16),
            selectRole(),
          ],
        );
      },
    );
  }
}
