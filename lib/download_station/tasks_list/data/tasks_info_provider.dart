import 'package:dsm_sdk/core/models/result_response.dart';
import 'package:dsm_sdk/download_station/models/additional_info.dart';
import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';

import '../../../sdk.dart';

class TasksInfoProvider {
  final sdk = SDK().sdk;

  Future<ResultResponse<TasksInfoModel>> getData() {
    return sdk.api.getDownloadList(
        additionalInfo: [AdditionalInfo.DETAIL, AdditionalInfo.TRANSFER]);
  }

  Future<ResultResponse<List<TaskDeleteModel>>> removeItem(String id) {
    return sdk.api.deleteTask(ids: [id]);
  }
}
