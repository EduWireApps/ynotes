import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/appConfig/models.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';
import 'package:ynotes/core/utils/nullSafeMapGetter.dart';
import 'package:uuid/uuid.dart';

class PronoteAccountConverter {
  static AppAccount account(Map accountData) {
    Map? data = mapGet(accountData, ["donneesSec", "donnees", "ressource"]);
    List<appTabs> tabs = availableTabs(mapGet(accountData, ["donneesSec", "donnees", "listeOnglets"]),
        mapGet(accountData, ["donneesSec", "donnees", "listeOngletsInvisibles"]));
    if (mapGet(data, ["listeRessources"]) != null) {
      String? name = mapGet(data, ["L"]);
      bool isParentMainAccount = true;
      List<SchoolAccount> accounts = schoolAccounts(mapGet(data, ["listeRessources"]));
      (accounts).forEach((element) {
        element.availableTabs = tabs;
      });
      //we generate a random UUID
      String id = Uuid().v1();
      return AppAccount(
          name: name,
          managableAccounts: accounts,
          id: id,
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.Pronote);
    }
    //If this is a single account
    else {
      String? name = mapGet(data, ["L"]);
      bool isParentMainAccount = false;
      List<SchoolAccount> accounts = [singleSchoolAccount((data ?? {}))];
      String id = Uuid().v1();
      (accounts).forEach((element) {
        element.availableTabs = tabs;
      });
      return AppAccount(
          name: name,
          managableAccounts: accounts,
          id: id,
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.Pronote);
    }
  }

  static List<appTabs> availableTabs(List? alltabs, List? hiddenTabs) {
    List<int> tabsNumbers = [];
    List<appTabs> tabs = [];
    (alltabs ?? []).forEach((tab) {
      tabsNumbers.add(tab["G"]);

      (tab["Onglet"] ?? []).forEach((subtab) {
        tabsNumbers += subtab.values.where((b) => b is int).toList().cast<int>();
        //Sub sub tab
        (subtab["Onglet"] ?? []).forEach((subsubtab) {
          tabsNumbers += tabsNumbers + subsubtab.values.where((b) => b is int).toList().cast<int>();
        });
      });
    });
    CustomLogger.log("ACCOUNT", "Tabs numbers: $tabsNumbers");
    (hiddenTabs ?? []).forEach((element) {
      tabsNumbers.remove(element);
    });
    tabsNumbers.forEach((tabNumber) {
      switch (tabNumber) {
        case 16:
          tabs.add(appTabs.AGENDA);
          break;
        case 8:
          tabs.add(appTabs.POLLS);
          break;
        case 198:
          tabs.add(appTabs.GRADES);

          break;
        case 88:
          tabs.add(appTabs.HOMEWORK);
          break;
        default:
      }
    });
    tabs.add(appTabs.SUMMARY);
    tabs.add(appTabs.FILES);
    return tabs;
  }

  static List<SchoolAccount> schoolAccounts(List? schoolAccountsData) {
    List<SchoolAccount> accounts = [];
    (schoolAccountsData ?? []).forEach((studentData) {
      String? name = mapGet(studentData, ["L"]);
      String? studentClass = mapGet(studentData, ["classeDEleve", "L"]);
      String? schoolName = mapGet(studentData, ["Etablissement", "V", "L"]);
      String? studentID = mapGet(studentData, ["N"]);

      accounts.add(SchoolAccount(
          name: name, studentClass: studentClass, studentID: studentID, availableTabs: [], schoolName: schoolName));
    });
    return accounts;
  }

  static SchoolAccount singleSchoolAccount(Map schoolAccountData) {
    String? name = mapGet(schoolAccountData, ["L"]);
    String? schoolName = mapGet(schoolAccountData, ["Etablissement", "V", "L"]);
    String? studentClass = mapGet(schoolAccountData, ["classeDEleve", "L"]);
    String? studentID = mapGet(schoolAccountData, ["N"]);
    return SchoolAccount(
        name: name, studentClass: studentClass, studentID: studentID, availableTabs: [], schoolName: schoolName);
  }
}
