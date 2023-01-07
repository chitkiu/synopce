import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../auth/auth_screen_widget.dart';
import '../sdk.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Settings"),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: 1,
          itemBuilder: (context, index) {
          return Column(
            children: [
              GestureDetector(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: PlatformText("Log out"),
                  ),
                ),
                onTap: () async {
                  var result = await SDK.instance.logout();
                  if (result) {
                    Get.offAll(() => const AuthScreenWidget());
                  }
                },
              )
            ],
          );
      })
    );
  }
}
