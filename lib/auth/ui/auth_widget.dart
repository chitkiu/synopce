import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:synopce/auth/data/mappers/local_auth_data_mapper.dart';
import 'package:synopce/auth/domain/auth_screen_controller.dart';

import '../../common/ui/text_constants.dart';
import 'models/auth_ui_model.dart';

const double _EditTextWidth = 300;

class AuthWidget extends GetView<AuthScreenController> {
  AuthWidget({Key? key}) : super(key: key);

  final RxBool hidePassword = true.obs;
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthDataMapper _authDataMapper = LocalAuthDataMapper();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var model = controller.authState.value;
      if (model == null) {
        return _waitingView();
      } else {
        return SafeArea(
            child: SingleChildScrollView(
              child: _dataView(_authDataMapper.mapToUIModel(model)),
            )
        );
      }
    });
  }

  Scaffold _waitingView() {
    return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
              Text('Loading...'),
            ],
          ),
        ));
  }

  Widget _dataView(AuthUIModel state) {
    if (_urlController.text != state.url) {
      _urlController.value = _urlController.value.copyWith(
        text: state.url,
      );
    }
    if (_nameController.text != state.username) {
      _nameController.value = _nameController.value.copyWith(
        text: state.username,
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      // shrinkWrap: true,
      children: <Widget>[
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Synopce',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            )),
        Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              'Sign in',
              style: TextStyle(fontSize: 20),
            )),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.all(10),
          child: PlatformTextField(
            controller: _urlController,
            keyboardType: TextInputType.url,
            hintText: 'Server url',
            onChanged: (newValue) {
              controller.updateURL(newValue);
            },
          ),
        ),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.all(10),
          child: PlatformTextField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            hintText: 'User Name',
            onChanged: (newValue) {
              controller.updateUsername(newValue);
            },
          ),
        ),
        Container(
            width: _EditTextWidth,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: PlatformTextField(
              controller: _passwordController,
              obscureText: hidePassword.value,
              hintText: 'Password',
              cupertino: (context, platform) {
                return CupertinoTextFieldData(
                    suffix: _suffixIcon(context, hidePassword.value));
              },
              material: (context, platform) {
                return MaterialTextFieldData(
                  decoration: InputDecoration(
                    suffix: _suffixIcon(context, hidePassword.value),
                  ),
                );
              },
            )),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Use HTTPS?', style: AppDefaultTextStyle),
              PlatformSwitch(
                onChanged: (bool? value) {
                  if (value != null) {
                    controller.updateIsHttps(value);
                  }
                },
                value: state.isHttps,
              )
            ],
          ),
        ),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Auto log in', style: AppDefaultTextStyle),
              PlatformSwitch(
                onChanged: (bool? value) {
                  if (value != null) {
                    controller.updateNeedToAutologin(value);
                  }
                },
                value: state.needToAutologin,
              )
            ],
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: PlatformElevatedButton(
              onPressed: () {
                controller.auth(_passwordController.text);
              },
              child: Text(style: AppColoredTextStyle, 'Login'),
            )
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: PlatformTextButton(
              onPressed: () {
                controller.startDemoMode();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.question_mark),
                  Text(style: AppColoredTextStyle, 'Launch in demo mode'),
                ],
              ),
            )
        ),
      ],
    );
  }

  Widget _suffixIcon(BuildContext context, bool hidePassword) {
    return PlatformIconButton(
      icon: Icon(
        // Based on passwordVisible state choose the icon
        hidePassword ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: () {
        // Update the state i.e. toogle the state of passwordVisible variable
        this.hidePassword.value = !this.hidePassword.value;
      },
    );
  }
}
