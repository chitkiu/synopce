import 'package:dsm_app/download_station/tasks_list.dart';
import 'package:dsm_app/sdk.dart';
import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:flutter/material.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AuthState();
}

class _AuthState extends State<AuthWidget> {
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHttps = false;
  bool _needToAutologin = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    _hostController.text = await SDK().storage.read(key: "host") ?? "";
    _portController.text = await SDK().storage.read(key: "port") ?? "";
    _nameController.text = await SDK().storage.read(key: "name") ?? "";
    _passwordController.text = await SDK().storage.read(key: "password") ?? "";
    _isHttps = await SDK().storage.read(key: "isHttps") == 'true';
    _needToAutologin = await SDK().storage.read(key: "needToAutologin") == 'true';

    if (_needToAutologin) {
      _logIn();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Scaffold(
          body: ListView(
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
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _hostController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Server host',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _portController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Server port',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const Text('Use HTTPS?'),
                    Checkbox(
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
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Row(
                  children: [
                    const Text('Auto log in'),
                    Checkbox(
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
          ),
        ));
  }

  void _logIn() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => const AlertDialog(
        content: SizedBox(
          width: 10,
          height: 10,
          child: CircularProgressIndicator( //TODO
            color: Colors.black,
          ),
        ),
      ),
    );
    var host = _hostController.text;
    var port = _portController.text;
    var name = _nameController.text;
    var password = _passwordController.text;
    if (host.isEmpty) {
      return;
    }
    if (port.isEmpty) {
      return;
    } else {
      try {
        int.parse(port);
      } on Exception {
        return;
      }
    }
    if (name.isEmpty) {
      return;
    }
    if (password.isEmpty) {
      return;
    }
    print(host);
    print(port);
    print(name);
    print(password);
    print(_isHttps);
    print(_needToAutologin);
    SDK().storage.write(key: 'host', value: host);
    SDK().storage.write(key: 'port', value: port);
    SDK().storage.write(key: 'name', value: name);
    SDK().storage.write(key: 'password', value: password);
    SDK()
        .storage
        .write(key: 'isHttps', value: _isHttps.toString());
    SDK()
        .storage
        .write(key: 'needToAutologin', value: _needToAutologin.toString());
    var server = Uri(
        host: host,
        port: int.parse(port),
        scheme: (_isHttps ? 'https' : 'http'));
    SDK().init(ConnectionInfo(server, name, password));
    var authResult = await SDK().sdk.api.auth();
    authResult.ifSuccess((_) {
      Navigator.pushAndRemoveUntil<void>(
        context,
        MaterialPageRoute<void>(
            builder: (BuildContext context) =>
            const TasksListWidget()),
        ModalRoute.withName('/'),
      );
    });
  }
}
