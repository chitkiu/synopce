import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/ui/icons_constants.dart';
import '../../../common/ui/text_style.dart';
import '../domain/note_station_list_controller.dart';
import 'note_station_widget.dart';

class NoteStationPage extends GetView<NoteStationListController> {
  const NoteStationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Notes', style: AppBaseTextStyle.appBarTitleStyle,),
        trailingActions: [
          PlatformIconButton(
            icon: refreshIcon(context),
            onPressed: () async {
              await controller.refreshItems();
            },
          )
        ],
      ),
      body: const NoteStationWidget(),
    );
  }
}
