import 'package:synoapi/synoapi.dart';

class TasksInfoProvider {
  final DownloadStationAPI sdk;

  TasksInfoProvider(this.sdk);

  Future<APIResponse<ListTaskInfo>> getData() {
    return sdk.task.list();
  }

  Future<APIResponse<DownloadStationTaskDelete>> removeItem(String id) {
    return sdk.task.delete([id], false);
  }
}
