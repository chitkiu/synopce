import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/sdk.dart';
import 'task_info_widget.dart';

class TaskInfoScreen extends StatelessWidget {
  final String? _modelId;

  const TaskInfoScreen(this._modelId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text("Info about task"),
      ),
      body: SafeArea(
        child: Obx(
          () {
            Task? task = SDK.instance.repository.tasks.value?[_modelId];
            if (task == null) {
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
              return Container();
            } else {
              return TaskInfoWidget(task);
            }
          },
        ),
      ),
    );
  }
}
