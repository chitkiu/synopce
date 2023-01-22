import 'package:dsm_app/settings/settings_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../common/colors.dart';
import '../common/icons_constants.dart';
import '../sdk.dart';

class NoteStationNoteScreen extends StatelessWidget {
  final String id;
  final String name;

  const NoteStationNoteScreen(this.id, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(name),
        ),
        body: SafeArea(
          child: FutureBuilder(
              future: SDK.instance.nsSDK.note.getSpecificNoteInfo(id),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data?.success == true) {
                  var noteInfo = snapshot.data?.data;

                  String content = noteInfo?.content ?? '';

                  if (SettingsStorage.instance.isUIFixForNotesEnabled.value) {
                    content = content.replaceAll(
                        RegExp(r'(style="font-size: \d;")'), '');
                    content =
                        content.replaceAll(RegExp(r'(font-size: \dpx;)'), '');
                  }

                  return Zoom(
                    initScale: 1,
                    backgroundColor: getBaseColor(),
                    canvasColor: getBaseColor(),
                    child: Html(
                      data: content,
                    ),
                  );
                }

                return Center(
                  child: loadingIcon(context),
                );
              }),
        ));
  }
}
