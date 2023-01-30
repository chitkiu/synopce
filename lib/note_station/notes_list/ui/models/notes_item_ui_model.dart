import '../../../../common/ui/platform_list_view.dart';

class NotesItemUIModel extends PlatformListViewItems {
  final String id;
  final String title;
  final String brief;

  NotesItemUIModel(this.id, this.title, this.brief) : super(title, brief);
}