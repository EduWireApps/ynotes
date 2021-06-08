import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/core/apis/Pronote/converters/account.dart';
import 'package:ynotes/core/apis/Pronote/pronoteMethods.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/offline/data/agenda/lessons.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/offline/data/polls/polls.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/settings/settingsPage.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logsPage.dart';


bool loginLock = false;

class APIPronote extends API {
  late PronoteClient localClient;

  late PronoteMethod pronoteMethod;

  int loginReqNumber = 0;

  APIPronote(Offline offlineController) : super(offlineController) {
    localClient = PronoteClient("");
    pronoteMethod = PronoteMethod(localClient, this.offlineController);
  }

  @override
  Future<List> apiStatus() async {
    return [1, "Pas de problème connu."];
  }

  @override
  Future app(String appname, {String? args, String? action, CloudItem? folder}) async {
    switch (appname) {
    }
  }

  @override
  Future<http.Request> downloadRequest(Document document) async {
    String url = await localClient.downloadUrl(document);
    http.Request request = http.Request('GET', Uri.parse(url));
    return request;
  }

  @override
  Future<List<DateTime>> getDatesNextHomework() {
    throw UnimplementedError();
  }

  @override
  @override
  Future<List<Discipline>?> getGrades({bool? forceReload}) async {
    return (await pronoteMethod.fetchAnyData(
        pronoteMethod.grades, DisciplinesOffline(offlineController).getDisciplines, "grades",
        forceFetch: forceReload ?? false));
  }

  @override
  Future<List<Homework>?> getHomeworkFor(DateTime? dateHomework, {bool? forceReload}) async {
    return (await pronoteMethod.fetchAnyData(
        pronoteMethod.homeworkFor, HomeworkOffline(offlineController).getHomeworkFor, "homework for",
        forceFetch: forceReload ?? false, offlineArguments: dateHomework, onlineArguments: dateHomework));
  }

  @override
  Future<List<Homework>?> getNextHomework({bool? forceReload}) async {
    return (await pronoteMethod.fetchAnyData(
        pronoteMethod.nextHomework, HomeworkOffline(offlineController).getAllHomework, "homework",
        forceFetch: forceReload ?? false));
  }

  @override
  Future<List<Lesson>?> getNextLessons(DateTime dateToUse, {bool? forceReload}) async {
    List<Lesson>? lessons = await pronoteMethod.fetchAnyData(
        pronoteMethod.lessons, LessonsOffline(offlineController).get, "lessons",
        forceFetch: forceReload ?? false, onlineArguments: dateToUse, offlineArguments: await getWeek(dateToUse));
    if (lessons != null) {
      lessons.retainWhere((lesson) =>
          DateTime.parse(DateFormat("yyyy-MM-dd").format(lesson.start!)) ==
          DateTime.parse(DateFormat("yyyy-MM-dd").format(dateToUse)));
    }
    return lessons;
  }

  getOfflinePeriods() async {
    try {
      List<Period> listPeriods = [];
      List<Discipline>? disciplines = await DisciplinesOffline(offlineController).getDisciplines();
      List<Grade> grades =
          (disciplines ?? []).map((e) => e.gradesList).toList().map((e) => e).expand((element) => element!).toList();
      grades.forEach((grade) {
        if (!listPeriods.any((period) => period.name == grade.periodName)) {
          listPeriods.add(Period(grade.periodName, grade.periodCode));
        }
      });

      listPeriods.sort((a, b) => a.name!.compareTo(b.name!));

      return listPeriods;
    } catch (e) {
      print("Error while collecting offline periods " + e.toString());
    }
  }

  getOnlinePeriods() async {
    try {
      List<Period> listPeriod = [];
      if (localClient.localPeriods != null) {
        localClient.localPeriods.forEach((pronotePeriod) {
          listPeriod.add(Period(pronotePeriod.name, pronotePeriod.id));
        });

        return listPeriod;
      } else {
        var listPronotePeriods = localClient.periods();
        //refresh local pronote periods
        localClient.localPeriods = [];
        (listPronotePeriods).forEach((pronotePeriod) {
          listPeriod.add(Period(pronotePeriod.name, pronotePeriod.id));
        });
        return listPeriod;
      }
    } catch (e) {
      print("Erreur while getting period " + e.toString());
    }
  }

  Future<List<PollInfo>?> getPronotePolls({bool? forceReload}) async {
    List<PollInfo>? listPolls = [];
    List<PollInfo>? pollsFromInternet = (await pronoteMethod.fetchAnyData(
      pronoteMethod.polls,
      PollsOffline(offlineController).get,
      "polls",
      forceFetch: forceReload ?? false,
    ));
    listPolls.addAll(pollsFromInternet ?? []);
    return listPolls;
  }

  @override
  Future<List<SchoolLifeTicket>> getSchoolLife({bool forceReload = false}) async {
    return [];
  }

  initMethod() {
    pronoteMethod = PronoteMethod(localClient, this.offlineController);
  }

