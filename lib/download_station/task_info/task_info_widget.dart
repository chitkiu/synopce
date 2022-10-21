import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';

import '../../extensions/format_byte.dart';
import '../../sdk.dart';

class TaskInfoWidget extends StatefulWidget {
  final String _modelId;

  const TaskInfoWidget(this._modelId, {Key? key}) : super(key: key);

  @override
  State<TaskInfoWidget> createState() => _TaskInfoWidgetState();
}

class _TaskInfoWidgetState extends State<TaskInfoWidget> {
  TaskInfoDetailModel? _model;
  final tasksValueListener = SDK().tasksValueListener;

  _TaskInfoWidgetState();

  @override
  void initState() {
    super.initState();
    _updateModel();
    tasksValueListener.addListener(_updateModel);
  }


  @override
  void dispose() {
    tasksValueListener.removeListener(_updateModel);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_model == null) {
      return const Text("Loading...");
    }
    var downloaded = _model?.additional?.transfer?.sizeDownloaded;
    var size = _model?.size ?? 0;
    return ListView(
      shrinkWrap: true,
      children: [
        Text("Name: ${_model?.title}"),
        Text("Status: ${_model?.status}"),
        Text("Size: ${formatBytes(_model?.size ?? 0, 2)}"),
        if (_model?.additional?.detail?.destination != null)
          Text("Destination: ${_model?.additional?.detail?.destination}"),
        if (downloaded != null && downloaded != 0 && size != 0)
          Text(
              "Percent: ${double.parse((downloaded / size * 100).toStringAsFixed(2))}"),
      ],
    );
  }

  void _updateModel() {
    setState(() {
      _model = tasksValueListener.value.firstWhere((element) => element.id == widget._modelId);
    });
  }
}
