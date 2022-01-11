import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/anonymizer_utils.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';

class EcoleDirecteAccountConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter account = YConverter(
      apiType: apiType,
      logSlot: "Account",
      anonymizer: (Map<dynamic, dynamic> accountData) {
        Map toAnonymize = {};
        return AnonymizerUtils.severalValues(jsonEncode(accountData), toAnonymize);
      },
      converter: (Map<dynamic, dynamic> accountData) {
        List<Map>? rawSchoolAccounts = mapGet(accountData, ["data", "accounts", 0, "profile", "eleves"])?.cast<Map>();

        if (rawSchoolAccounts != null) {
          var data = mapGet(accountData, ["data", "accounts", 0]);
          String? name = utf8convert(mapGet(data, ["prenom"]));
          String? surname = utf8convert(mapGet(data, ["nom"]));
          String? id = const Uuid().v1();
          bool isParentMainAccount = true;
          List<SchoolAccount> _schoolAccountsList = schoolAccounts(rawSchoolAccounts);
          return AppAccount(
              name: name,
              surname: surname,
              id: id,
              managableAccounts: _schoolAccountsList,
              isParentMainAccount: isParentMainAccount,
              apiType: API_TYPE.ecoleDirecte);
        } else {
          SchoolAccount _account = singleSchoolAccount(accountData);
          String? name = _account.name;
          String? surname = _account.surname;
          String? id = const Uuid().v1();
          bool isParentMainAccount = false;
          return AppAccount(
              name: name,
              surname: surname,
              id: id,
              managableAccounts: [_account],
              isParentMainAccount: isParentMainAccount,
              apiType: API_TYPE.ecoleDirecte);
        }
      });

  static YConverter periods = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> periodsData) {
        List rawPeriods = periodsData['data']['periodes'];
        List<Period> periods = [];
        for (var element in rawPeriods) {
          periods.add(Period(element["periode"], element["idPeriode"]));
        }
        return periods;
      });

  static List<appTabs> availableTabs(List? modules) {
    List<appTabs> tabs = [];
    for (var element in (modules ?? [])) {
//Tabs available in app
      if (element["enable"] == true) {
        switch (element["code"]) {
          case "VIE_SCOLAIRE":
            tabs.add(appTabs.schoolLife);
            break;
          case "NOTES":
            tabs.add(appTabs.grades);
            break;
          case "MESSAGERIE":
            tabs.add(appTabs.messaging);

            break;
          case "EDT":
            tabs.add(appTabs.agenda);

            break;
          case "CLOUD":
            tabs.add(appTabs.cloud);

            break;
          case "CAHIER_DE_TEXTES":
            tabs.add(appTabs.homework);
            break;
          default:
        }
      }
      //always available tabs
      tabs.add(appTabs.files);
      tabs.add(appTabs.summary);
    }
    return tabs;
  }

  static List<SchoolAccount> schoolAccounts(List<Map<dynamic, dynamic>> schoolAccountsData) {
    List<SchoolAccount> accounts = [];
    for (var rawAccountData in schoolAccountsData) {
      String? name = utf8convert(mapGet(rawAccountData, ["prenom"]));
      String? surname = utf8convert(mapGet(rawAccountData, ["nom"]));
      String? schoolName = utf8convert(mapGet(rawAccountData, ["nomEtablissement"]));
      String? studentClass = utf8convert(mapGet(rawAccountData, ["classe", "libelle"]));
      String? studentID = mapGet(rawAccountData, ["id"]).toString();
      List<appTabs> tabs = availableTabs(mapGet(rawAccountData, ["modules"]));
      accounts.add(SchoolAccount(
          name: name,
          surname: surname,
          studentClass: studentClass,
          studentID: studentID,
          availableTabs: tabs,
          schoolName: schoolName));
    }
    return accounts;
  }

  static SchoolAccount singleSchoolAccount(Map<dynamic, dynamic> schoolAccountsData) {
    schoolAccountsData = mapGet(schoolAccountsData, ["data", "accounts", 0]);
    String? name = utf8convert(mapGet(schoolAccountsData, ["prenom"]));
    String? surname = utf8convert(mapGet(schoolAccountsData, ["nom"]));
    String? schoolName = utf8convert(mapGet(schoolAccountsData, ["profile", "nomEtablissement"]));
    String? studentClass = utf8convert(mapGet(schoolAccountsData, ["profile", "classe", "libelle"]));
    String? studentID = mapGet(schoolAccountsData, ["id"]).toString();
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
