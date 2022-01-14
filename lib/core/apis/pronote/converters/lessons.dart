import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class PronoteLessonsConverter {
  static Lesson lesson(PronoteClient client, Map lessonData) {
    String? matiere = lessonData["ListeContenus"]["V"][0]["L"];
    DateTime start = DateFormat("dd/MM/yyyy HH:mm:ss", "fr_FR").parse(lessonData["DateDuCours"]["V"]);
    DateTime? end;

    int? endPlace = (lessonData['place'] %
            ((client.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V']).length - 1)) +
        (lessonData['duree'] - 1);

    ///Get the correct hours
    ///Pronote gives us the place where the hour should be in a week, when we modulo that with the amount of
    ///hours in a day we can get the "place" when the hour starts. Then we just add the duration (and substract 1)
    for (Map? endTime in (client.funcOptions['donneesSec']['donnees']['General']['ListeHeuresFin']['V'])) {
      if (endTime?['G'] == endPlace) {
        if (endTime != null) {
          CustomLogger.log(
              "PRONOTE", "Lessons: " + matiere! + " " + "START " + start.toString() + " END " + endTime["L"]);
        }
        DateTime endTimeDate = DateFormat("""HH'h'mm""").parse(endTime?["L"]);
        end = DateTime(start.year, start.month, start.day, endTimeDate.hour, endTimeDate.minute);
      }
    }

    String? room;
    try {
      var roomContainer = lessonData["ListeContenus"]["V"] ?? [].firstWhere((element) => element["G"] == 17);
      room = roomContainer["L"];
    }

    //Sort of null aware
    catch (e) {
      CustomLogger.error(e, stackHint: "MTc=");
    }
    List<String?> teachers = [];
    try {
      lessonData["ListeContenus"]["V"].forEach((element) {
        if (element["G"] == 3) {
          teachers.add(element["L"]);
        }
      });
    } catch (e) {
      CustomLogger.error(e, stackHint: "MTg=");
    }

    //Some attributes
    String codeMatiere = lessonData["ListeContenus"]["V"][0]["L"].hashCode.toString();

    String? id = lessonData["N"];

    String? status;
    bool? canceled = false;

    //Set lesson status
    if (lessonData["Statut"] != null) {
      status = lessonData["Statut"];
    }
    if (lessonData["estAnnule"] != null) {
      canceled = lessonData["estAnnule"];
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
    List<Map> lessonsListRaw = (lessonsData['donneesSec']['donnees']['ListeCours'] ?? []).cast<Map>();

    for (var lesson in lessonsListRaw) {
      try {
        lessonsList.add(PronoteLessonsConverter.lesson(client, lesson));
      } catch (e) {
        CustomLogger.error(e, stackHint: "MTk=");
      }
    }
    return lessonsList;
  }
}
