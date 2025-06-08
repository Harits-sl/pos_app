import 'dart:async';

import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditUserPage extends StatefulWidget {
  static const String routeName = '/user/edit';

  final String id;

  const EditUserPage({required this.id, Key? key}) : super(key: key);

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  @override
  void initState() {
    super.initState();
    context.read<EditUserBloc>().add(FetchUserById(id: widget.id));
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    return Scaffold(
      body: BlocListener<EditUserBloc, EditUserState>(
        listener: (context, state) {
          // jika status menambahkan success maka tampilkan snackbar dan pesan
          // lalu selama 3 detik redirect ke halaman product
          if (state.status == StatusEditUser.success) {
            final snackBar = SnackBar(content: Text(state.message));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            context.read<EditUserBloc>().add(ClearEditState());

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
              const CustomAppBar(title: 'Edit User'),
              const EditFormUserScreen(),
              ButtonEditUserScreen(
                formKey: _formKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
