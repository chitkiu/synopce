import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../sdk.dart';
import 'task_info_widget.dart';

class TaskInfoScreen extends StatelessWidget {
  final Task _model;

  const TaskInfoScreen(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Info about task'),
      ),
      body: SafeArea(
        child: StreamBuilder(
          stream: SDK.instance.updater.subscribeForSelectedTask(_model.id)
              .map((event) => _DataWrapper(false, event)),
          initialData: _DataWrapper(true, null),
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data == null) {
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
              return PlatformScaffold();
            }
            var taskData = snapshot.data!;
            if (taskData.isInit) {
              return PlatformScaffold();
            } else if (taskData.task != null) {
              return TaskInfoWidget(taskData.task!);
            } else {
              Future.delayed(Duration.zero, () {
                Navigator.pop(context);
              });
              return PlatformScaffold();
            }
          },
        ),
      ),
    );
  }
}

class _DataWrapper {
  final bool isInit;
  final Task? task;

  _DataWrapper(this.isInit, this.task);
}
