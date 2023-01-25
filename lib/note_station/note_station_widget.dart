import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../common/colors.dart';
import '../common/icons_constants.dart';
import '../common/text_constants.dart';
import '../sdk.dart';
import 'note_station_info_screen.dart';

class NoteStationWidget extends StatelessWidget {
  const NoteStationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: SDK.instance.nsSDK.note.getNoteList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var notes = snapshot.data?.data?.notes ?? List.empty();
            return ListView.separated(
              itemBuilder: (context, index) {
                var note = notes[index];
                return GestureDetector(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        note.title ?? "",
                        style: AppDefaultTextStyle.copyWith(
                            fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Padding(padding: EdgeInsets.only(top: 4)),
                      Text(note.brief ?? "", style: AppGreySmallTextStyle),
                    ],
                  ),
                  onTap: () {
                    Get.to(() =>
                        NoteStationNoteScreen(note.id ?? '', note.title ?? ''));
                  },
                );
              },
              itemCount: notes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  Divider(color: getDividerColor()),
            );
          }

          return Center(
            child: loadingIcon(context),
          );
        });
  }
}
