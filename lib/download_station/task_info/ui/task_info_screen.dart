import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/ui/app_bar_title.dart';
import '../../tasks_list/data/tasks_info_storage.dart';
import 'task_info_widget.dart';

class TaskInfoScreen extends StatelessWidget {
  final String? _modelId;

  const TaskInfoScreen(this._modelId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const AppBarTitle("Info about task"),
      ),
      body: SafeArea(
        child: Obx(
          () {
            DownloadStationTask? task = TasksInfoStorage.storage.tasks.value?[_modelId];
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
