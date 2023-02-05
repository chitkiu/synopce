import 'dart:async';

import 'package:synoapi/synoapi.dart';

import 'note_station_service.dart';

class StubNoteStationService extends NoteStationService {
  final List<NoteStationNoteInfo> _notes = [
    NoteStationNoteInfo(
      id: "1",
      title: "Stub note 1",
      owner: NoteStationOwner(
        displayName: "note_owner",
        uid: 1,
      ),
      version: "id1",
      thumb: null,
      recycle: false,
      brief: "Some not fini...",
      category: NoteStationCategory.note,
      creationTime: DateTime.now().millisecondsSinceEpoch,
      encrypt: false,
      modifyTime: DateTime.now().millisecondsSinceEpoch,
      parentId: null,
      perm: NoteStationPermissionType.owner,
      archive: false,
      acl: null,
    )
  ];

  @override
  Future<NoteStationNoteList> getNoteList({int? version}) {
    return Future.value(NoteStationNoteList(
      notes: _notes,
      total: 0,
      offset: 0,
    ));
  }

  @override
  Future<NoteStationNoteDataInfo> getSpecificNoteInfo(String noteId,
      {int? version}) {
    var data = _notes.firstWhere((element) => element.id == noteId);

    return Future.value(
        NoteStationNoteDataInfo(
          id: data.id,
          title: data.title,
          version: data.version,
          acl: data.acl,
          archive: data.archive,
          attachment: null,
          brief: data.brief,
          category: data.category?.name,
          commitMessage: null,
          content: "Some HTML content",
          creationTime: data.creationTime,
          encrypt: data.encrypt,
          individualJoined: false,
          individualShared: false,
          latitude: null,
          linkId: null,
          location: null,
          longitude: null,
          modifyTime: data.modifyTime,
          oldParentId: null,
          owner: data.owner,
          parentId: data.parentId,
          perm: data.perm,
          recycle: data.recycle,
          sourceUrl: null,
          tag: [],
          thumb: data.thumb,
        )
    );
  }
}
