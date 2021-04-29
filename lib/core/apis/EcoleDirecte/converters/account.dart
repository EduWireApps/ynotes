import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

class EcoleDirecteAccountConverter {
  static List<SchoolAccount> accounts(Map<String, dynamic> accountData) {
    List studentAccounts = mapGet(accountData, ["data", "accounts", 0, "profile", "eleves"]);
    if (studentAccounts != null) {}
    return [];
  }

  static List<Period> periods(Map<String, dynamic> periodsData) {
    List rawPeriods = periodsData['data']['periodes'];
    List<Period> periods = [];
    rawPeriods.forEach((element) {
      periods.add(Period(element["periode"], element["idPeriode"]));
    });
    return periods;
  }
}
