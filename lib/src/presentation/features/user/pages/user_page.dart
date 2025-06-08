import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/presentation/features/user/screens/item_user_screen.dart';
import 'package:pos_app/src/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../index.dart';

class UserPage extends StatelessWidget {
  static const String routeName = '/user';

  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              children: const [
                CustomAppBar(title: 'User'),
                ItemUserScreen(),
                // spasi dari produk ke widget floating button
                SizedBox(height: (defaultMargin * 2) + 55),
              ],
            ),
            const FloatingAddButtonScreen(),
          ],
        ),
      ),
    );
  }
}
