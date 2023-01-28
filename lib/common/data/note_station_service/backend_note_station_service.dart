import 'package:synoapi/synoapi.dart';

import '../api_response_wrapper.dart';
import 'note_station_service.dart';

class BackendNoteStationService extends NoteStationService {

  final NoteStationAPI _api;

  BackendNoteStationService(APIContext apiContext) : _api = NoteStationAPI(apiContext);

  @override
  Future<NoteStationNoteList> getNoteList({int? version}) {
    return wrapRequest(_api.note.getNoteList(version: version));
  }

  @override
  Future<NoteStationNoteDataInfo> getSpecificNoteInfo(String noteId, {int? version}) {
    return wrapRequest(_api.note.getSpecificNoteInfo(noteId, version: version));
  }

}