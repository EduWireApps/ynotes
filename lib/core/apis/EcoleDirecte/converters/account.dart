import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';
import 'package:ynotes/main.dart';

class EcoleDirecteAccountConverter {
  static AppAccount account(Map<String, dynamic> accountData) {
    List<Map>? rawSchoolAccounts = mapGet(accountData, ["data", "accounts", 0, "profile", "eleves"]);

    if (rawSchoolAccounts != null) {
      var data = mapGet(accountData, ["data", "accounts", 0]);
      String? name = mapGet(data, ["prenom"]);
      String? surname = mapGet(data, ["nom"]);
      String? id = uuid.v1();
      bool isParentMainAccount = true;
      List<SchoolAccount> _schoolAccountsList = schoolAccounts(rawSchoolAccounts);
      return AppAccount(
          name: name,
          surname: surname,
          id: id,
          managableAccounts: _schoolAccountsList,
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.EcoleDirecte);
    } else {
      SchoolAccount _account = singleSchoolAccount(accountData);
      String? name = _account.name;
      String? surname = _account.surname;
      String? id = uuid.v1();
      bool isParentMainAccount = false;
      return AppAccount(
          name: name,
          surname: surname,
          id: id,
          managableAccounts: [_account],
          isParentMainAccount: isParentMainAccount,
          apiType: API_TYPE.EcoleDirecte);
    }
  }

  static List<appTabs> availableTabs(List<Map<String, dynamic>>? modules) {
    List<appTabs> tabs = [];
    (modules ?? []).forEach((element) {
//Tabs available in app
      if (element["enable"] == true) {
        switch (element["code"]) {
          case "VIE_SCOLAIRE":
            break;
          case "NOTES":
            tabs.add(appTabs.GRADES);
            break;
          case "MESSAGERIE":
            tabs.add(appTabs.MESSAGING);

            break;
          case "CLOUD":
            tabs.add(appTabs.CLOUD);

            break;
          case "CAHIER_DE_TEXTES":
            tabs.add(appTabs.HOMEWORK);

            break;
          default:
        }
      }
      //always available tabs
      tabs.add(appTabs.FILES);
      tabs.add(appTabs.SUMMARY);
    });
    return tabs;
  }

  static List<Period> periods(Map<String, dynamic> periodsData) {
    List rawPeriods = periodsData['data']['periodes'];
    List<Period> periods = [];
    rawPeriods.forEach((element) {
      periods.add(Period(element["periode"], element["idPeriode"]));
    });
    return periods;
  }

  static List<SchoolAccount> schoolAccounts(List<Map<dynamic, dynamic>> schoolAccountsData) {
    List<SchoolAccount> accounts = [];
    schoolAccountsData.forEach((rawAccountData) {
      String? name = mapGet(rawAccountData, ["prenom"]);
      String? surname = mapGet(rawAccountData, ["nom"]);
      String? schoolName = mapGet(rawAccountData, ["classe", "nomEtablissement"]);
      String? studentClass = mapGet(rawAccountData, ["classe", "libelle"]);
      String? studentID = mapGet(rawAccountData, ["id"]);
      List<appTabs> tabs = availableTabs(mapGet(rawAccountData, ["modules"]));
      accounts.add(SchoolAccount(
          name: name,
          surname: surname,
          studentClass: studentClass,
          studentID: studentID,
          availableTabs: tabs,
          schoolName: schoolName));
    });
    return accounts;
  }

  static SchoolAccount singleSchoolAccount(Map<dynamic, dynamic> schoolAccountsData) {
    schoolAccountsData = mapGet(schoolAccountsData, ["data", "accounts", 0]);
    String? name = mapGet(schoolAccountsData, ["prenom"]);
    String? surname = mapGet(schoolAccountsData, ["nom"]);
    String? schoolName = mapGet(schoolAccountsData, ["classe", "nomEtablissement"]);
    String? studentClass = mapGet(schoolAccountsData, ["classe", "libelle"]);
    String? studentID = mapGet(schoolAccountsData, ["id"]);
    List<appTabs> tabs = availableTabs(mapGet(schoolAccountsData, ["modules"]));
    return SchoolAccount(
        name: name,
        surname: surname,
        studentClass: studentClass,
        studentID: studentID,
        availableTabs: tabs,
        schoolName: schoolName);
  }
}
