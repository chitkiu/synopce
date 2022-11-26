import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'auth/auth_screen_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    if (isMaterial(context)) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: (brightness == Brightness.light) ? _lightMaterialTheme : _darkMaterialTheme,
        home: const AuthScreenWidget(),
      );
    } else {
      return CupertinoApp(
        title: 'Flutter Demo',
        theme: (brightness == Brightness.light) ? _lightCupertinoTheme : _darkCupertinoTheme,
        home: const AuthScreenWidget(),
      );
    }
  }
}

var _lightMaterialTheme = ThemeData.from(
    colorScheme: const ColorScheme.light()
);

var _darkMaterialTheme = ThemeData.from(
  colorScheme: const ColorScheme.dark()
);

const CupertinoThemeData _lightCupertinoTheme = CupertinoThemeData(
  brightness: Brightness.light,
);

const CupertinoThemeData _darkCupertinoTheme = CupertinoThemeData(
  brightness: Brightness.dark,
);
