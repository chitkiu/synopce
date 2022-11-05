import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
          backgroundColor: (isMaterial(context) ? Theme.of(context).dialogBackgroundColor : CupertinoTheme.of(context).barBackgroundColor),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // The loading indicator
                loadingIcon(context, size: 20),
                const SizedBox(
                  height: 15,
                ),
                // Some text
                Text('Loading...', style: (isMaterial(context) ? Theme.of(context).textTheme.bodyText1 : CupertinoTheme.of(context).textTheme.textStyle),)
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
  if (isMaterial(context)) {
    return showDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? true);
  } else {
    return showCupertinoDialog<T>(
        context: context,
        builder: builder,
        barrierDismissible: barrierDismissible ?? true);
  }
}