  @override
  Future<List> login(username, password, {url, cas, mobileCasLogin}) async {
    var stack = StackTrace.current;
    var stackString = "$stack";
    print(stackString);
    print(username + " " + password + " " + url);
    int req = 0;

    while (loginLock == true && req < 8 && appSys.loginController.actualState != loginStatus.loggedIn) {
      print("Locked, trying in 5 seconds...");
      req++;
      await Future.delayed(Duration(seconds: 5), () => "1");
    }
    if (loginLock == false && loginReqNumber < 5) {
      loginReqNumber = 0;
      loginLock = true;
      try {
        var cookies = await callCas(cas, username, password, url ?? "");
        localClient =
            PronoteClient(url, username: username, password: password, mobileLogin: mobileCasLogin, cookies: cookies);

        bool? login = await localClient.init();
        print(login);
        if (login ?? false) {
          if (localClient.paramsUser != null) {
            appSys.account = PronoteAccountConverter.account(localClient.paramsUser!);
          }

          if (appSys.account != null && appSys.account!.managableAccounts != null) {
            await storage.write(key: "appAccount", value: jsonEncode(appSys.account!.toJson()));
            appSys.currentSchoolAccount = appSys.account!.managableAccounts![0];
          } else {
            loginLock = false;
            print("Impossible to collect accounts");
            return [0, "Impossible de collecter les comptes."];
          }

          this.loggedIn = true;
          loginLock = false;
          pronoteMethod = PronoteMethod(localClient, this.offlineController);
          return ([1, "Bienvenue ${appSys.account?.name ?? "Invité"}!"]);
        } else {
          loginLock = false;
          return ([
            0,
            "Oups, une erreur a eu lieu. Vérifiez votre mot de passe et les autres informations de connexion.",
            localClient.stepsLogger
          ]);
        }
      } catch (e) {
        loginLock = false;
        localClient.stepsLogger.add("❌ Pronote login failed : " + e.toString());
        print(e);
        String error = "Une erreur a eu lieu. " + e.toString();
        if (e.toString().contains("invalid url")) {
          error = "L'URL entrée est invalide";
        }
        if (e.toString().contains("split")) {
          error =
              "Le format de l'URL entrée est invalide. Vérifiez qu'il correspond bien à celui fourni par votre établissement";
        }
        if (e.toString().contains("runes")) {
          error = "Le mot de passe et/ou l'identifiant saisi(s) est/sont incorrect(s)";
        }
        if (e.toString().contains("IP")) {
          error =
              "Une erreur inattendue  a eu lieu. Pronote a peut-être temporairement suspendu votre adresse IP. Veuillez recommencer dans quelques minutes.";
        }
        if (e.toString().contains("SocketException")) {
          error = "Impossible de se connecter à l'adresse saisie. Vérifiez cette dernière et votre connexion.";
        }
        if (e.toString().contains("Invalid or corrupted pad block")) {
          error = "Le mot de passe et/ou l'identifiant saisi(s) est/sont incorrect(s)";
        }
        if (e.toString().contains("HTML PAGE")) {
          error = "Problème de page HTML.";
        }
        if (e.toString().contains("nombre d'erreurs d'authentification autorisées")) {
          error =
              "Vous avez dépassé le nombre d'erreurs d'authentification authorisées ! Réessayez dans quelques minutes.";
        }
        if (e.toString().contains("Failed login request")) {
          error = "Impossible de se connecter à l'URL renseignée. Vérifiez votre connexion et l'URL entrée.";
        }
        print("test");
        await logFile(error);
        return ([0, error, localClient.stepsLogger]);
      }
    } else {
      loginReqNumber++;
      return [0, null];
    }
  }

  Future<bool> setPronotePollRead(PollInfo poll, PollQuestion question) async {
    try {
      String publicID = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "N"]);
      int publicType = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "G"]);
      String publicName = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "L"]);

      var data = {
        "donnees": {
          "listeActualites": [
            {
              "N": poll.id,
              "E": publicType,
              "validationDirecte": true,
              "genrePublic": publicType,
              "public": {"N": publicID, "G": publicType, "L": publicName},
              "lue": poll.read,
              "supprimee": false,
              "marqueLueSeulement": false,
              "saisieActualite": false,
              "listeQuestions": [
                {
                  "N": question.id,
                  "L": question.questionName,
                  "E": 2,
                  "genreReponse": 2,
                  "reponse": {
                    "N": 0,
                    "E": 1,
                    "Actif": true,
                    "avecReponse": true,
                    "valeurReponse": "",
                    "_validationSaisie": true
                  }
                }
              ]
            }
          ],
          "saisieActualite": false
        }
      };
      print(jsonEncode(data));
      var a = await pronoteMethod.request("SaisieActualites", null, data: data, onglet: 8);
      print(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setPronotePolls(PollInfo poll, PollQuestion question, PollChoice choice) async {
    try {
      String publicID = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "N"]);
      int publicType = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "G"]);
      String publicName = mapGet(localClient.paramsUser, ["donneesSec", "donnees", "ressource", "L"]);

      var data = {
        "donnees": {
          "listeActualites": [
            {
              "N": poll.id,
              "E": publicType,
              "validationDirecte": true,
              "genrePublic": publicType,
              "public": {"N": publicID, "G": publicType, "L": publicName},
              "lue": poll.read,
              "supprimee": false,
              "marqueLueSeulement": false,
              "saisieActualite": false,
              "listeQuestions": [
                {
                  "N": question.id,
                  "L": question.questionName,
                  "E": 2,
                  "genreReponse": 2,
                  "reponse": {
                    "N": question.answerID,
                    "E": 2,
                    "Actif": true,
                    "valeurReponse": {"_T": 8, "V": "[" + choice.rank.toString() + "]"},
                    "avecReponse": true,
                    "_validationSaisie": true
                  }
                }
              ]
            }
          ],
          "saisieActualite": false
        }
      };
      print(jsonEncode(data));
      var a = await pronoteMethod.request("SaisieActualites", null, data: data, onglet: 8);
      print(a);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool?> testNewGrades() async {
    return null;
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) {
    throw UnimplementedError();
  }
}
