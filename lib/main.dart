import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'app_route_type.dart';
import 'auth/data/auth_service/auth_service.dart';
import 'auth/data/auth_service/backend_auth_service.dart';
import 'auth/domain/auth_screen_binding.dart';
import 'auth/ui/auth_screen.dart';
import 'common/data/api_service.dart';
import 'common/data/dependencies_service.dart';
import 'main_screen/ui/main_screen.dart';

void main() async {
  if (kDebugMode) {
    Logger.root.level = Level.ALL; // defaults to Level.INFO
    Logger.root.onRecord.listen((record) {
      debugPrint('${record.level.name}: ${record.time}: ${record.message}');
    });
  }
  initDependency();
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://98e240e589ba4e0e89eb514778100d12@o4504583066091520.ingest.sentry.io/4504583076708352';
      options.tracesSampleRate = 1.0;
    },
    appRunner: () => runApp(const MyApp()),
  );
}

///Do not remove cast to abstract class for compatibility with demo mode
//TODO Add demo mode
void initDependency() {
  Get.lazyPut(() {
    return BackendAuthService((apiContext) {
      Get.find<ApiService>().init(apiContext);
    }) as AuthService;
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
