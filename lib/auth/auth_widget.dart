import 'dart:developer';

import 'package:dsm_app/auth/bloc/auth_bloc.dart';
import 'package:dsm_app/sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../download_station/tasks_list/tasks_screen_widget.dart';

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
  bool _isAlertDialogVisible = false;

  final double _EditTextWidth = 300;

  @override
  Widget build(BuildContext context) {
    var bloc = AuthBloc(SDK().storage);
    return BlocProvider<AuthBloc>(
      create: (context) => bloc,
      child: BlocListener<AuthBloc, AuthState>(
        bloc: bloc,
        listener: (context, state) {
          switch (state.runtimeType) {
            case InitialAuthState:
              break;
            case UpdateDataAuthState:
              var authData = state as UpdateDataAuthState;
              _urlController.text = authData.url;
              _nameController.text = authData.username;
              _passwordController.text = authData.password;
              _isHttps = authData.isHttps;
              _needToAutologin = authData.needToAutologin;

              if (_needToAutologin) {
                _logIn(bloc);
              }
              break;
            case LoadingAuthState:
              _isAlertDialogVisible = true;
              showDialog<String>(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) => const AlertDialog(
                  content: SingleChildScrollView(
                    child: SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ).then((value) => _isAlertDialogVisible = false);
              break;
            case ErrorAuthState:
              var errorState = state as ErrorAuthState;
              log(errorState.error);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error: ${errorState.error}'),
              ));
              if (_isAlertDialogVisible) {
                Navigator.of(context).pop();
              }
              break;
            case SuccessLogInAuthState:
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const TasksScreenWidget()),
                  (route) => false);
              break;
          }
        },
        child: Column(
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
                  onPressed: () {
                    _logIn(bloc);
                  },
                  child: const Text('Login'),
                )),
          ],
        ),
      ),
    );
  }

  void _logIn(AuthBloc bloc) async {
    bloc.add(LogInPressedAuthEvent(
        url: _urlController.text,
        username: _nameController.text,
        password: _passwordController.text,
        isHttps: _isHttps,
        needToAutologin: _needToAutologin));
  }
}
