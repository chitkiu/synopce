import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../common/loading_dialog_widget.dart';

Future<void> executeWithLoadingDialog<T>(Future<T?> Function() action,
    {Function(T?)? actionWithResult}) async {

  showPlatformDialog(
    context: Get.overlayContext!,
    builder: (context) => const LoadingDialogWidget(),
    barrierDismissible: false,
  );

  var result = await action();

  Navigator.of(Get.overlayContext!).pop();

  if (actionWithResult != null) {
    actionWithResult(result);
  }
}
