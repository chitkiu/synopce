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
import 'common/ui/colors.dart';
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
    AppColors.set(brightness);
    if (isMaterial(context)) {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: _getMaterialTheme(brightness),
        initialRoute: AppRouteType.auth.route,
        getPages: _getPages(),
      );
    } else {
      return GetCupertinoApp(
        title: 'Flutter Demo',
        theme: _getCupertinoTheme(brightness),
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

CupertinoThemeData _getCupertinoTheme(Brightness brightness) {
  return CupertinoThemeData(
    brightness: brightness,
    primaryColor: AppColors.primary,
    barBackgroundColor: AppColors.background,
    primaryContrastingColor: AppColors.onPrimary,
    scaffoldBackgroundColor: AppColors.surface,
  );
}

ThemeData _getMaterialTheme(Brightness brightness) {
  return ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,

      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.onPrimaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,

      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,

      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,

      error: AppColors.error,
      onError: AppColors.onError,

      background: AppColors.background,
      onBackground: AppColors.onBackground,

      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceVariant: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,

      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      inverseSurface: AppColors.inverseSurface,
      onInverseSurface: AppColors.onInverseSurface,
      inversePrimary: AppColors.inversePrimary,

      scrim: AppColors.scrim,
    ),
    useMaterial3: true,
  );
}
