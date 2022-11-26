import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import 'task_info_widget.dart';

class TaskInfoScreenWidget extends StatelessWidget {
  final Task? _model;

  const TaskInfoScreenWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
      return PlatformScaffold();
    }
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Info about task'),
      ),
      body: SafeArea(
        child: TaskInfoWidget(_model!),
      ),
    );
  }
}
