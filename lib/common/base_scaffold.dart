import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final Widget? barWidget;
  final Widget? actionButtonIcon;
  final VoidCallback? onPressed;

  const BaseScaffold(
      {required this.child,
      this.backgroundColor,
      this.barWidget,
      this.actionButtonIcon,
      this.onPressed,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoPageScaffold(
        navigationBar: ((barWidget != null)
            ? CupertinoNavigationBar(
                middle: barWidget,
                trailing: GestureDetector(
                  onTap: onPressed,
                  child: actionButtonIcon,
                ),
              )
            : null),
        backgroundColor: backgroundColor,
        child: child,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: barWidget,
        ),
        backgroundColor: backgroundColor,
        body: child,
        floatingActionButton:
            FloatingActionButton(onPressed: onPressed, child: actionButtonIcon),
      );
    }
  }
}
