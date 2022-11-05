import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'task_info_widget.dart';

class TaskInfoScreenWidget extends StatelessWidget {
  final TaskInfoDetailModel? _model;

  const TaskInfoScreenWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: _mobileWidget(context),
      tablet: _desktopWidget(),
      desktop: _desktopWidget(),
    );
  }

  Widget _mobileWidget(BuildContext context) {
    if (_model == null) {
      Future.delayed(Duration.zero, () {
        Navigator.pop(context);
      });
    }
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Info about task'),
      ),
      body: _wrappedDataWidget(_model),
    );
  }

  Widget _desktopWidget() {
    return _wrappedDataWidget(_model);
  }

  Widget _wrappedDataWidget(TaskInfoDetailModel? model) {
    if (model == null) {
      return const Align(
        alignment: AlignmentDirectional.center,
        child: Text("Select item"),
      );
    }
    return TaskInfoWidget(model);
  }
}
