import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../app_route_type.dart';
import '../../auth/data/auth_service/auth_service.dart';
import '../../main.dart';
import '../data/settings_storage.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
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
        PlatformTextButton(
          alignment: Alignment.center,
          onPressed: () async {
            //TODO Rewrite using controller
            var result = await Get.find<AuthService>().logOut();
            if (result) {
              await Get.delete<AuthService>(force: true);
              initAuthService();
              Get.offAllNamed(AppRouteType.auth.route);
            }
          },
          child: const Text("Log out"),
        )
      ],
    );
  }
}
