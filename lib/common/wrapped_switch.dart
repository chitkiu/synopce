import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WrappedSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const WrappedSwitch({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoSwitch(
        onChanged: onChanged,
        value: value,
      );
    } else {
      return Switch(
        onChanged: onChanged,
        value: value,
      );
    }
  }
}
