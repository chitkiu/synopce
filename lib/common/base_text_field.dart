import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final String? placeholder;
  final Widget? suffix;

  const BaseTextField(
      {super.key, this.keyboardType,
      this.onChanged,
      this.controller,
      this.obscureText = false,
      this.placeholder,
      this.suffix});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS || Platform.isMacOS) {
      return CupertinoTextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscureText,
        controller: controller,
        placeholder: placeholder,
        suffix: suffix,
      );
    } else {
      return TextField(
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.all(Radius.circular(4.0)),
          ),
          labelText: placeholder,
          suffixIcon: suffix,
        ),
        controller: controller,
      );
    }
  }
}
