import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';

class EcoleDirecteSchoolLifeConverter {
  static List<SchoolLifeTicket> schoolLife(Map<String, dynamic> schoolLifeData) {
    List rawschoolLife = schoolLifeData['data']['absencesRetards'];
    List<SchoolLifeTicket> schoolLifeList = [];
    rawschoolLife.forEach((element) {
      String libelle = element["libelle"];
      String displayDate = element["displayDate"];
      String motif = element["motif"];
      String type = element["typeElement"];
      bool isJustified = element["justifie"];
      schoolLifeList.add(SchoolLifeTicket(libelle, displayDate, motif, type, isJustified));
    });
    CustomLogger.log("ED", "School life list: $schoolLifeList");
    return schoolLifeList;
  }
}
