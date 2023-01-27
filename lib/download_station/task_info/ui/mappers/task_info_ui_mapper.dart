import 'package:synoapi/synoapi.dart';

import '../../../../common/extensions/format_byte.dart';
import '../models/task_info_ui_model.dart';

class TaskInfoUIMapper {
  List<TaskInfoUIModel> map(Task model) {
    var resultList = <TaskInfoUIModel>[];

    resultList
        .add(GroupedTaskInfoModel(title: "Main", items: _getMainItems(model)));

    resultList.add(GroupedTaskInfoModel(
        title: "Transfer",
        items: _getTransferItems(model.additional?.transfer)));

    resultList.add(GroupedTaskInfoModel(
        title: "Detailed", items: _getDetailedItems(model.additional?.detail)));

    if (model.status == TaskStatus.downloading || model.status == TaskStatus.waiting) {
      resultList.add(ActionTaskInfoModel(
        title: "Pause",
        type: ActionTaskInfoType.PAUSE,
        id: model.id ?? "",
      ));
    } else if (model.status == TaskStatus.paused) {
      resultList.add(ActionTaskInfoModel(
        title: "Resume",
        type: ActionTaskInfoType.RESUME,
        id: model.id ?? "",
      ));
    }

    resultList.add(ActionTaskInfoModel(
      title: "Delete",
      type: ActionTaskInfoType.DELETE,
      id: model.id ?? "",
    ));

    return resultList;
  }

  List<TaskInfoDataModel> _getMainItems(Task model) {
    var resultList = <TaskInfoDataModel>[];

    resultList.add(TaskInfoDataModel(
      title: "Title",
      text: model.title ?? "",
    ));
    resultList.add(TaskInfoDataModel(
      title: "Status",
      text: model.status.toString(),
    ));
    resultList.add(TaskInfoDataModel(
      title: "Type",
      text: model.type ?? "",
    ));
    resultList.add(TaskInfoDataModel(
      title: "Total size",
      text: formatBytes(model.size ?? 0, 1),
    ));

    return resultList;
  }

  List<TaskInfoDataModel> _getTransferItems(
      TaskTransfer? transfer) {
    var resultList = <TaskInfoDataModel>[];

    if (transfer != null) {
      resultList.add(TaskInfoDataModel(
        title: "Downloaded size",
        text: formatBytes(transfer.sizeDownloaded ?? 0, 1),
      ));
      resultList.add(TaskInfoDataModel(
        title: "Download speed",
        text: "${formatBytes(transfer.speedDownload ?? 0, 1)}/s",
      ));
      resultList.add(TaskInfoDataModel(
        title: "Upload speed",
        text: "${formatBytes(transfer.speedUpload ?? 0, 1)}/s",
      ));
    }

    return resultList;
  }

  List<TaskInfoDataModel> _getDetailedItems(
      TaskDetail? detail) {
    var resultList = <TaskInfoDataModel>[];

    if (detail != null) {
      resultList.add(TaskInfoDataModel(
        title: "Destination",
        text: detail.destination ?? "",
      ));
      resultList.add(TaskInfoDataModel(
        title: "Created time",
        text: detail.createTime.toString(), //TODO
      ));
    }

    return resultList;
  }
}
