import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

void showSnackBar(
    BuildContext context,
    String message,
) {
  if (isMaterial(context)) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  } else {
    _showCupertinoSnackBar(
      context: context,
      message: message,
    );
  }
}

void _showCupertinoSnackBar({
  required BuildContext context,
  required String message,
  int durationMillis = 3000,
}) {
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom: 8.0,
      left: 8.0,
      right: 8.0,
      child: CupertinoPopupSurface(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 8.0,
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 14.0,
              color: CupertinoColors.secondaryLabel,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    ),
  );
  Future.delayed(
    Duration(milliseconds: durationMillis),
        () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    },
  );
  Overlay.of(Navigator.of(context).context)?.insert(overlayEntry);
}