import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class AppBaseTextStyle {
  static BuildContext get _context => Get.context!;

  static CupertinoThemeData get _cupertinoTheme => CupertinoTheme.of(_context);

  static TextStyle get mainStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.bodyMedium!;
    } else {
      return _cupertinoTheme.textTheme.textStyle;
    }
  }

  static TextStyle get submainStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.bodySmall!;
    } else {
      return const TextStyle(
        fontSize: 12,
      );
    }
  }
}