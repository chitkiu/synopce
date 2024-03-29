import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../ui/icons_constants.dart';

Future<T> executeWithLoadingDialog<T>(Future<T> Function() action,
    {Function(T)? actionWithResult}) async {
  showPlatformDialog(
    context: Get.overlayContext!,
    builder: (context) => const _LoadingDialogWidget(),
    barrierDismissible: false,
  );

  var result = await action();

  Navigator.of(Get.overlayContext!).pop();

  if (actionWithResult != null) {
    actionWithResult(result);
  }

  return result;
}

class _LoadingDialogWidget extends StatelessWidget {
  const _LoadingDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // The background color
      backgroundColor: (isMaterial(context)
          ? Theme.of(context).dialogBackgroundColor
          : CupertinoTheme.of(context).barBackgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The loading indicator
            progressIcon(context, size: 20),
            const SizedBox(
              height: 15,
            ),
            // Some text
            Text(
              'Loading...',
              style: (isMaterial(context)
                  ? Theme.of(context).textTheme.bodyText1
                  : CupertinoTheme.of(context).textTheme.textStyle),
            )
          ],
        ),
      ),
    );
  }
}
