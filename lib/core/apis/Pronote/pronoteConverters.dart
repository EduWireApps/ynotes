import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class PronoteConverter {
  static Lesson lesson(PronoteClient client, Map<String, dynamic> lessonData) {
    
    DateTime start = DateFormat("dd/MM/yyyy HH:mm:ss", "fr_FR").parse(mapGet(lessonData, ["DateDuCours", "V"]));
    DateTime end;
    var endPlace = (mapGet(lessonData, ['place']) %
                (client.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V']).length -
            1) +
        mapGet(lessonData, ['duree']) -
        1;

    ///Get the correct hours
    for (var endTime in mapGet(client.funcOptions, ['donneesSec', 'donnees', 'General', 'ListeHeuresFin', 'V']) ?? []) {
      if (mapGet(endTime, ['G']) == endPlace) {
        endTime = DateFormat("""'hh'h'mm'""").parse(mapGet(lessonData, ["start_date"]));
        end = DateTime(start.year, start.month, start.day, endTime.hour, endTime.minute);
      }
    }
    String room;
    try {
      var roomContainer = mapGet(lessonData, ["ListeContenus", "V"]) ?? [].firstWhere((element) => element["G"] == 17);
      room = mapGet(roomContainer, ["L"]);
    }
    //Sort of null aware
    catch (e) {}
    List<String> teachers = List();
    try {
      mapGet(lessonData, ["ListeContenus", "V"]).forEach((element) {
        if (element["G"] == 3) {
          teachers.add(element["L"]);
        }
      });
    } catch (e) {}

    //Some attributes
    String matiere = mapGet(lessonData, ["ListeContenus", "V", 0, "L"]);
    String codeMatiere = mapGet(lessonData, ["ListeContenus", "V", 0, "L"]).hashCode.toString();
    String id = mapGet(lessonData, ["N"]);
    String status;
    bool canceled = false;

    //Set lesson status
    if (mapGet(lessonData, ["Statut"]) != null) {
      status = mapGet(lessonData, ["Statut"]);
    }
    if (mapGet(lessonData, ["estAnnule"]) != null) {
      canceled = mapGet(lessonData, ["estAnnule"]);
    }
    //Finally set attributes
    Lesson l = Lesson(
        room: room,
        teachers: teachers,
        start: start,
        end: end,
        duration: end.difference(start).inMinutes,
        canceled: canceled,
        status: status,
        discipline: matiere,
        id: id,
        disciplineCode: codeMatiere);
    //return lesson
  }
}
