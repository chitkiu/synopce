import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../auth/ui/auth_screen.dart';
import '../../common/sdk.dart';
import '../data/settings_storage.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Text("Is UI fix for notes enabled?"),
                  Obx(() => PlatformSwitch(
                    value: SettingsStorage
                        .instance.isUIFixForNotesEnabled.value,
                    onChanged: (p0) {
                      SettingsStorage
                          .instance.isUIFixForNotesEnabled.value = p0;
                    },
                  ))
                ],
              ),

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
                    Get.offAll(() => const AuthScreen());
                  }
                },
              ),
            ],
          );
        });
  }
}
