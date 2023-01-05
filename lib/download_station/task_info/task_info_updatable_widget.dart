import 'package:flutter/widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../sdk.dart';
import 'task_info_widget.dart';

class TaskInfoUpdatableWidget extends StatelessWidget {
  final Task _selectedTask;

  const TaskInfoUpdatableWidget(this._selectedTask, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: SDK.instance.updater.subscribeForSelectedTask(_selectedTask.id),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Container();
        }
        return TaskInfoWidget(snapshot.data!);
      },
    );
  }
}
