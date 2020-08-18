import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:requests/requests.dart';
import 'package:ynotes/UI/screens/logsPage.dart';
import 'package:ynotes/parsers/PronoteAPI.dart';
import 'package:ynotes/parsers/PronoteAPI.dart' as papi;
import 'package:ynotes/parsers/PronoteCas.dart';
import 'package:rxdart/rxdart.dart';
import '../apiManager.dart';
import 'package:flutter/services.dart';

import '../main.dart';
import '../offline.dart';
import '../usefulMethods.dart';
import 'EcoleDirecte.dart';

Client localClient;
//Locks are use to prohibit the app to send too much requests while collecting data and ensure there are made one by one
//They are ABSOLUTELY needed or user will be quickly IP suspended
bool gradeLock = false;
bool hwLock = false;
bool gradeRefreshRecursive = false;
bool hwRefreshRecursive = false;
bool loginLock = false;

class APIPronote extends API {
  @override
  // TODO: implement listApp
  List<App> get listApp => [];

  @override
  Future<List<Discipline>> getGrades({bool forceReload}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var offlineGrades = await offline.disciplines();

    //If force reload enabled the grades will be loaded online
    if ((connectivityResult == ConnectivityResult.none ||
            forceReload == false ||
            forceReload == null) &&
        offlineGrades != null) {
      print("Loading grades from offline storage.");

      var toReturn = await offline.disciplines();
      await refreshDisciplinesListColors(toReturn);
      return toReturn;
    } else {
      print("Loading grades inline.");
      var toReturn = await getGradesFromInternet();
      await refreshDisciplinesListColors(toReturn);
      return toReturn;
    }
  }

  getGradesFromInternet() async {
    int req = 0;
    //Time out of 20 seconds. Wait until the task is unlocked
    while (gradeLock == true && req < 10) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    //Wait until task is unlocked to avoid parallels execution
    if (gradeLock == false) {
      print("GETTING GRADES");
      gradeLock = true;
      try {
        List periods = await localClient.periods();

        List<Grade> grades = List<Grade>();
        List averages = List();
        List<Discipline> listDisciplines = List<Discipline>();
        for (var i = 0; i < periods.length; i++) {
          //Grades and average
          List data = await periods[i].grades(i + 1);

          grades.addAll(data[0]);
          averages.addAll(data[1]);

          var z = 0;
          grades.forEach((element) {
            if (listDisciplines.every((listDisciplineEl) =>
                listDisciplineEl.nomDiscipline != element.libelleMatiere ||
                listDisciplineEl.periode != element.nomPeriode)) {
              listDisciplines.add(Discipline(
                  codeMatiere: element.codeMatiere,
                  codeSousMatiere: List(),
                  nomDiscipline: element.libelleMatiere,
                  periode: element.nomPeriode,
                  gradesList: List(),
                  professeurs: List(),
                  moyenne: averages[z][0],
                  moyenneMax: averages[z][1],
                  moyenneClasse: element.moyenneClasse,
                  moyenneGeneraleClasse: periods[i].moyenneGeneraleClasse,
                  moyenneGenerale: periods[i].moyenneGenerale));
            }
            z++;
          });
        }

        listDisciplines.forEach((element) {
          element.gradesList
              .addAll(grades.where((grade) => grade.libelleMatiere == element.nomDiscipline));
        });
        int index = 0;
        refreshDisciplinesListColors(listDisciplines);
        gradeLock = false;
        gradeRefreshRecursive = false;
        offline.updateDisciplines(listDisciplines);
        return listDisciplines;
      } catch (e) {
        gradeLock = false;
        print("HEY" + e.toString());
        List<Discipline> listDisciplines = List<Discipline>();
        if (gradeRefreshRecursive == false) {
          await refreshClient();
          gradeRefreshRecursive = true;

          listDisciplines.addAll(await getGrades());
        }

        return listDisciplines;
      }
    } else {
      print("GRADES WERE LOCKED");
      List<Discipline> listDisciplines = List<Discipline>();
      return listDisciplines;
    }
  }

