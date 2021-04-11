import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteSchoolLifeConverter {
  static List<SchoolLifeTicket> schoolLife(Map<String, dynamic> schoolLifeData) {
    List rawschoolLife = schoolLifeData['data']['abscencesRetards'];
    List<SchoolLifeTicket> schoolLifeList = List();
    rawschoolLife.forEach((element) {
      String libelle = element["libelle"];
      String displayDate = element["displayDate"];
      String motif = element["motif"];
      String type = element["typeElement"];
      bool isJustified = element["justifie"];
      schoolLifeList.add(SchoolLifeTicket(libelle, displayDate, motif, type, isJustified));
    });
    return schoolLifeList;
  }
}
