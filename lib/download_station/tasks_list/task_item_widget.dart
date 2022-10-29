import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';

import '../../extensions/format_byte.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskInfoDetailModel model;
  final Function(TaskInfoDetailModel) onClick;

  const TaskItemWidget(this.model, this.onClick, {super.key});

  @override
  Widget build(BuildContext context) {
    var additionalInfo = _buildInfoString(model);
    return GestureDetector(
      onTap: () {
        onClick(model);
      },
      child: Column(
        children: [
          Text(
            model.title,
            style: const TextStyle(fontSize: 14),
          ),
          RichText(
              text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                  children: [
                WidgetSpan(
                    child: Icon(
                  Icons.circle,
                  size: 13,
                  color: _getIconColor(model.status),
                )),
                TextSpan(text: '${model.status}')
              ])),
          if (additionalInfo.children?.isNotEmpty == true)
            RichText(text: additionalInfo),
          const Divider(height: 1, color: Colors.black),
        ],
      ),
    );
  }

  TextSpan _buildInfoString(TaskInfoDetailModel model) {
    var resultString = <InlineSpan>[];

    if (model.status == TaskInfoDetailStatus.DOWNLOADING) {
      resultString.addAll(_getAdditionalInfoForDownloadingStatus(model));
    }

    return TextSpan(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 14.0,
        ),
        children: resultString);
  }

  Color _getIconColor(TaskInfoDetailStatus status) {
    switch (status) {
      case TaskInfoDetailStatus.UNKNOWN:
        return Colors.grey;
      case TaskInfoDetailStatus.DOWNLOADING:
        return Colors.lightBlue;
      case TaskInfoDetailStatus.ERROR:
        return Colors.red;
      case TaskInfoDetailStatus.FINISHED:
        return Colors.green;
      case TaskInfoDetailStatus.HASH_CHEKING:
      case TaskInfoDetailStatus.PAUSED:
      case TaskInfoDetailStatus.WAITING:
        return Colors.orange;
    }
  }

  List<InlineSpan> _getAdditionalInfoForDownloadingStatus(
      TaskInfoDetailModel model) {
    var resultList = <InlineSpan>[];

    var downloaded = model.additional?.transfer?.sizeDownloaded;
    if (downloaded != null && downloaded != 0 && model.size != 0) {
      resultList.add(TextSpan(
          text:
              "Percent: ${double.parse((downloaded / model.size * 100).toStringAsFixed(2))}"));
    }
    var speedDownload = model.additional?.transfer?.speedDownload;
    if (speedDownload != null) {
      if (resultList.isNotEmpty) {
        resultList.add(const TextSpan(text: " - "));
      }
      resultList.add(const WidgetSpan(
          child: Icon(
        Icons.download,
        color: Colors.grey,
        size: 14,
      )));
      resultList.add(TextSpan(text: "${formatBytes(speedDownload, 2)}/s"));
    }
    var speedUpload = model.additional?.transfer?.speedUpload;
    if (speedUpload != null) {
      if (resultList.isNotEmpty) {
        resultList.add(const TextSpan(text: " - "));
      }
      resultList.add(const WidgetSpan(
          child: Icon(
        Icons.upload,
        color: Colors.grey,
        size: 14,
      )));
      resultList.add(TextSpan(text: "${formatBytes(speedUpload, 2)}/s"));
    }

    return resultList;
  }
}
