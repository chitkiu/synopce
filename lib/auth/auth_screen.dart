import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'login_widget.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthState();
}

class _AuthState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _mobileWidget(),
      tablet: _desktopWidget(),
      desktop: _desktopWidget(),
    );
  }

  Widget _mobileWidget() {
    return const Scaffold(
      body: Align(
        alignment: AlignmentDirectional.center,
        child: LoginWidget(),
      ),
    );
  }

  Widget _desktopWidget() {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: const SizedBox(width: 350, child: LoginWidget())),
      ),
    );
  }
}
