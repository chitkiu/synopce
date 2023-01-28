import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget progressIcon(BuildContext context, {double? size, Color? color}) {
  if (isMaterial(context)) {
    if (size != null) {
      return SizedBox(
        height: size,
        width: size,
        child: CircularProgressIndicator(
          color: color,
        ),
      );
    }
    return CircularProgressIndicator(
      color: color,
    );
  } else {
    return CupertinoActivityIndicator(
      radius: size ?? 10.0,
      color: color,
    );
  }
}

Widget doneIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      context.platformIcons.checkMark,
      color: color
  );
}

Widget addIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      context.platformIcons.add,
      color: color
  );
}

Widget refreshIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      context.platformIcons.refresh,
      color: color
  );
}

Widget _baseIcon(BuildContext context, IconData icon, {Color? color}) {
  if (isMaterial(context)) {
    return Icon(
      icon,
      color: color ?? Theme.of(context).primaryColor,
    );
  } else {
    return Icon(
      icon,
      color: color ?? CupertinoTheme.of(context).primaryColor,
    );
  }
}

Widget loadingIcon(BuildContext context, {Color? color, double size = 15}) {
  if (isMaterial(context)) {
    return SizedBox(
      height: size,
      width: size,
      child: CircularProgressIndicator(
        color: color,
      ),
    );
  } else {
    return CupertinoActivityIndicator(
      radius: size,
      color: color,
    );
  }
}
