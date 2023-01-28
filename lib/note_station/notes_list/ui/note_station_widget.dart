import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/ui/colors.dart';
import '../../../common/ui/text_constants.dart';
import '../../note_info/ui/note_station_info_screen.dart';
import '../domain/note_station_list_controller.dart';

//TODO PoC
class NoteStationWidget extends GetView<NoteStationListController> {
  const NoteStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
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
                  style: AppDefaultTextStyle.copyWith(
                      fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
                const Padding(padding: EdgeInsets.only(top: 4)),
                Text(note.brief, style: AppGreySmallTextStyle),
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
            Divider(color: getDividerColor()),
      );
    });
  }
}
