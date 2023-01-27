import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/icons_constants.dart';
import '../domain/tasks_info_controller.dart';

class TasksListAppBar extends PlatformAppBar {
  TasksListAppBar(TasksListController controller, {super.key})
      : super(
          material: (context, platform) {
            return MaterialAppBarData(
              title: Row(
                children: [
                  const Text("Tasks list"),
                  Obx(() {
                    var isLoading = controller.isLoading.value;
                    if (isLoading) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: progressIcon(context, size: 15, color: Colors.white),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  })
                ],
              ),
              actions: [
                Obx(() {
                  var hasError = controller.errorText.value != null;
                  if (hasError) {
                    return IconButton(
                        onPressed: () {
                          controller.reload();
                        },
                        icon: const Icon(Icons.refresh),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                })
              ]
            );
          },
          cupertino: (context, platform) {
            return CupertinoNavigationBarData(
              title: const Text("Tasks list"),
              automaticallyImplyMiddle: true,
              trailing: CupertinoButton(
                onPressed: () {
                  controller.onAddClick();
                },
                child: addIcon(context),
              ),
              leading: Obx(() {
                var isLoading = controller.isLoading.value;
                if (isLoading) {
                  return progressIcon(context, size: 12);
                } else {
                  //TODO Maybe move it to trailing
                  var hasError = controller.errorText.value != null;
                  if (hasError) {
                    return CupertinoButton(
                      child: const Icon(
                        CupertinoIcons.refresh,
                      ),
                      onPressed: () {
                        controller.reload();
                      },
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }
              })
            );
          },
        );
}
