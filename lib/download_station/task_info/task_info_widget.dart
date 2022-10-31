import 'package:dsm_app/common/text_constants.dart';
import 'package:dsm_app/sdk.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';

import '../../common/wrapped_button.dart';
import '../../extensions/format_byte.dart';

class TaskInfoWidget extends StatelessWidget {
  final TaskInfoDetailModel _model;

  const TaskInfoWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var downloaded = _model.additional?.transfer?.sizeDownloaded;
    var actionButton = _getButtonByState();
    var needToShowDownloadSpeed = _model.status == TaskInfoDetailStatus.DOWNLOADING;
    var speedDownload = _model.additional?.transfer?.speedDownload;
    var speedUpload = _model.additional?.transfer?.speedUpload;
    var downloadedSize = _model.additional?.transfer?.sizeDownloaded;
    return ListView(
      shrinkWrap: true,
      children: [
        Text("Name: ${_model.title}", style: AppDefaultTextStyle,),
        Text("Status: ${_model.status}", style: AppDefaultTextStyle,),
        Text("Total size: ${formatBytes(_model.size, 2)}", style: AppDefaultTextStyle,),
        if (downloadedSize != null) Text("Downloaded size: ${formatBytes(downloadedSize, 2)}", style: AppDefaultTextStyle,),
        if (needToShowDownloadSpeed && speedDownload != null) Text("Download speed: ${formatBytes(speedDownload, 2)}/s", style: AppDefaultTextStyle,),
        if (needToShowDownloadSpeed && speedUpload != null) Text("Upload speed: ${formatBytes(speedUpload, 2)}/s", style: AppDefaultTextStyle,),
        if (_model.additional?.detail?.destination != null)
          Text("Destination: ${_model.additional?.detail?.destination}", style: AppDefaultTextStyle,),
        if (downloaded != null && downloaded != 0 && _model.size != 0)
          Text(
              "Percent: ${double.parse((downloaded / _model.size * 100).toStringAsFixed(2))}", style: AppDefaultTextStyle,),
        if (actionButton != null) const SizedBox(height: 30),
        if (actionButton != null) actionButton,
        const SizedBox(height: 30),
        WrappedButton(
          onPressed: () {
            SDK.instance.sdk.dsSDK.deleteTask(ids: [_model.id]);
          },
          text: 'Delete',
        ),
      ],
    );
  }

  Widget? _getButtonByState() {
    String text;
    VoidCallback onPressed;
    if (_model.status == TaskInfoDetailStatus.PAUSED) {
      text = "Resume";
      onPressed = () async {
        await SDK.instance.sdk.dsSDK.resumeTask(ids: [_model.id]);
      };
    } else if (_model.status == TaskInfoDetailStatus.DOWNLOADING ||
        _model.status == TaskInfoDetailStatus.WAITING) {
      text = "Pause";
      onPressed = () async {
        await SDK.instance.sdk.dsSDK.pauseTask(ids: [_model.id]);
      };
    } else {
      return null;
    }
    return WrappedButton(
      onPressed: onPressed,
      text: text,
    );
  }
}
