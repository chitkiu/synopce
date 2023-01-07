import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'loading_dialog_widget.dart';

Future<T?> showLoadingDialog<T>(BuildContext context) {
  // CupertinoActivityIndicator
  return _wrappedShowDialog(
      // The user CANNOT close this dialog  by pressing outsite it
      barrierDismissible: false,
      context: context,
      builder: (localContext) {
        return const LoadingDialogWidget();
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
