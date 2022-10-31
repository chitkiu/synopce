import 'package:dsm_sdk/core/models/result_response.dart';
import 'package:dsm_sdk/download_station/tasks/common/models/ds_task_method_result_model.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_additional_info.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:dsm_sdk/dsm_sdk.dart';

class TasksInfoProvider {
  final DsmSdk sdk;

  TasksInfoProvider(this.sdk);

  Future<ResultResponse<TasksInfoModel>> getData() {
    return sdk.dsSDK.getDownloadList(
        additionalInfo: [AdditionalInfo.DETAIL, AdditionalInfo.TRANSFER]);
  }

  Future<ResultResponse<List<DSTaskMethodResultModel>>> removeItem(String id) {
    return sdk.dsSDK.deleteTask(ids: [id]);
  }
}
