import 'package:dsm_app/extensions/format_byte.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

import 'task_info_model.dart';

class TaskInfoMapper {
  List<TaskInfoModel> map(TaskInfoDetailModel model) {
    var resultList = <TaskInfoModel>[];

    resultList
        .add(GroupedTaskInfoModel(title: "Main", items: _getMainItems(model)));

    resultList.add(GroupedTaskInfoModel(
        title: "Transfer",
        items: _getTransferItems(model.additional?.transfer)));

    resultList.add(GroupedTaskInfoModel(
        title: "Detailed", items: _getDetailedItems(model.additional?.detail)));

    if (model.status == TaskInfoDetailStatus.DOWNLOADING) {
      resultList.add(ActionTaskInfoModel(
        title: "Pause",
        type: ActionTaskInfoType.PAUSE,
        id: model.id,
      ));
    } else {
      resultList.add(ActionTaskInfoModel(
        title: "Resume",
        type: ActionTaskInfoType.RESUME,
        id: model.id,
      ));
    }

    resultList.add(ActionTaskInfoModel(
      title: "Delete",
      type: ActionTaskInfoType.DELETE,
      id: model.id,
    ));

    return resultList;
  }

  List<TaskInfoDataModel> _getMainItems(TaskInfoDetailModel model) {
    var resultList = <TaskInfoDataModel>[];

    resultList.add(TaskInfoDataModel(
      title: "Title",
      text: model.title,
    ));
    resultList.add(TaskInfoDataModel(
      title: "Status",
      text: model.status.name,
    ));
    resultList.add(TaskInfoDataModel(
      title: "Type",
      text: model.type.name,
    ));
    resultList.add(TaskInfoDataModel(
      title: "Total size",
      text: formatBytes(model.size, 1),
    ));

    return resultList;
  }

  List<TaskInfoDataModel> _getTransferItems(
      TaskInfoAdditionalTransferModel? transfer) {
    var resultList = <TaskInfoDataModel>[];

    if (transfer != null) {
      resultList.add(TaskInfoDataModel(
        title: "Downloaded size",
        text: formatBytes(transfer.sizeDownloaded, 1),
      ));
      resultList.add(TaskInfoDataModel(
        title: "Download speed",
        text: "${formatBytes(transfer.speedDownload, 1)}/s",
      ));
      resultList.add(TaskInfoDataModel(
        title: "Upload speed",
        text: "${formatBytes(transfer.speedUpload, 1)}/s",
      ));
    }

    return resultList;
  }

  List<TaskInfoDataModel> _getDetailedItems(
      TaskInfoAdditionalDetailModel? detail) {
    var resultList = <TaskInfoDataModel>[];

    if (detail != null) {
      resultList.add(TaskInfoDataModel(
        title: "Destination",
        text: detail.destination,
      ));
      var createDate =
          DateTime.fromMillisecondsSinceEpoch(detail.createTime * 1000);
      resultList.add(TaskInfoDataModel(
        title: "Created time",
        text: createDate.toString(), //TODO
      ));
    }

    return resultList;
  }
}
