import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:synopce/auth/data/auth_service/backend_auth_service.dart';
import 'package:synopce/common/data/api_service.dart';

import 'app_route_type.dart';
import 'auth/data/auth_service/auth_service.dart';
import 'auth/domain/auth_screen_binding.dart';
import 'auth/ui/auth_screen.dart';
import 'common/data/dependencies_service.dart';
import 'main_screen/domain/main_screen_binding.dart';
import 'main_screen/ui/main_screen.dart';

void main() {
  if (kDebugMode) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
  initDependency();
  runApp(const MyApp());
}

/**
 * Do not remove cast to abstract class for compatibility with demo mode
 * TODO Add demo mode
 */
void initDependency() {
  Get.lazyPut(() {
    return BackendAuthService((apiContext) {
      Get.find<ApiService>().init(apiContext);
    }, () {}) as AuthService;
  });
  Get.lazyPut(() => ApiService());
  Get.lazyPut(() => DependenciesService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Brightness brightness = WidgetsBinding.instance.window.platformBrightness;
    if (isMaterial(context)) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: (brightness == Brightness.light)
            ? _lightMaterialTheme
            : _darkMaterialTheme,
        initialRoute: AppRouteType.auth.route,
        getPages: _getPages(),
      );
    } else {
      return GetCupertinoApp(
        title: 'Flutter Demo',
        theme: (brightness == Brightness.light)
            ? _lightCupertinoTheme
            : _darkCupertinoTheme,
        initialRoute: AppRouteType.auth.route,
        getPages: _getPages(),
      );
    }
  }

  List<GetPage> _getPages() {
    return [
      GetPage(
          name: AppRouteType.auth.route,
          page: () => const AuthScreen(),
          binding: AuthScreenBinding()),
      GetPage(
        name: AppRouteType.main.route,
        page: () => const MainScreen(),
        binding: MainScreenBinding(),
      ),
    ];
  }
}

final ThemeData _lightMaterialTheme =
    ThemeData.from(colorScheme: const ColorScheme.light());

final ThemeData _darkMaterialTheme =
    ThemeData.from(colorScheme: const ColorScheme.dark());

const CupertinoThemeData _lightCupertinoTheme = CupertinoThemeData(
  brightness: Brightness.light,
);

const CupertinoThemeData _darkCupertinoTheme = CupertinoThemeData(
  brightness: Brightness.dark,
);
