import 'dart:async';

import 'package:synoapi/synoapi.dart';

import 'note_station_service.dart';

class StubNoteStationService extends NoteStationService {
  final List<NoteStationNoteInfo> _notes = [
    NoteStationNoteInfo(
      null,
      false,
      "Some not fini...",
      NoteStationCategory.note,
      DateTime.now().millisecondsSinceEpoch,
      false,
      DateTime.now().millisecondsSinceEpoch,
      "id1",
      NoteStationOwner(
        "note_owner",
        1,
      ),
      null,
      NoteStationPermissionType.owner,
      false,
      null,
      "Stub note 1",
      "1",
    )
  ];

  @override
  Future<NoteStationNoteList> getNoteList({int? version}) {
    return Future.value(NoteStationNoteList(
      _notes,
      0,
      0,
    ));
  }

  @override
  Future<NoteStationNoteDataInfo> getSpecificNoteInfo(String noteId,
      {int? version}) {
    var data = _notes.firstWhere((element) => element.id == noteId);

    return Future.value(
        NoteStationNoteDataInfo(
          data.acl,
          data.archive,
          null,
          data.brief,
          data.category?.name,
          null,
          "Some HTML content",
          data.creationTime,
          data.encrypt,
          false,
          false,
          null,
          null,
          null,
          null,
          data.modifyTime,
          data.id,
          null,
          data.owner,
          data.parentId,
          data.perm,
          data.recycle,
          null,
          [],
          data.thumb,
          data.title,
          data.version,
        )
    );
  }
}
