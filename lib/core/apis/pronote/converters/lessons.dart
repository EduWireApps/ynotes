import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';

class PronoteLessonsConverter {
  static Lesson lesson(PronoteClient client, Map lessonData) {
    String? matiere = mapGet(lessonData, ["ListeContenus", "V", 0, "L"]);
    DateTime start = DateFormat("dd/MM/yyyy HH:mm:ss", "fr_FR").parse(mapGet(lessonData, ["DateDuCours", "V"]));
    DateTime? end;

    int? endPlace = (mapGet(lessonData, ['place']) %
            ((client.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V']).length - 1)) +
        (mapGet(lessonData, ['duree']) - 1);

    ///Get the correct hours
    ///Pronote gives us the place where the hour should be in a week, when we modulo that with the amount of
    ///hours in a day we can get the "place" when the hour starts. Then we just add the duration (and substract 1)
    for (Map? endTime in (mapGet(client.funcOptions, ['donneesSec', 'donnees', 'General', 'ListeHeuresFin', 'V']))) {
      if (mapGet(endTime, ['G']) == endPlace) {
        if (endTime != null) {
          CustomLogger.log(
              "PRONOTE", "Lessons: " + matiere! + " " + "START " + start.toString() + " END " + endTime["L"]);
        }
        DateTime endTimeDate = DateFormat("""HH'h'mm""").parse(mapGet(endTime, ["L"]));
        end = DateTime(start.year, start.month, start.day, endTimeDate.hour, endTimeDate.minute);
      }
    }

    String? room;
    try {
      var roomContainer = mapGet(lessonData, ["ListeContenus", "V"]) ?? [].firstWhere((element) => element["G"] == 17);
      room = mapGet(roomContainer, ["L"]);
    }

    //Sort of null aware
    catch (e) {
      CustomLogger.error(e, stackHint:"MTc=");
    }
    List<String?> teachers = [];
    try {
      mapGet(lessonData, ["ListeContenus", "V"]).forEach((element) {
        if (element["G"] == 3) {
          teachers.add(element["L"]);
        }
      });
    } catch (e) {
      CustomLogger.error(e, stackHint:"MTg=");
    }

    //Some attributes
    String codeMatiere = mapGet(lessonData, ["ListeContenus", "V", 0, "L"]).hashCode.toString();

    String? id = mapGet(lessonData, ["N"]);

    String? status;
    bool? canceled = false;

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
        duration: end!.difference(start).inMinutes,
        canceled: canceled,
        status: status,
        discipline: matiere,
        id: id,
        disciplineCode: codeMatiere);
    //return lesson
    return l;
  }

  static lessons(PronoteClient client, Map lessonsData) {
    List<Lesson> lessonsList = [];
    List<Map> lessonsListRaw = (mapGet(lessonsData, ['donneesSec', 'donnees', 'ListeCours']) ?? []).cast<Map>();

    for (var lesson in lessonsListRaw) {
      try {
        lessonsList.add(PronoteLessonsConverter.lesson(client, lesson));
      } catch (e) {
        CustomLogger.error(e, stackHint:"MTk=");
      }
    }
    return lessonsList;
  }
}
