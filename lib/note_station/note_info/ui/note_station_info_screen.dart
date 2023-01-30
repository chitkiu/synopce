import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:zoom_widget/zoom_widget.dart';

import '../../../common/data/api_service.dart';
import '../../../common/ui/colors.dart';
import '../../../common/ui/icons_constants.dart';
import '../../../common/ui/text_style.dart';
import '../../../settings/data/settings_storage.dart';

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
              future: nsService.getSpecificNoteInfo(id),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.error == null) {
                  var noteInfo = snapshot.data;

                  String content = noteInfo?.content ?? '';

                  return Zoom(
                    initScale: 1,
                    backgroundColor: AppColors.background,
                    canvasColor: AppColors.surface,
                    colorScrollBars: AppColors.onSurface,
                    child: Html(
                      data: content,
                      style: {
                        'li' : Style(
                          color: AppBaseTextStyle.mainStyle.color,
                          fontSize: _getFontSize(),
                        ),
                        "span" : Style(
                          color: AppBaseTextStyle.mainStyle.color,
                          fontSize: _getFontSize(),
                        ),
                        "div" : Style(
                          color: AppBaseTextStyle.mainStyle.color,
                          fontSize: _getFontSize(),
                        ),
                      },
                    ),
                  );
                }

                return Center(
                  child: progressIcon(context, size: 15),
                );
              }),
        ));
  }

  FontSize? _getFontSize() {
    if (SettingsStorage.instance.isUIFixForNotesEnabled.value) {
      return FontSize.medium;
    } else {
      return null;
    }
  }
}