  @override
  Future<List<Homework>> getHomeworkFor(DateTime dateHomework) async {
    int req = 0;
    //Time out of 20 seconds. Wait until the task is unlocked
    while (hwLock == true && req < 10) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    if (hwLock == false) {
      try {
        print("GETTING HOMEWORK");
        hwLock = true;

        List<Homework> listHW = List<Homework>();
        var hws = await localClient.homework(dateHomework, date_to: dateHomework);

        //This returns all the week
        listHW.addAll(hws);
        //Remove the others
        listHW.removeWhere((element) => element.date.day != dateHomework.day);

        hwLock = false;
        hwRefreshRecursive = false;
        return listHW;
      } catch (e) {
        print("Error while getting homework" + e);
        List<Homework> listHW = List<Homework>();
        hwLock = false;

        if (hwRefreshRecursive == false) {
          await refreshClient();
          hwRefreshRecursive = true;

          listHW.addAll(await getHomeworkFor(dateHomework));
        }
      }
    } else {
      print("HOMEWORK WERE LOCKED");
      List<Homework> listHW = List<Homework>();
      return listHW;
    }
    return null;
  }

  @override
  Future<List<Homework>> getNextHomework({bool forceReload}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    var offlineHomework = await offline.homework();

    //If force reload enabled the grades will be loaded online
    if ((connectivityResult == ConnectivityResult.none ||
            forceReload == false ||
            forceReload == null) &&
        offlineHomework != null) {
      print("Loading homework from offline storage.");

      return offlineHomework;
    } else {
      print("Loading homework inline.");
      var toReturn = await getNextHomeworkFromInternet();
      return toReturn;
    }
  }

  getNextHomeworkFromInternet() async {
    int req = 0;
    //Time out of 20 seconds. Wait until the task is unlocked
    while (hwLock == true && req < 10) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    if (hwLock == false) {
      try {
        print("GETTING HOMEWORK");
        hwLock = true;
        DateTime now = DateTime.now();
        List<Homework> listHW = List<Homework>();
        List<Homework> hws = await localClient.homework(now);
        listHW.addAll(hws);
        List<DateTime> pinnedDates = await offline.getPinnedHomeworkDates();
        //Wait for add pinned content
        await Future.wait(pinnedDates.map((element) async {
          List<Homework> pinnedHomework = await localClient.homework(element, date_to: element);
          pinnedHomework.removeWhere((pinnedHWElement) => element.day != pinnedHWElement.date.day);
          listHW = listHW + pinnedHomework;
        }));

        //delete duplicates
        listHW = listHW.toSet().toList();

        hwLock = false;
        hwRefreshRecursive = false;
        offline.updateHomework(listHW);

        return listHW;
      } catch (e) {
        hwLock = false;
        print("Error while getting homework" + e.toString());
        List<Homework> listHW = List<Homework>();

        if (hwRefreshRecursive == false) {
          hwRefreshRecursive = true;
          await refreshClient();
          listHW.addAll(await getNextHomework());
        }
      }
    } else {
      print("HOMEWORK WERE LOCKED");
      List<Homework> listHW = List<Homework>();
      return listHW;
    }
  }

  @override
  Future<String> login(username, password, {url, cas}) async {
    print(username + " " + password + " " + url);
    int req = 0;
    while (loginLock == true && req < 3) {
      req++;
      await Future.delayed(const Duration(seconds: 2), () => "1");
    }
    if (loginLock == false) {
      loginLock = true;
      try {
        var cookies = await callCas(cas, username, password);
        localClient = Client(url, username: username, password: password, cookies: cookies);
        await localClient.init();
        if (localClient.logged_in) {
          this.loggedIn = true;
          loginLock = false;
          return ("Bienvenue $actualUser!");
        } else {
          loginLock = false;
          return ("Oups, une erreur a eu lieu. Vérifiez votre mot de passe et les autres informations de connexion.");
        }
      } catch (e) {
        loginLock = false;
        await logFile(e.toString());
        print(e);
        String error = "Une erreur a eu lieu.";
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
          error =
              "Impossible de se connecter à l'adresse saisie. Vérifiez cette dernière et votre connexion.";
        }
        if (e.toString().contains("nombre d'erreurs d'authentification autorisées")) {
          error =
              "Vous avez dépassé le nombre d'erreurs d'authentification authorisées ! Réessayez dans quelques minutes.";
        }
        return (error);

        return (error);
      }
    }
  }

  @override
  Future<bool> testNewGrades() async {
    return null;
  }

  @override
  Future app(String appname, {String args, String action, CloudItem folder}) {
    // TODO: implement app
    throw UnimplementedError();
  }

  @override
  Future uploadFile(String contexte, String id, String filepath) {
    // TODO: implement sendFile
    throw UnimplementedError();
  }

  @override
  Future<List<DateTime>> getDatesNextHomework() {
    // TODO: implement getDatesNextHomework
    throw UnimplementedError();
  }

  @override
  Future<List<Period>> getPeriods() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    try {
      return await getOfflinePeriods();
    } catch (e) {
      print("Erreur while getting offline period " + e);
      if (connectivityResult != ConnectivityResult.none) {
        if (localClient.logged_in) {
          print("getting periods online");
          return await getOnlinePeriods();
        } else {
          throw "Pronote isn't logged in";
        }
      } else {
        try {
          return await getOfflinePeriods();
        } catch (e) {
          throw ("Error while collecting offline periods");
        }
      }
    }
  }
}

