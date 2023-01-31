import 'package:flutter/painting.dart';

import '../../../../common/ui/platform_list_view.dart';

class TaskUIModel extends PlatformListViewItems {
  final String id;

  TaskUIModel({required this.id, required String title, TextSpan? subtitle}) : super(title: title, subtitle: subtitle);
}