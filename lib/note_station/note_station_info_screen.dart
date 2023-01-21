import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

                  return SingleChildScrollView(
                    child: Html(
                      data: """
                      <link rel="stylesheet" type="text/css" href="${SDK.instance.uri}/webman/modules/TinyMCE/style.css?v=1635321605">${noteInfo?.content ?? ''}
                      """,
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
