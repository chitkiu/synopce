import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/api_service.dart';
import '../../../common/extensions/snackbar_extension.dart';
import '../../../common/ui/text_style.dart';
import 'mappers/task_info_ui_mapper.dart';
import 'models/task_info_ui_model.dart';

class TaskInfoWidget extends StatelessWidget {
  final Task _model;
  final TaskInfoUIMapper _mapper = TaskInfoUIMapper();

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
        await dsService.resume([model.id]);
        break;
      case ActionTaskInfoType.PAUSE:
        await dsService.pause([model.id]);
        break;
      case ActionTaskInfoType.DELETE:
        await dsService.delete([model.id], false);
        break;
    }
  }

  Widget _groupedTaskInfo(GroupedTaskInfoModel categoryModel) {
    return Column(
      children: [
        PlatformText(categoryModel.title),
        for(var itemModel in categoryModel.items)
          Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              PlatformText("${itemModel.title}:"),
              Flexible(
                  child: PlatformText(itemModel.text,
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
            try {
              _onButtonClicked(categoryModel);
            } on Exception catch (e) {
              errorSnackbar(e.toString());
            }
          },
          child: Text(style: AppBaseTextStyle.mainStyle, categoryModel.title),
        ),
      ],
    );
  }
}
