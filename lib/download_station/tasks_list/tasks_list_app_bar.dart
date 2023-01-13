import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../common/icons_constants.dart';
import 'data/tasks_info_controller.dart';

class TasksListAppBar extends PlatformAppBar {

  TasksListAppBar(TasksListController controller, {super.key})
      : super(
          title: Obx(() {
            var isLoading = controller.isLoading.value;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Tasks list"),
                if (isLoading)
                  const Padding(padding: EdgeInsets.only(left: 10)),
                if (isLoading)
                  const SizedBox(
                    width: 15,
                    height: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
              ],
            );
          }),
          cupertino: (context, platform) {
            return CupertinoNavigationBarData(
                trailing: GestureDetector(
              onTap: () {
                controller.onAddClick();
              },
              child: addIcon(context),
            ));
          },
        );
}
