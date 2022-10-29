import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget doneIcon(BuildContext context, {Color? color}) {
  if (Platform.isIOS) {
    return Icon(
      CupertinoIcons.checkmark_alt,
      color: color ?? CupertinoTheme.of(context).primaryColor,
    );
  } else {
    return Icon(
      Icons.done,
      color: color,
    );
  }
}

Widget addIcon(BuildContext context, {Color? color}) {
  if (Platform.isIOS) {
    return Icon(
      CupertinoIcons.add,
      color: color ?? CupertinoTheme.of(context).primaryColor,
    );
  } else {
    return Icon(
      Icons.add,
      color: color,
    );
  }
}
