import 'package:wifi_colposcope/login_widget.dart';
import 'package:flutter/material.dart';
import 'package:wifi_colposcope/signup_widget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) {
    return isLogin
        ? LoginWidget(
            onClickedSignUp: toggle,
          )
        : SignupWidget(
            onClickedSignIn: toggle,
          );
  }

  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }
}
