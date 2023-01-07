import 'package:dsm_app/auth/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../common/text_constants.dart';
import '../sdk.dart';
import 'auth_data_model.dart';

class AuthWidget extends StatelessWidget {
  AuthWidget({Key? key}) : super(key: key);

  final AuthManager _authmanager = Get.put(AuthManager(SDK.instance.storage));

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final double _EditTextWidth = 300;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return _dataView(_authmanager.authState.value);
    });
/*    return FutureBuilder(
        future: _loadData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _waitingView();
          } else {
            if (snapshot.hasError) {
              return _errorView(snapshot);
            } else {

            }
          }
        });*/
  }

  Scaffold _errorView(AsyncSnapshot<Object?> snapshot) {
    return Scaffold(
        body: Center(child: Text('Error: ${snapshot.error}')));
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

  Widget _dataView(AuthDataModel state) {
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
    if (_passwordController.text != state.password) {
      _passwordController.value = _passwordController.value.copyWith(
        text: state.password,
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
              'DSM app',
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
              _authmanager.updateURL(newValue);
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
              _authmanager.updateUsername(newValue);
            },
          ),
        ),
        Container(
            width: _EditTextWidth,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: PlatformTextField(
              controller: _passwordController,
              obscureText: _authmanager.hidePassword.value,
              hintText: 'Password',
              cupertino: (context, platform) {
                return CupertinoTextFieldData(
                    suffix: _suffixIcon(context, _authmanager.hidePassword.value));
              },
              material: (context, platform) {
                return MaterialTextFieldData(
                  decoration: InputDecoration(
                    suffix: _suffixIcon(context, _authmanager.hidePassword.value),
                  ),
                );
              },
              onChanged: (newValue) {
                _authmanager.updatePassword(newValue);
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
                    _authmanager.updateIsHttps(value);
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
                    _authmanager.updateNeedToAutologin(value);
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
                _authmanager.auth();
              },
              child: Text(style: AppColoredTextStyle, 'Login'),
            )),
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
        _authmanager.hidePassword.value = !_authmanager.hidePassword.value;
      },
    );
  }
}
