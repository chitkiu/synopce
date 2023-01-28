import 'package:synoapi/synoapi.dart';

import '../../ui/models/notes_item_ui_model.dart';

class NotesUiModelMapper {
  List<NotesItemUIModel> mapToUIModel(NoteStationNoteList notes) {
    return notes.notes
            ?.map((item) => NotesItemUIModel(
                  item.id ?? '',
                  item.title ?? '',
                  item.brief ?? '',
                ))
            .toList() ??
        List.of([]);
  }
}
