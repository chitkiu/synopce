import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/data/api_service.dart';
import '../../common/ui/colors.dart';
import '../../common/ui/icons_constants.dart';
import '../../common/ui/text_constants.dart';
import '../domain/note_station_list_controller.dart';
import 'note_station_info_screen.dart';

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
    return FutureBuilder(
        future: nsService.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.error == null) {
            var notes = snapshot.data?.notes ?? List.empty();

          }

          return Center(
            child: loadingIcon(context),
          );
        });
  }
}
