import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter/material.dart';

import '../task_info/task_info_widget.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskInfoDetailModel model;

  const TaskItemWidget({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    var downloaded = model.additional?.transfer?.sizeDownloaded;
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskInfoWidget(model)),
        );
      },
      child: Column(
        children: [
          Text(model.title),
          Row(
            children: [
              Text('status: ${model.status}'),
              const Spacer(),
              if (model.additional?.detail?.destination != null)
                Text('destination: ${model.additional?.detail?.destination}'),
            ],
          ),
          if (downloaded != null && downloaded != 0 && model.size != 0)
            Text(
                "Percent: ${double.parse((downloaded / model.size * 100).toStringAsFixed(2))}"),
          const Divider(height: 1, color: Colors.black),
        ],
      ),
    );
  }
}
