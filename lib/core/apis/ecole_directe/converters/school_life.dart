import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class EcoleDirecteSchoolLifeConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter schoolLife = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> schoolLifeData) {
        List rawschoolLife = schoolLifeData['data']['absencesRetards'];
        List<SchoolLifeTicket> schoolLifeList = [];
        for (var element in rawschoolLife) {
          String libelle = element["libelle"];
          String displayDate = element["displayDate"];
          String motif = element["motif"];
          String type = element["typeElement"];
          bool isJustified = element["justifie"];
          schoolLifeList.add(SchoolLifeTicket(libelle, displayDate, motif, type, isJustified));
        }
        CustomLogger.log("ED", "School life list: $schoolLifeList");
        return schoolLifeList;
      });
}
