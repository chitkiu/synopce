import 'package:flutter/material.dart';

const TextStyle AppDefaultTextStyle = TextStyle(
  fontSize: 16,
);

const TextStyle AppSmallTextStyle = TextStyle(
  fontSize: 14,
);

const TextStyle AppGreySmallTextStyle = TextStyle(
  fontSize: 14,
  color: Colors.grey,
);

final TextStyle AppColoredTextStyle = TextStyle(
  color: _getBrightnessColor(),
);

Color _getBrightnessColor() {
  Brightness brightness = WidgetsBinding.instance.window.platformBrightness;

  if (brightness == Brightness.light) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}
