import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';

import '../../common/text_constants.dart';
import '../../extensions/format_byte.dart';

class TaskItemWidget extends StatelessWidget {
  final TaskInfoDetailModel model;

  const TaskItemWidget(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    var firstAdditionalInfo = _buildInfoString(model);
    var secondAdditionalInfo = _buildSecondInfoString(model);

    return Column(
      children: [
        Text(
          model.title,
          style: AppDefaultTextStyle,
        ),
        if (firstAdditionalInfo.children?.isNotEmpty == true)
          RichText(text: firstAdditionalInfo),
        RichText(text: secondAdditionalInfo),
      ],
    );
  }

  TextSpan _buildInfoString(TaskInfoDetailModel model) {
    var resultString = <InlineSpan>[];
    resultString.add(
      TextSpan(text: model.status.name),
    );

    var downloaded = model.additional?.transfer?.sizeDownloaded;
    if (downloaded != null) {
      var percent =
          double.parse((downloaded / model.size * 100).toStringAsFixed(2));
      if (percent.isNaN) {
        percent = 0;
      }
      resultString.add(TextSpan(text: " · $percent%"));
    }

    if (downloaded != null) {
      var sizeString = formatBytes(model.size, 1);
      if (downloaded == model.size) {
        resultString.add(TextSpan(text: " · $sizeString"));
      } else {
        resultString.add(
            TextSpan(text: " · ${formatBytes(downloaded, 1)}/$sizeString"));
      }
    }

    return TextSpan(style: AppGreySmallTextStyle, children: resultString);
  }

  TextSpan _buildSecondInfoString(TaskInfoDetailModel model) {
    var resultString = <InlineSpan>[];

    if (model.status == TaskInfoDetailStatus.DOWNLOADING) {
      var speedDownload = model.additional?.transfer?.speedDownload;
      if (speedDownload != null) {
        resultString
            .add(TextSpan(text: " ⬇️ ${formatBytes(speedDownload, 1)}/s"));
      }

      var speedUpload = model.additional?.transfer?.speedUpload;
      if (speedUpload != null) {
        resultString
            .add(TextSpan(text: "  ⬆️ ${formatBytes(speedUpload, 1)}/s"));
      }
    }

    return TextSpan(style: AppGreySmallTextStyle, children: resultString);
  }
}
