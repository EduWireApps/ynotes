import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';
import 'package:uuid/uuid.dart';

class LvsAccountConverter {
  static AppAccount account(Map<dynamic, dynamic> accountData) {
    if (accountData["infoUser"]["profil"] != 'Elève') {
      throw ('Account type must be "Elève"');
    }
    SchoolAccount _account = singleSchoolAccount(accountData);
    String? name = _account.name;
    String? surname = _account.surname;
    String? id = Uuid().v1();
    bool isParentMainAccount = false;
    return AppAccount(
        name: name,
        surname: surname,
        id: id,
        managableAccounts: [_account],
        isParentMainAccount: isParentMainAccount,
        apiType: API_TYPE.Lvs);
  }

  static List<appTabs> availableTabs() {
    List<appTabs> tabs = [];
    tabs.add(appTabs.homework);
    tabs.add(appTabs.summary);
    tabs.add(appTabs.grades);
    tabs.add(appTabs.files);
    return tabs;
  }

  static SchoolAccount singleSchoolAccount(
      Map<dynamic, dynamic> schoolAccountData) {
    schoolAccountData = mapGet(schoolAccountData, ["infoUser"]);
    String? name = utf8convert(mapGet(schoolAccountData, ["userPrenom"]));
    String? surname = utf8convert(mapGet(schoolAccountData, ["userNom"]));
    String? schoolName = utf8convert(mapGet(schoolAccountData, ["etabName"]));
    String? studentClass = "";
    String? studentID = mapGet(schoolAccountData, ["id"]).toString();
    List<appTabs> tabs = availableTabs();
    if (schoolName.length > 37) {
      schoolName = schoolName.substring(0, 35) + '...';
      //quick fix if name is too long
    }
    return SchoolAccount(
        name: name,
        surname: surname,
        studentClass: studentClass,
        studentID: studentID,
        availableTabs: tabs,
        schoolName: schoolName);
  }
}