getOfflinePeriods() async {
  try {
    List<Period> listPeriods = List();
    List<Discipline> disciplines = await offline.disciplines();
    List<Grade> grades = getAllGrades(disciplines, overrideLimit: true);
    grades.forEach((grade) {
      if (!listPeriods
          .any((period) => period.name == grade.nomPeriode && period.id == grade.codePeriode)) {
        listPeriods.add(Period(grade.nomPeriode, grade.codePeriode));
      }
    });

    listPeriods.sort((a, b) => a.name.compareTo(b.name));

    return listPeriods;
  } catch (e) {
    print("Error while collecting offline periods " + e.toString());
  }
}

getOnlinePeriods() async {
  try {
    List<Period> listPeriod = List<Period>();
    if (localClient.localPeriods != null) {
      localClient.localPeriods.forEach((pronotePeriod) {
        listPeriod.add(Period(pronotePeriod.name, pronotePeriod.id));
      });
      listPeriod.add(Period("test", "test"));
      return listPeriod;
    } else {
      var listPronotePeriods = await localClient.periods();
      //refresh local pronote periods
      localClient.localPeriods = listPronotePeriods;
      listPronotePeriods.forEach((pronotePeriod) {
        listPeriod.add(Period(pronotePeriod.name, pronotePeriod.id));
      });
      return listPeriod;
    }
  } catch (e) {
    print("Erreur while getting period " + e.toString());
  }
}

refreshClient() async {
  await tlogin.login();
}

getPronoteGradesFromInternet() async {
  int req = 0;
  //Time out of 20 seconds. Wait until the task is unlocked
  while (gradeLock == true && req < 10) {
    req++;
    await Future.delayed(const Duration(seconds: 2), () => "1");
  }
  //Wait until task is unlocked to avoid parallels execution
  if (gradeLock == false) {
    print("GETTING GRADES");
    gradeLock = true;
    try {
      List periods = await localClient.periods();

      List<Grade> grades = List<Grade>();
      List averages = List();
      List<Discipline> listDisciplines = List<Discipline>();
      for (var i = 0; i < periods.length; i++) {
        //Grades and average
        List data = await periods[i].grades(i + 1);

        grades.addAll(data[0]);
        averages.addAll(data[1]);

        var z = 0;
        grades.forEach((element) {
          if (listDisciplines.every((listDisciplineEl) =>
              listDisciplineEl.nomDiscipline != element.libelleMatiere ||
              listDisciplineEl.periode != element.nomPeriode)) {
            listDisciplines.add(Discipline(
                codeMatiere: element.codeMatiere,
                codeSousMatiere: List(),
                nomDiscipline: element.libelleMatiere,
                periode: element.nomPeriode,
                gradesList: List(),
                professeurs: List(),
                moyenne: averages[z][0],
                moyenneMax: averages[z][1],
                moyenneClasse: element.moyenneClasse,
                moyenneGeneraleClasse: periods[i].moyenneGeneraleClasse,
                moyenneGenerale: periods[i].moyenneGenerale));
          }
          z++;
        });
      }

      listDisciplines.forEach((element) {
        element.gradesList
            .addAll(grades.where((grade) => grade.libelleMatiere == element.nomDiscipline));
      });
      int index = 0;
      refreshDisciplinesListColors(listDisciplines);
      gradeLock = false;
      gradeRefreshRecursive = false;
      offline.updateDisciplines(listDisciplines);
      return listDisciplines;
    } catch (e) {
      gradeLock = false;
    }
  } else {
    print("GRADES WERE LOCKED");
    List<Discipline> listDisciplines = List<Discipline>();
    return listDisciplines;
  }
}
