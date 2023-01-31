import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColors {

  static late Brightness _brightness;

  static void set(Brightness brightness) {
    _brightness = brightness;
  }

  static Color get primary => _wrapCheck(primaryLightAppColor, primaryDarkAppColor);
  static Color get onPrimary => _wrapCheck(onPrimaryLightAppColor, onPrimaryDarkAppColor);
  static Color get primaryContainer => _wrapCheck(primaryContainerLightAppColor, primaryContainerDarkAppColor);
  static Color get onPrimaryContainer => _wrapCheck(onPrimaryContainerLightAppColor, onPrimaryContainerDarkAppColor);

  static Color get secondary => _wrapCheck(secondaryLightAppColor, secondaryDarkAppColor);
  static Color get onSecondary => _wrapCheck(onSecondaryLightAppColor, onSecondaryDarkAppColor);
  static Color get secondaryContainer => _wrapCheck(secondaryContainerLightAppColor, secondaryContainerDarkAppColor);
  static Color get onSecondaryContainer => _wrapCheck(onSecondaryContainerLightAppColor, onSecondaryContainerDarkAppColor);

  static Color get tertiary => _wrapCheck(tertiaryLightAppColor, tertiaryDarkAppColor);
  static Color get onTertiary => _wrapCheck(onTertiaryLightAppColor, onTertiaryDarkAppColor);
  static Color get tertiaryContainer => _wrapCheck(tertiaryContainerLightAppColor, tertiaryContainerDarkAppColor);
  static Color get onTertiaryContainer => _wrapCheck(onTertiaryContainerLightAppColor, onTertiaryContainerDarkAppColor);

  static Color get error => _wrapCheck(errorLightAppColor, errorDarkAppColor);
  static Color get onError => _wrapCheck(onErrorLightAppColor, onErrorDarkAppColor);

  static Color get background => _wrapCheck(backgroundLightAppColor, backgroundDarkAppColor);
  static Color get onBackground => _wrapCheck(onBackgroundLightAppColor, onBackgroundDarkAppColor);

  static Color get surface => _wrapCheck(surfaceLightAppColor, surfaceDarkAppColor);
  static Color get onSurface => _wrapCheck(onSurfaceLightAppColor, onSurfaceDarkAppColor);
  static Color get surfaceVariant => _wrapCheck(surfaceVariantLightAppColor, surfaceVariantDarkAppColor);
  static Color get onSurfaceVariant => _wrapCheck(onSurfaceVariantLightAppColor, onSurfaceVariantDarkAppColor);

  static Color get outline => _wrapCheck(outlineLightAppColor, outlineDarkAppColor);
  static Color get outlineVariant => _wrapCheck(outlineVariantLightAppColor, outlineVariantDarkAppColor);
  static Color get shadow => _wrapCheck(shadowLightAppColor, shadowDarkAppColor);
  static Color get inverseSurface => _wrapCheck(inverseSurfaceLightAppColor, inverseSurfaceDarkAppColor);
  static Color get onInverseSurface => _wrapCheck(onInverseSurfaceLightAppColor, onInverseSurfaceDarkAppColor);
  static Color get inversePrimary => _wrapCheck(inversePrimaryLightAppColor, inversePrimaryDarkAppColor);

  static Color get scrim => _wrapCheck(const Color(0xFFFFFFFF), const Color(0xFF000000));

  static Color _wrapCheck(Color light, Color dark) {
    if (_brightness == Brightness.dark) {
      return dark;
    } else {
      return light;
    }
  }
}

////////////////////LIGHT THEME/////////////////////////
const Color primaryLightAppColor = Color(0xFF006491);
const Color onPrimaryLightAppColor = Color(0xFFFFFFFF);
const Color primaryContainerLightAppColor = Color(0xFFC8E6FF);
const Color onPrimaryContainerLightAppColor = Color(0xFF001E2F);

const Color secondaryLightAppColor = Color(0xFF4F606E);
const Color onSecondaryLightAppColor = Color(0xFFFFFFFF);
const Color secondaryContainerLightAppColor = Color(0xFFD3E5F5);
const Color onSecondaryContainerLightAppColor = Color(0xFF0B1D29);

const Color tertiaryLightAppColor = Color(0xFF64597C);
const Color onTertiaryLightAppColor = Color(0xFFFFFFFF);
const Color tertiaryContainerLightAppColor = Color(0xFFEADDFF);
const Color onTertiaryContainerLightAppColor = Color(0xFF201635);

const Color errorLightAppColor = Color(0xFFB91A1A);
const Color onErrorLightAppColor = Color(0xFFFFFFFF);

const Color backgroundLightAppColor = Color(0xFFFCFCFF);
const Color onBackgroundLightAppColor = Color(0xFF181C1E);

const Color surfaceLightAppColor = Color(0xFFFCFCFF);
const Color onSurfaceLightAppColor = Color(0xFF181C1E);
const Color surfaceVariantLightAppColor = Color(0xFFDDE3EB);
const Color onSurfaceVariantLightAppColor = Color(0xFF41474D);

const Color outlineLightAppColor = Color(0xFF71787E);
const Color outlineVariantLightAppColor = Color(0xFF8B9199);
const Color shadowLightAppColor = Color(0xFFFFFFFF);
const Color inverseSurfaceLightAppColor = Color(0xFF2E3133);
const Color onInverseSurfaceLightAppColor = Color(0xFFF0F0F3);
const Color inversePrimaryLightAppColor = Color(0xFF8ACEFF);

////////////////////DARK THEME/////////////////////////

const Color primaryDarkAppColor = Color(0xFF8ACEFF);
const Color onPrimaryDarkAppColor = Color(0xFF00344D);
const Color primaryContainerDarkAppColor = Color(0xFF004C6E);
const Color onPrimaryContainerDarkAppColor = Color(0xFFC8E6FF);

const Color secondaryDarkAppColor = Color(0xFFB7C9D9);
const Color onSecondaryDarkAppColor = Color(0xFF20323F);
const Color secondaryContainerDarkAppColor = Color(0xFF374956);
const Color onSecondaryContainerDarkAppColor = Color(0xFFD3E5F5);

const Color tertiaryDarkAppColor = Color(0xFFCFC0E8);
const Color onTertiaryDarkAppColor = Color(0xFF352B4B);
const Color tertiaryContainerDarkAppColor = Color(0xFF4C4163);
const Color onTertiaryContainerDarkAppColor = Color(0xFFEADDFF);

const Color errorDarkAppColor = Color(0xFFFFB4AB);
const Color onErrorDarkAppColor = Color(0xFF690005);

const Color backgroundDarkAppColor = Color(0xFF181C1E);
const Color onBackgroundDarkAppColor = Color(0xFFE2E2E5);

const Color surfaceDarkAppColor = Color(0xFF181C1E);
const Color onSurfaceDarkAppColor = Color(0xFFE2E2E5);
const Color surfaceVariantDarkAppColor = Color(0xFFDDE3EB);
const Color onSurfaceVariantDarkAppColor = Color(0xFF41474D);

const Color outlineDarkAppColor = Color(0xFF8B9199);
const Color outlineVariantDarkAppColor = Color(0xFF71787E);
const Color shadowDarkAppColor = Color(0xFFFFFFFF);
const Color inverseSurfaceDarkAppColor = Color(0xFFE2E2E5);
const Color onInverseSurfaceDarkAppColor = Color(0xFF2E3133);
const Color inversePrimaryDarkAppColor = Color(0xFF006491);