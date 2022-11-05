import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'auth_widget.dart';

class AuthScreenWidget extends StatelessWidget {
  const AuthScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _mobileWidget(),
      tablet: _desktopWidget(),
      desktop: _desktopWidget(),
    );
  }

  Widget _mobileWidget() {
    return PlatformScaffold(
      body: Align(
        alignment: AlignmentDirectional.center,
        child: AuthWidget(),
      ),
    );
  }

  Widget _desktopWidget() {
    return PlatformScaffold(
      backgroundColor: Colors.lightBlue,
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Container(
            color: Colors.white,
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(width: 350, child: AuthWidget())),
      ),
    );
  }
}
