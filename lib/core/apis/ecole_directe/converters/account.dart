import 'dart:convert';

import 'package:uuid/uuid.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/anonymizer_utils.dart';

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
        List<Map>? rawSchoolAccounts = accountData["data"]["accounts"][0]["profile"]["eleves"]?.cast<Map>();

        if (rawSchoolAccounts != null) {
          var data = accountData["data"]["accounts"][0];
          String? name = utf8convert(data["prenom"]);
          String? surname = utf8convert(data["nom"]);
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
      String? name = utf8convert(rawAccountData["prenom"]);
      String? surname = utf8convert(rawAccountData["nom"]);
      String? schoolName = utf8convert(rawAccountData["nomEtablissement"]);
      String? studentClass = utf8convert(rawAccountData["classe"]["libelle"]);
      String? studentID = rawAccountData["id"].toString();
      List<appTabs> tabs = availableTabs(rawAccountData["modules"]);
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
    schoolAccountsData = schoolAccountsData["data"]["accounts"][0];
    String? name = utf8convert(schoolAccountsData["prenom"]);
    String? surname = utf8convert(schoolAccountsData["nom"]);
    String? schoolName = utf8convert(schoolAccountsData["profile"]["nomEtablissement"]);
    String? studentClass = utf8convert(schoolAccountsData["profile"]["classe"]["libelle"]);
    String? studentID = schoolAccountsData["id"].toString();
    List<appTabs> tabs = availableTabs(schoolAccountsData["modules"]);
    String? profilePicture = utf8convert(schoolAccountsData["profile"]["photo"]);
    return SchoolAccount(
        name: name,
        surname: surname,
        studentClass: studentClass,
        studentID: studentID,
        availableTabs: tabs,
        schoolName: schoolName,
        profilePicture: profilePicture);
  }
}
