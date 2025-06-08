import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/presentation/features/user/bloc/add_user/add_user_bloc.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_dropdown_form_field.dart';
import 'package:pos_app/src/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddFormUserScreen extends StatefulWidget {
  const AddFormUserScreen({Key? key}) : super(key: key);

  @override
  State<AddFormUserScreen> createState() => _AddFormUserScreenState();
}

class _AddFormUserScreenState extends State<AddFormUserScreen> {
  late AddUserBloc userBloc;
  List<String> listRole = [
    Role.getValue(Role.owner),
    Role.getValue(Role.pelayan)
  ];

  @override
  void initState() {
    super.initState();

    userBloc = context.read<AddUserBloc>();
  }

  @override
  Widget build(BuildContext context) {
    Widget formAddName() {
      return CustomTextFormField(
        title: 'Name',
        keyboardType: TextInputType.text,
        hintText: 'Josh',
        textValidator: 'Please enter name',
        onChanged: (value) => userBloc.add(OnAddNameChanged(name: value)),
      );
    }

    Widget formAddUsername() {
      return StatefulBuilder(
        builder: (context, setState) {
          return CustomTextFormField(
            title: 'Username',
            keyboardType: TextInputType.text,
            hintText: 'josh',
            textValidator: 'Please enter price',
            onChanged: (value) {
              userBloc.add(OnAddUsernameChanged(username: value));
            },
          );
        },
      );
    }

    Widget formAddPassword() {
      return StatefulBuilder(
        builder: (context, setState) {
          return CustomTextFormField(
            title: 'password',
            keyboardType: TextInputType.text,
            hintText: 'josh',
            textValidator: 'Please enter password',
            onChanged: (value) {
              userBloc.add(OnAddPasswordChanged(password: value));
            },
          );
        },
      );
    }

    Widget selectRole() {
      return CustomDropdownFormField(
        title: 'Role',
        listDropdown: listRole,
        textValidator: 'Please select role',
        onChanged: (value) {
          userBloc.add(OnAddRoleChanged(role: value.toString()));
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // formImage(),
        // const SizedBox(height: 16),
        formAddName(),
        const SizedBox(height: 16),
        formAddUsername(),
        const SizedBox(height: 16),
        formAddPassword(),
        const SizedBox(height: 16),
        // formQuantity(),
        // const SizedBox(height: 16),
        // formMinimumQuantity(),
        // const SizedBox(height: 16),
        selectRole(),
      ],
    );
  }
}
