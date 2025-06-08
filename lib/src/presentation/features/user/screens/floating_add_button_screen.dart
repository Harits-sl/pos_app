import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FloatingAddButtonScreen extends StatelessWidget {
  const FloatingAddButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    void onPressed() {
      Go.routeWithPath(context: context, path: Routes.addUser);
    }

    return Align(
      alignment: Alignment.bottomCenter,
      child: CustomButton(
        color: lightRedColor,
        onPressed: onPressed,
        text: 'Add New User',
        isShadowed: true,
      ),
    );
  }
}
