import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/api_service.dart';
import '../../../common/extensions/snackbar_extension.dart';
import '../../../common/ui/colors.dart';
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
    return PlatformWidget(
      material: (context, platform) {
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
      },
      cupertino: (context, platform) {
        EdgeInsets paddings =
            const EdgeInsets.symmetric(horizontal: 20, vertical: 8);
        return SingleChildScrollView(
          child: Column(
            children: models.map((item) {
              if (item is GroupedTaskInfoModel) {
                return CupertinoListSection.insetGrouped(
                  hasLeading: false,
                  backgroundColor: AppColors.surface,
                  margin: paddings,
                  header:
                      Text(item.title, style: AppBaseTextStyle.titleBoldStyle),
                  children: item.items.map((infoItem) {
                    return CupertinoListTile.notched(
                      backgroundColor: AppColors.secondaryContainer,
                      title: Text(infoItem.title,
                          style: AppBaseTextStyle.mainStyle),
                      subtitle: Text(infoItem.text,
                          style: AppBaseTextStyle.submainStyle),
                    );
                  }).toList(),
                );
              } else if (item is ActionTaskInfoModel) {
                return Container(
                  padding: paddings,
                  width: double.infinity,
                  child: CupertinoButton.filled(
                    onPressed: () {
                      try {
                        _onButtonClicked(item);
                      } on Exception catch (e) {
                        errorSnackbar(e.toString());
                      }
                    },
                    child: Text(item.title),
                  ),
                );
              } else {
                return Container();
              }
            }).toList(),
          ),
        );
      },
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
        Text(categoryModel.title, style: AppBaseTextStyle.titleBoldStyle),
        for (var itemModel in categoryModel.items)
          Row(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${itemModel.title}:",
                  style: AppBaseTextStyle.mainBoldStyle),
              Flexible(
                  child: Text(itemModel.text,
                      style: AppBaseTextStyle.mainStyle,
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
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: FilledButton(
        onPressed: () {
          try {
            _onButtonClicked(categoryModel);
          } on Exception catch (e) {
            errorSnackbar(e.toString());
          }
        },
        child: Text(categoryModel.title),
      ),
    );
  }
}
