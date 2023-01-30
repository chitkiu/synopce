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

Widget questionIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      isMaterial(context) ? Icons.question_mark : CupertinoIcons.question,
      color: color
  );
}

Widget visibilityIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      isMaterial(context) ? Icons.visibility : CupertinoIcons.eye_fill,
      color: color
  );
}

Widget visibilityOffIcon(BuildContext context, {Color? color}) {
  return _baseIcon(
      context,
      isMaterial(context) ? Icons.visibility_off : CupertinoIcons.eye_slash_fill,
      color: color
  );
}

IconData expandMoreIcon(BuildContext context) {
  return isMaterial(context) ? Icons.expand_more : CupertinoIcons.chevron_down;
}

IconData expandLessIcon(BuildContext context) {
  return isMaterial(context) ? Icons.expand_less : CupertinoIcons.chevron_up;
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
      color: color ?? CupertinoTheme.of(context).textTheme.textStyle.color,
    );
  }
}
