import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../common/ui/text_style.dart';
import 'settings_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text('Settings', style: AppBaseTextStyle.appBarTitleStyle,),
      ),
      body: const SettingsWidget(),
    );
  }
}
