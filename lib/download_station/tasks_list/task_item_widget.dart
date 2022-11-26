import 'package:flutter/material.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/text_constants.dart';
import '../../extensions/format_byte.dart';

class TaskItemWidget extends StatelessWidget {
  final Task model;

  const TaskItemWidget(this.model, {super.key});

  @override
  Widget build(BuildContext context) {
    var firstAdditionalInfo = _buildInfoString(model);
    var secondAdditionalInfo = _buildSecondInfoString(model);

    return Column(
      children: [
        Text(
          model.title ?? "",
          style: AppDefaultTextStyle,
        ),
        if (firstAdditionalInfo.children?.isNotEmpty == true)
          RichText(text: firstAdditionalInfo),
        if (secondAdditionalInfo.children?.isNotEmpty == true)
          RichText(text: secondAdditionalInfo),
      ],
    );
  }

  TextSpan _buildInfoString(Task model) {
    var resultString = <InlineSpan>[];
    if (model.status != null) {
      resultString.add(
        TextSpan(text: model.status?.toString()),
      );
    }

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

    return TextSpan(style: AppGreySmallTextStyle, children: resultString);
  }

  TextSpan _buildSecondInfoString(Task model) {
    var resultString = <InlineSpan>[];

    if (model.status == TaskStatus.downloading) {
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
