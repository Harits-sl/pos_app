import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/presentation/features/user/bloc/edit_user/edit_user_bloc.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtonEditUserScreen extends StatelessWidget {
  const ButtonEditUserScreen({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    void _onPressed() {
      // Validate returns true if the form is valid, or false otherwise.
      if (formKey.currentState!.validate()) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Processing Data')),
        );

        context.read<EditUserBloc>().add(OnTapEditUser());
      }
    }

    return CustomButton(
      color: lightRedColor,
      onPressed: _onPressed,
      text: 'Edit User',
    );
  }
}
