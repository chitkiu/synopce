import 'package:flutter/painting.dart';
import 'package:synoapi/synoapi.dart';

import '../../../../common/extensions/format_byte.dart';
import '../../../../common/ui/text_style.dart';
import '../models/task_ui_model.dart';

class TaskUIMapper {
  const TaskUIMapper();

  TaskUIModel map(DownloadStationTask task) {
    return TaskUIModel(
      id: task.id,
      title: task.title ?? '',
      subtitle: _buildInfoString(task),
    );
  }

  TextSpan _buildInfoString(DownloadStationTask model) {
    var resultString = <InlineSpan>[
      TextSpan(text: model.status.toString())
    ];

    var downloaded = model.additional?.transfer?.sizeDownloaded;
    if (downloaded != null && model.size != null) {
      var percent =
      double.parse((downloaded / (model.size ?? 1) * 100).toStringAsFixed(2));
      if (percent.isNaN) {
        percent = 0;
      }
      resultString.add(TextSpan(text: " · $percent%"));
    }

    if (downloaded != null && model.size != null) {
      var sizeString = formatBytes(model.size ?? 0, 1);
      if (downloaded == model.size) {
        resultString.add(TextSpan(text: " · $sizeString"));
      } else {
        resultString.add(
            TextSpan(text: " · ${formatBytes(downloaded, 1)}/$sizeString"));
      }
    }

    return TextSpan(style: AppBaseTextStyle.submainStyle, children: resultString);
  }
}