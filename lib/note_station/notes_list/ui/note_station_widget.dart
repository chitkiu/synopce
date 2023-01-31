import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/icons_constants.dart';
import '../../../common/ui/platform_list_view.dart';
import '../../note_info/ui/note_station_info_screen.dart';
import '../domain/note_station_list_controller.dart';

//TODO PoC
class NoteStationWidget extends GetView<NoteStationListController> {
  const NoteStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: Align(
            alignment: Alignment.center,
            child: progressIcon(context, size: 60),
          ),
        );
      }
      return SafeArea(
          child: PlatformListView(
            items: controller.notesList.toList(),
            separatorBuilder: (BuildContext context,
                int index) => const Divider(),
            onTap: (item) {
              Get.to(() => NoteStationNoteScreen(item.id, item.title));
            },
          )
      );
    });
  }
}
