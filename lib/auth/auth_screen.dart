import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'auth_widget.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _mobileWidget(),
      tablet: _desktopWidget(context),
      desktop: _desktopWidget(context),
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

  Widget _desktopWidget(BuildContext context) {
    return PlatformScaffold(
      backgroundColor: Colors.lightBlue,
      body: Align(
        alignment: AlignmentDirectional.center,
        child: Container(
            color: _getDesktopWidgetBackground(context),
            padding: const EdgeInsets.only(bottom: 10),
            child: SizedBox(width: 350, child: AuthWidget())),
      ),
    );
  }

  Color _getDesktopWidgetBackground(BuildContext context) {
    return isMaterial(context)
        ? Theme.of(context).backgroundColor
        : CupertinoTheme.of(context).scaffoldBackgroundColor;
  }
}
