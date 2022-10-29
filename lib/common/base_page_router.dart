import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Route<T> pageRoute<T>({required WidgetBuilder builder}) {
  if (Platform.isIOS) {
    return CupertinoPageRoute<T>(builder: builder);
  } else {
    return MaterialPageRoute<T>(builder: builder);
  }
}