import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'task_info_widget.dart';

class TaskInfoScreenWidget extends StatelessWidget {
  final TaskInfoDetailModel _model;

  const TaskInfoScreenWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _mobileWidget(),
      tablet: _desktopWidget(),
      desktop: _desktopWidget(),
    );
  }

  Widget _mobileWidget() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Info about task'),
      ),
      body: TaskInfoWidget(_model),
    );
  }

  Widget _desktopWidget() {
    return TaskInfoWidget(_model);
  }
}
