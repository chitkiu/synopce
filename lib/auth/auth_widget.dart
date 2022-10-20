import 'package:dsm_app/sdk.dart';
import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:flutter/material.dart';

import '../download_station/tasks_list/tasks_list.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHttps = false;
  bool _needToAutologin = false;
  bool _hidePassword = true;

  final double _EditTextWidth = 300;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _urlController.text = await SDK().storage.read(key: "url") ?? "";
    _nameController.text = await SDK().storage.read(key: "name") ?? "";
    _passwordController.text = await SDK().storage.read(key: "password") ?? "";
    _isHttps = await SDK().storage.read(key: "isHttps") == 'true';
    _needToAutologin =
        await SDK().storage.read(key: "needToAutologin") == 'true';

    if (_needToAutologin) {
      _logIn();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: TextField(
            keyboardType: TextInputType.url,
            controller: _urlController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Server url',
            ),
          ),
        ),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.all(10),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'User Name',
            ),
          ),
        ),
        Container(
            width: _EditTextWidth,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: TextField(
              obscureText: _hidePassword,
              controller: _passwordController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _hidePassword ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).primaryColorDark,
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _hidePassword = !_hidePassword;
                    });
                  },
                ),
              ),
            )),
        Container(
          width: _EditTextWidth,
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Use HTTPS?'),
              Switch(
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _isHttps = value;
                    });
                  }
                },
                value: _isHttps,
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
              const Text('Auto log in'),
              Switch(
                onChanged: (bool? value) {
                  if (value != null) {
                    setState(() {
                      _needToAutologin = value;
                    });
                  }
                },
                value: _needToAutologin,
              )
            ],
          ),
        ),
        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              onPressed: _logIn,
              child: const Text('Login'),
            )),
      ],
    );
  }

  void _logIn() async {
    showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        content: SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator(
            //TODO
            color: Colors.black,
          ),
        ),
      ),
    );
    var url = _urlController.text;
    var name = _nameController.text;
    var password = _passwordController.text;
    if (url.isEmpty) {
      return;
    }
    if (name.isEmpty) {
      return;
    }
    if (password.isEmpty) {
      return;
    }
    print(url);
    print(name);
    print(password);
    print(_isHttps);
    print(_needToAutologin);
    SDK().storage.write(key: 'url', value: url);
    SDK().storage.write(key: 'name', value: name);
    SDK().storage.write(key: 'password', value: password);
    SDK().storage.write(key: 'isHttps', value: _isHttps.toString());
    SDK()
        .storage
        .write(key: 'needToAutologin', value: _needToAutologin.toString());
    var server = Uri.parse("${(_isHttps ? 'https' : 'http')}://$url");
    SDK().init(ConnectionInfo(server, name, password));
    var authResult = await SDK().sdk.api.auth();
    authResult.ifSuccess((_) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const TasksScreenWidget()),
          (route) => false);
    });
  }
}
