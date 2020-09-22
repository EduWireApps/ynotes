import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:alice/alice.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/UI/screens/logsPage.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte/EcoleDirecteCloud.dart';
import 'package:ynotes/parsers/EcoleDirecte/ecoleDirecteConverters.dart';
import 'package:ynotes/parsers/Pronote/PronoteAPI.dart';
import 'package:ynotes/parsers/Pronote/PronoteCas.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/apiManager.dart';
import 'package:dio/dio.dart' as dio;

import '../EcoleDirecte.dart';

class EcoleDirecteMethod {
  static lessons(DateTime dateToUse, int week) async {
    await EcoleDirecteMethod.testToken();
    String dateDebut = DateFormat("yyyy/MM/dd").format(getMonday(dateToUse));

    String dateFin = DateFormat("yyyy/MM/dd").format(getNextSunday(dateToUse));
    String data = 'data={"dateDebut":"$dateDebut","dateFin":"$dateFin","avecTrous":false,"token": "$token"}';
    String rootUrl = "https://api.ecoledirecte.com/v3/E/";
    String method = "emploidutemps.awp?verbe=get&";
    List<Lesson> lessonsList = await request(data, rootUrl, method, EcoleDirecteConverter.lessons, "Lessons request returned an error:");
    await offline.updateLessons(lessonsList, week);
    return lessonsList;
  }

  static periods() async {
    await EcoleDirecteMethod.testToken();
    String data = 'data={"token": "$token"}';
    String rootUrl = "https://api.ecoledirecte.com/v3/Eleves/";
    /*if (kDebugMode) {
      rootUrl = "http://demo2235921.mockable.io/";
    }*/
    String method = "notes.awp?verbe=get&";
    List<Period> periodsList = await request(
      data,
      rootUrl,
      method,
      EcoleDirecteConverter.periods,
      "Periods request returned an error:",
    );

    return periodsList;
  }

  static grades() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = "https://api.ecoledirecte.com/v3/Eleves/";
    /*if (kDebugMode) {
      rootUrl = "http://demo2235921.mockable.io/";
    }*/
    String method = "notes.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<Discipline> disciplinesList = await request(
      data,
      rootUrl,
      method,
      EcoleDirecteConverter.disciplines,
      "Grades request returned an error:", /*ignoreMethodAndId: true*/
    );

    //Update colors;
    refreshDisciplinesListColors(disciplinesList);
    await offline.updateDisciplines(disciplinesList);
    createStack();

    return disciplinesList;
  }

  static homeworkDates() async {
    await EcoleDirecteMethod.testToken();
    String rootUrl = 'https://api.ecoledirecte.com/v3/Eleves/';
    String method = "cahierdetexte.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<DateTime> homeworkDates = await request(data, rootUrl, method, EcoleDirecteConverter.homeworkDates, "Homework dates request returned an error:");
    bool isLimitedTo7Days = await getSetting("7DaysLimit");
    if (isLimitedTo7Days) {
      homeworkDates.removeWhere((date) => DateFormat("yyyy-MM-dd").parse(date.toString()).difference(DateFormat("yyyy-MM-dd").parse(DateTime.now().toString())).inDays > 7);
    }
    //Get pinned dates
    List<DateTime> pinnedDates = await offline.getPinnedHomeworkDates();
    //Combine lists
    pinnedDates.forEach((element) {
      if (!homeworkDates.any((hwlistelement) => hwlistelement == element)) {
        homeworkDates.add(element);
      }
    });

    return homeworkDates;
  }

  static nextHomework() async {
    await EcoleDirecteMethod.testToken();
    List<DateTime> localDTList = await homeworkDates();
    List<Homework> homeworkList = List<Homework>();
    await Future.forEach(localDTList, (date) async {
      List<Homework> list;
      list = await homeworkFor(date);
      list.forEach((h) {
        homeworkList.add(h);
      });
    });
    await offline.updateHomework(homeworkList);
    return homeworkList;
  }

  static Future<List<Homework>> homeworkFor(DateTime date) async {
    await EcoleDirecteMethod.testToken();
    String dateToUse = DateFormat("yyyy-MM-dd").format(date).toString();
    String rootUrl = 'https://api.ecoledirecte.com/v3/Eleves/';
    String method = "cahierdetexte/$dateToUse.awp?verbe=get&";
    String data = 'data={"token": "$token"}';
    List<Homework> homework = await request(data, rootUrl, method, EcoleDirecteConverter.homework, "Homework request returned an error:");
    homework.forEach((hw) {
      hw.date = date;
    });
    return homework;
  }

//Bool value and Token validity tester
  static testToken() async {
    if (token == "" || token == null) {
      await EcoleDirecteMethod.refreshToken();
      return false;
    } else {
      String id = await storage.read(key: "userID");
      var url = 'https://api.ecoledirecte.com/v3/$id/login.awp';
      Map<String, String> headers = {"Content-type": "text/plain"};
      String data = 'data={"token": "$token"}';
      //encode Map to JSON
      var body = data;
      var response = await http.post(url, headers: headers, body: body).catchError((e) {
        return false;
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> req = jsonDecode(response.body);
        if (req['code'] == 200) {
          return true;
        } else {
          await EcoleDirecteMethod.refreshToken();
          return false;
        }
      } else {
        await EcoleDirecteMethod.refreshToken();
        return false;
      }
    }
  }

  static request(String data, String rootUrl, String urlMethod, Function converter, String onErrorBody, {Map<String, String> headers, bool ignoreMethodAndId = false}) async {
    try {
      String id = await storage.read(key: "userID");

      String finalUrl = rootUrl + id + "/" + urlMethod;
      if (ignoreMethodAndId) {
        finalUrl = rootUrl;
      }
      if (headers == null) {
        headers = {"Content-type": "text/plain"};
      }
      var response = await http.post(finalUrl, headers: headers, body: data);
      printWrapped(finalUrl);
      Map<String, dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      if (response.statusCode == 200 && responseData != null && responseData['code'] != null && responseData['code'] == 200) {
        var parsedData = converter(responseData);
        return parsedData;
      } else {
        throw (onErrorBody + "  Server returned wrong statuscode.");
      }
    } catch (e) {
      throw (onErrorBody + " " + e.toString());
    }
  }

//Refresh the token if expired
  static refreshToken() async {
//Get the password in the secure storage
    String password = await storage.read(key: "password");
    String username = await storage.read(key: "username");
    var url = 'https://api.ecoledirecte.com/v3/login.awp';
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
    //encode Map to JSON
    var body = data;
    var response = await http.post(url, headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard. ${e.toString()}");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> req = jsonDecode(response.body);
      if (req['code'] == 200) {
        token = req['token'];
      }
      //Return an error
      else {
        throw "Error while refreshing token.";
      }
    } else {
      throw "Error while refreshing token.";
    }
  }

//Returns the suitable function according to connection state
  static fetchAnyData(dynamic onlineFetch, dynamic offlineFetch, {bool forceFetch = false}) async {
    //Test connection status
    var connectivityResult = await (Connectivity().checkConnectivity());
    //Offline
    if (connectivityResult == ConnectivityResult.none) {
      return await offlineFetch();
    } else if (forceFetch) {
      try {
        return await onlineFetch();
      } catch (e) {
        return await offlineFetch();
      }
    } else {
      //Offline data;
      var data = await offlineFetch();
      if (data == null) {
        data = await onlineFetch();
      }
      return data;
    }
  }

  static getMonday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  static getNextSunday(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1)).add(Duration(days: 6));
  }
}
