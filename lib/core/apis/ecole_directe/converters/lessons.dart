import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class EcoleDirecteLessonConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter lessons = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> lessonData) async {
        List<Lesson> lessons = [];
        List<Map> listLessons = lessonData["data"].cast<Map>();
        await Future.forEach(listLessons, (Map lesson) async {
          String room = lesson["salle"].toString();
          List<String> teachers = [lesson["prof"]];
          DateTime start = DateFormat("yyyy-MM-dd HH:mm").parse(lesson["start_date"]);
          DateTime end = DateFormat("yyyy-MM-dd HH:mm").parse(lesson["end_date"]);
          bool canceled = lesson["isAnnule"] == true;
          String matiere = lesson["matiere"];
          String codeMatiere = lesson["codeMatiere"].toString();
          Lesson parsedLesson = Lesson(
              room: room,
              teachers: teachers,
              start: start,
              end: end,
              canceled: canceled,
              discipline: matiere,
              disciplineCode: codeMatiere,
              id: (await getLessonID(start, end, matiere)).toString());
          lessons.add(parsedLesson);
        });

        return lessons;
      });
}
