import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/app_config/models.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

import 'package:uuid/uuid.dart';

class PronoteAccountConverter {
  static AppAccount account(Map accountData) {
    Map? data = accountData["donneesSec"]["donnees"]["ressource"];
    List<appTabs> tabs = availableTabs(accountData["donneesSec"]["donnees"]["listeOnglets"],
        accountData["donneesSec"]["donnees"]["listeOngletsInvisibles"]);
    if (data?["listeRessources"] != null) {
      String? name = data?["L"];
      bool isParentMainAccount = true;
      List<SchoolAccount> accounts = schoolAccounts(data?["listeRessources"]);
      for (var element in (accounts)) {
        element.availableTabs = tabs;
      }
      //we generate a random UUID
      String id = const Uuid().v1();
      return AppAccount(
          name: name,
          managableAccounts: accounts,
          id: id,
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.pronote);
    }
    //If this is a single account
    else {
      String? name = data?["L"];
      bool isParentMainAccount = false;
      List<SchoolAccount> accounts = [singleSchoolAccount((data ?? {}))];
      String id = const Uuid().v1();
      for (var element in (accounts)) {
        element.availableTabs = tabs;
      }
      return AppAccount(
          name: name,
          managableAccounts: accounts,
          id: id,
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.pronote);
    }
  }

  static List<appTabs> availableTabs(List? alltabs, List? hiddenTabs) {
    List<int> tabsNumbers = [];
    List<appTabs> tabs = [];
    for (var tab in (alltabs ?? [])) {
      tabsNumbers.add(tab["G"]);

      (tab["Onglet"] ?? []).forEach((subtab) {
        tabsNumbers += subtab.values.where((b) => b is int).toList().cast<int>();
        //Sub sub tab
        (subtab["Onglet"] ?? []).forEach((subsubtab) {
          tabsNumbers += tabsNumbers + subsubtab.values.where((b) => b is int).toList().cast<int>();
        });
      });
    }
    tabsNumbers = tabsNumbers.toSet().toList();
    tabsNumbers.sort();
    Logger.log("ACCOUNT", "Tabs numbers: $tabsNumbers");
    for (var element in (hiddenTabs ?? [])) {
      tabsNumbers.remove(element);
    }
    for (var tabNumber in tabsNumbers) {
      switch (tabNumber) {
        case 16:
          tabs.add(appTabs.agenda);
          break;
        case 8:
          tabs.add(appTabs.polls);
          break;
        case 198:
          tabs.add(appTabs.grades);

          break;
        case 88:
          tabs.add(appTabs.homework);
          break;
        default:
      }
    }
    tabs.add(appTabs.summary);
    tabs.add(appTabs.files);
    return tabs.toSet().toList();
  }

  static List<SchoolAccount> schoolAccounts(List? schoolAccountsData) {
    List<SchoolAccount> accounts = [];
    for (var studentData in (schoolAccountsData ?? [])) {
      String? name = studentData["L"];
      String? studentClass = studentData["classeDEleve"]["L"];
      String? schoolName = studentData["Etablissement"]["V"]["L"];
      String? studentID = studentData["N"];

      accounts.add(SchoolAccount(
          name: name, studentClass: studentClass, studentID: studentID, availableTabs: [], schoolName: schoolName));
    }
    return accounts;
  }

  static SchoolAccount singleSchoolAccount(Map schoolAccountData) {
    String? name = schoolAccountData["L"];
    String? schoolName = schoolAccountData["Etablissement"]["V"]["L"];
    String? studentClass = schoolAccountData["classeDEleve"]["L"];
    String? studentID = schoolAccountData["N"];
    return SchoolAccount(
        name: name, studentClass: studentClass, studentID: studentID, availableTabs: [], schoolName: schoolName);
  }
}
