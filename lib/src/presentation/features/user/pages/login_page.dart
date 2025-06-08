import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pos_app/src/config/route/go.dart';
import 'package:pos_app/src/config/route/routes.dart';
import 'package:pos_app/src/core/shared/theme.dart';
import 'package:pos_app/src/presentation/features/user/bloc/login/login_bloc.dart';
import 'package:pos_app/src/presentation/widgets/custom_button.dart';
import 'package:pos_app/src/presentation/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();

    loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Hero(
      tag: 'logo',
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 48.0,
        child: Image.asset('assets/images/logo.png'),
      ),
    );

    final title = Center(
      child: Text(
        'POS Harapan Bundo',
        style: redTextStyle.copyWith(
          fontSize: 14,
          fontWeight: semiBold,
        ),
      ),
    );

    Widget inputEmail() {
      return CustomTextFormField(
        title: 'Username',
        hintText: 'username',
        textValidator: 'Please enter username',
        keyboardType: TextInputType.text,
        onChanged: (value) {
          loginBloc.add(OnUsernameChanged(username: value));
        },
      );
    }

    Widget inputPassword() {
      return CustomTextFormField(
        title: 'Password',
        hintText: '******',
        // obscureText: true,
        textValidator: 'Please enter password',
        keyboardType: TextInputType.text,
        onChanged: (value) {
          loginBloc.add(OnPasswordChanged(password: value));
        },
      );
    }

    Widget loginButton() {
      return CustomButton(
        color: lightRedColor,
        onPressed: () {
          loginBloc.add(OnTapLogin());
        },
        text: 'Log In',
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status == EnumStatus.success) {
              Go.routeWithPathAndRemove(context: context, path: Routes.home);
            }
          },
          builder: (context, state) {
            if (state.status == EnumStatus.loading) {
              return const CircularProgressIndicator();
            } else if (state.status == EnumStatus.initial) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  logo,
                  const SizedBox(height: 4.0),
                  title,
                  const SizedBox(height: 48.0),
                  inputEmail(),
                  const SizedBox(height: 8.0),
                  inputPassword(),
                  state.message != ''
                      ? Padding(
                          padding: const EdgeInsets.only(left: defaultMargin),
                          child: Text(state.message),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 24.0),
                  loginButton(),
                ],
              );
            } else if (state.status == EnumStatus.failed) {
              return Center(
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
