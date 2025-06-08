import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';

class SplashPage extends StatefulWidget {
  static const routeName = '/';

  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // 3 detik kedepan pindah ke login page
    Timer(const Duration(seconds: 3), () {
      Go.routeWithPathAndRemove(context: context, path: Routes.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 275,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
