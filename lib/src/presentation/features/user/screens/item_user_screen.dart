import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/core/utils/role.dart';
import 'package:pos_app/src/data/models/user_model.dart';
import 'package:pos_app/src/presentation/features/user/index.dart';
import 'package:pos_app/src/presentation/features/user/pages/edit_user_page.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ItemUserScreen extends StatefulWidget {
  const ItemUserScreen({Key? key}) : super(key: key);

  @override
  State<ItemUserScreen> createState() => _ItemUserScreenState();
}

class _ItemUserScreenState extends State<ItemUserScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserCubit>().fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    void onEditPressed(id) {
      Go.routeWithPathAndArgument(
        context: context,
        path: Routes.editUser,
        arguments: id,
      );
    }

    void onDeletePressed(String id) {
      context.read<UserCubit>().deleteUser(id);

      setState(() {
        context.read<UserCubit>().fetchAllUsers();
      });

      const snackBar = SnackBar(content: Text('success deleted'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    Widget editButton(String id) {
      return CustomButton(
        color: yellowColor,
        width: 65,
        height: 32,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(10),
        text: 'Edit',
        textStyle: primaryTextStyle.copyWith(fontSize: 12),
        onPressed: () => onEditPressed(id),
      );
    }

    Widget deleteButton(String id) {
      return CustomButton(
        color: redColor,
        width: 65,
        height: 32,
        margin: const EdgeInsets.all(0),
        padding: const EdgeInsets.all(0),
        borderRadius: BorderRadius.circular(10),
        text: 'Delete',
        textStyle: primaryTextStyle.copyWith(fontSize: 12),
        onPressed: () => onDeletePressed(id),
      );
    }

    Widget itemUser(UserModel user, double marginTop) {
      return Container(
        width: double.infinity,
        margin: EdgeInsets.only(top: marginTop),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(),
        ),
        child: Row(
          children: [
            // Container(
            //   width: 50,
            //   height: 50,
            //   margin: const EdgeInsets.only(right: 12),
            //   decoration: BoxDecoration(
            //     color: lightGray2Color,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama: ${user.name}',
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  'Username: ${user.username}',
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
                Text(
                  'role: ${Role.getValue(user.role)}',
                  style: primaryTextStyle.copyWith(fontSize: 12),
                ),
                // RichText(
                //   text: TextSpan(
                //       text: 'Harga: ',
                //       style: primaryTextStyle.copyWith(fontSize: 12),
                //       children: [
                //         TextSpan(
                //           text: 'Rp. ${StringHelper.addComma(menu.price)}',
                //           style: greenTextStyle.copyWith(fontSize: 12),
                //         ),
                //       ]),
                // ),
                // RichText(
                //   text: TextSpan(
                //       text: 'HPP: ',
                //       style: primaryTextStyle.copyWith(fontSize: 12),
                //       children: [
                //         TextSpan(
                //           text: 'Rp. ${StringHelper.addComma(menu.hpp)}',
                //           style: yellowTextStyle.copyWith(fontSize: 12),
                //         ),
                //       ]),
                // ),
                // Text(
                //   'Tipe: ${menu.typeMenu}',
                //   style: primaryTextStyle.copyWith(fontSize: 12),
                // ),
                // buildStatus(menu.status!),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                editButton(user.id),
                const SizedBox(height: 8),
                deleteButton(user.id),
              ],
            ),
          ],
        ),
      );
    }

    Widget listUsers(List<UserModel> users) {
      int i = 0;
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: defaultMargin),
        child: Column(
          children: users.map((user) {
            i++;
            double marginTop = i != 1 ? 12 : 0;
            return itemUser(user, marginTop);
          }).toList(),
        ),
      );
    }

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        if (state is UserSuccess) {
          return listUsers(state.users);
        }
        if (state is UserLoading) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is UserFailed) {
          return Text(state.error);
        }
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
