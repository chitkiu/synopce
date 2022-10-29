import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'icons_constants.dart';

Future<T?> showLoadingDialog<T>(BuildContext context) {
  // CupertinoActivityIndicator
  return _wrappedShowDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (_) {
        return Dialog(
          // The background color
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The loading indicator
                loadingIcon(size: 20),
                const SizedBox(
                  height: 15,
                ),
                // Some text
                const Text('Loading...')
              ],
            ),
          ),
        );
      });
}

Future<T?> _wrappedShowDialog<T>(
    {required BuildContext context,
    required WidgetBuilder builder,
    bool? barrierDismissible}) {
  if (Platform.isIOS) {
    return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? true);
  } else {
    return showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? true);
  }
}
