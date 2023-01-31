import '../../../../common/ui/platform_list_view.dart';

class NotesItemUIModel extends PlatformListViewItems {
  final String id;

  NotesItemUIModel({required this.id, required String title, String? brief}) : super.withString(title, brief);
}