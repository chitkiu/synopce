import 'package:flutter/widgets.dart';

import 'text_style.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  const AppBarTitle(this.title, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: AppBaseTextStyle.appBarTitleStyle);
  }
}
