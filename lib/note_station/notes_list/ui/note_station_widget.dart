import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/icons_constants.dart';
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
      return ListView.separated(
        itemBuilder: (context, index) {
          var note = controller.notesList[index];
          return GestureDetector(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  note.title,
                  style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const Padding(padding: EdgeInsets.only(top: 4)),
                Text(note.brief, style: Get.textTheme.bodySmall),
              ],
            ),
            onTap: () {
              Get.to(() =>
                  NoteStationNoteScreen(note.id, note.title));
            },
          );
        },
        itemCount: controller.notesList.length,
        separatorBuilder: (BuildContext context, int index) =>
            const Divider(),
      );
    });
  }
}
