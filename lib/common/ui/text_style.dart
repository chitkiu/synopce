import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

class AppBaseTextStyle {
  static BuildContext get _context => Get.context!;

  static CupertinoThemeData get _cupertinoTheme => CupertinoTheme.of(_context);

  static TextStyle get appBarTitleStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.titleLarge!;
    } else {
      return _cupertinoTheme.textTheme.textStyle.copyWith(
        fontSize: 20,
      );
    }
  }

  static TextStyle get titleStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.titleSmall!;
    } else {
      return _cupertinoTheme.textTheme.textStyle.copyWith(
        fontSize: 16,
      );
    }
  }

  static TextStyle get titleBoldStyle => titleStyle.makeBold();

  static TextStyle get mainStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.bodyMedium!;
    } else {
      return _cupertinoTheme.textTheme.textStyle;
    }
  }

  static TextStyle get mainBoldStyle => mainStyle.makeBold();

  static TextStyle get submainStyle {
    if (isMaterial(_context)) {
      return Get.textTheme.bodySmall!;
    } else {
      return _cupertinoTheme.textTheme.textStyle.copyWith(
        fontSize: 12,
      );
    }
  }
}

extension _FontStyleExt on TextStyle {
  TextStyle makeBold() {
    return copyWith(
      fontWeight: FontWeight.bold
    );
  }
}