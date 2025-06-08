import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:pos_app/src/core/utils/role.dart';

import 'index.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({
    // this.userID,
    Key? key,
  }) : super(key: key);

  // final String? userID;

  @override
  Widget build(BuildContext context) {
    // NOTE: buat dari home cubit menggunakan bloc untuk user
    context.read<HomeCubit>().fetchTransactionAndUser();

    // if (userID != null) {
    //   context.read<HomeCubit>().fetchUserByID(userID!);
    // }

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: BlocConsumer<HomeCubit, HomeState>(
          listener: (context, state) {},
          builder: (context, state) {
            String? role;
            Map<DateStatus, int>? totalList;

            log('state: ${state}');
            if (state is HomeSuccess) {
              role = state.role;
              log('role: ${role}');
              totalList = state.totalList;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: defaultMargin,
                    top: defaultMargin,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'POS HARAPAN BUNDO',
                        style: primaryTextStyle.copyWith(
                            fontWeight: semiBold, fontSize: 12),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Income(totalList: totalList), // tampilan pendapatan
                ),
                Expanded(
                  child: Shortcut(role: role), // tampilan shortcut
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
