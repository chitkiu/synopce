import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'note_station_widget.dart';

class NoteStationPage extends StatelessWidget {
  const NoteStationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Notes'),
      ),
      body: const NoteStationWidget(),
    );
  }
}
