import 'dart:developer';

import 'package:dsm_app/auth/bloc/auth_state.dart';
import 'package:dsm_app/sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../common/base_loading_dialog.dart';
import '../common/text_constants.dart';
import '../download_station/tasks_list/tasks_screen_widget.dart';
import 'bloc/auth_cubit.dart';

class AuthWidget extends StatelessWidget {
  AuthWidget({Key? key}) : super(key: key);

  final TextEditingController _urlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoadingDialogVisible = false;

  final double _EditTextWidth = 300;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(SDK.instance.storage)..loadSavedData(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is DataAuthState) {
            if (state.error != null) {
              log(state.error ?? "");
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Error: ${state.error}'),
              ));
              if (_isLoadingDialogVisible) {
                Navigator.of(context).pop();
              }
            }
            if (state.state == InternalAuthState.LOADING) {
              if (!_isLoadingDialogVisible) {
                _isLoadingDialogVisible = true;
                showLoadingDialog(context)
                    .then((value) => _isLoadingDialogVisible = false);
              }
            } else if (state.state == InternalAuthState.SUCCESS) {
              Navigator.of(context).pushAndRemoveUntil(
                  platformPageRoute(context: context, builder: (_) => const TasksScreenWidget()),
                  (route) => false);
            }
          }
        },
        builder: (context, state) {
          if (state is! DataAuthState) {
            return Container();
          } else {
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
                      BlocProvider.of<AuthCubit>(context).changeURL(newValue);
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
                      BlocProvider.of<AuthCubit>(context)
                          .changeUsername(newValue);
                    },
                  ),
                ),
                Container(
                    width: _EditTextWidth,
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: PlatformTextField(
                      controller: _passwordController,
                      obscureText: state.hidePassword,
                      hintText: 'Password',
                      cupertino: (context, platform) {
                        return CupertinoTextFieldData(
                          suffix: _suffixIcon(context, state)
                        );
                      },
                      material: (context, platform) {
                        return MaterialTextFieldData(
                          decoration: InputDecoration(
                            suffix: _suffixIcon(context, state),
                          ),
                        );
                      },
                      onChanged: (newValue) {
                        BlocProvider.of<AuthCubit>(context)
                            .changePassword(newValue);
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
                            BlocProvider.of<AuthCubit>(context).isHttps(value);
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
                            BlocProvider.of<AuthCubit>(context)
                                .isAutologin(value);
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
                        BlocProvider.of<AuthCubit>(context).auth();
                      },
                      child: Text(style: AppColoredTextStyle, 'Login'),
                    )),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _suffixIcon(BuildContext context, DataAuthState state) {
    return PlatformIconButton(
      icon: Icon(
        // Based on passwordVisible state choose the icon
        state.hidePassword
            ? Icons.visibility
            : Icons.visibility_off,
      ),
      onPressed: () {
        // Update the state i.e. toogle the state of passwordVisible variable
        BlocProvider.of<AuthCubit>(context)
            .hidePassword(!state.hidePassword);
      },
    );
  }
}
