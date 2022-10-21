import 'package:dsm_sdk/core/models/error_type.dart';
import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';

abstract class Data {
  const Data._();

  bool get isSuccess => this is Success;
}

class Success extends Data {
  final Iterable<TaskInfoDetailModel> models;
  final String? selectedTaskId;

  Success(this.models, {this.selectedTaskId}) : super._();
}

class Error extends Data {
  final ErrorType errorType;

  Error(this.errorType) : super._();
}

class Loading extends Data {
  Loading() : super._();
}
