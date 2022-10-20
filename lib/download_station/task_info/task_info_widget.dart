import 'dart:math';

import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';

class TaskInfoWidget extends StatelessWidget {
  final TaskInfoDetailModel model;

  const TaskInfoWidget(this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var downloaded = model.additional?.transfer?.sizeDownloaded;
    return ListView(
      shrinkWrap: true,
      children: [
        Text("Name: ${model.title}"),
        Text("Status: ${model.status}"),
        Text("Size: ${_formatBytes(model.size, 2)}"),
        if (model.additional?.detail?.destination != null)
          Text("Destination: ${model.additional?.detail?.destination}"),
        if (downloaded != null && downloaded != 0 && model.size != 0)
          Text(
              "Percent: ${double.parse(
                  (downloaded / model.size * 100).toStringAsFixed(2))}"),
      ],
    );
  }

  String _formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
}
