import 'package:synoapi/synoapi.dart';

abstract class NoteStationService {
  Future<NoteStationNoteDataInfo> getSpecificNoteInfo(String noteId, {int? version});

  Future<NoteStationNoteList> getNoteList({int? version});
}