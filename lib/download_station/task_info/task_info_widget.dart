import 'package:dsm_app/download_station/task_info/task_info_mapper.dart';
import 'package:dsm_app/sdk.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../common/text_constants.dart';
import 'task_info_model.dart';

class TaskInfoWidget extends StatelessWidget {
  final TaskInfoDetailModel _model;
  final TaskInfoMapper _mapper = TaskInfoMapper();

  TaskInfoWidget(this._model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var models = _mapper.map(_model);
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        var categoryModel = models[index];
        if (categoryModel is GroupedTaskInfoModel) {
          return _groupedTaskInfo(categoryModel);
        } else if (categoryModel is ActionTaskInfoModel) {
          return _actionTaskInfoModel(categoryModel);
        } else {
          return Container();
        }
      },
      itemCount: models.length,
    );
  }

  void _onButtonClicked(ActionTaskInfoModel model) async {
    switch (model.type) {
      case ActionTaskInfoType.RESUME:
        await SDK.instance.sdk.dsSDK.resumeTask(ids: [model.id]);
        break;
      case ActionTaskInfoType.PAUSE:
        await SDK.instance.sdk.dsSDK.pauseTask(ids: [model.id]);
        break;
      case ActionTaskInfoType.DELETE:
        await SDK.instance.sdk.dsSDK.deleteTask(ids: [model.id]);
        break;
    }
  }

  Widget _groupedTaskInfo(GroupedTaskInfoModel categoryModel) {
    return Column(
      children: [
        Text(categoryModel.title),
        for(var itemModel in categoryModel.items)
          Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${itemModel.title}:"),
              Flexible(
                  child: Text(itemModel.text,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
        const Divider(),
      ],
    );
  }

  Widget _actionTaskInfoModel(ActionTaskInfoModel categoryModel) {
    return Column(
      children: [
        const SizedBox(height: 30),
        PlatformElevatedButton(
          onPressed: () {
            _onButtonClicked(categoryModel);
          },
          child: Text(style: AppColoredTextStyle, categoryModel.title),
        ),
      ],
    );
  }
}
