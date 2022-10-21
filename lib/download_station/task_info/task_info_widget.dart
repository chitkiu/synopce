import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';

import '../../extensions/format_byte.dart';

class TaskInfoWidget extends StatelessWidget {
  final TaskInfoDetailModel _model;

  const TaskInfoWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var downloaded = _model.additional?.transfer?.sizeDownloaded;
    return ListView(
      shrinkWrap: true,
      children: [
        Text("Name: ${_model.title}"),
        Text("Status: ${_model.status}"),
        Text("Size: ${formatBytes(_model.size ?? 0, 2)}"),
        if (_model.additional?.detail?.destination != null)
          Text("Destination: ${_model.additional?.detail?.destination}"),
        if (downloaded != null && downloaded != 0 && _model.size != 0)
          Text(
              "Percent: ${double.parse((downloaded / _model.size * 100).toStringAsFixed(2))}"),
      ],
    );
  }
}
