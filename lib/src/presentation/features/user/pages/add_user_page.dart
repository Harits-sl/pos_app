import 'dart:async';

import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/presentation/features/user/bloc/add_user/add_user_bloc.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddUserPage extends StatelessWidget {
  static const String routeName = '/user/add';

  const AddUserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocListener<AddUserBloc, AddUserState>(
        listener: (context, state) {
          // jika status menambahkan success maka tampilkan snackbar dan pesan
          // lalu selama 3 detik redirect ke halaman product
          if (state.status == StatusAddUser.success) {
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            context.read<AddUserBloc>().add(ClearState());

            Timer(const Duration(seconds: 3), () {
              // balik ke halaman product
              // lalu redirect ke halaman product agar seperti setstate
              Go.back(context);
              Go.routeWithPathAndRemove(context: context, path: Routes.user);
            });
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const CustomAppBar(title: 'Add User'),
              const AddFormUserScreen(),
              ButtonAddUserScreen(
                formKey: _formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
