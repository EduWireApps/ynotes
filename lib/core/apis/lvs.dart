import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ynotes/core/apis/lvs/lvs_methods.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/shared/models.dart';
import 'package:ynotes/core/logic/agenda/models.dart';

import 'package:http/src/request.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

import 'lvs/lvs_client.dart';
import 'lvs/converters/account.dart';
import 'model.dart';

final storage = new FlutterSecureStorage();

void createStorage(String key, String? data) async {
  await storage.write(key: key, value: data);
}

class APILVS extends API {
  LvsClient client = LvsClient();
  APILVS(Offline offlineController) : super(offlineController, apiName: "Lvs");

  @override
  Future<List> login(username, password, {Map? additionnalSettings}) async {
    print('wooow');
    //  CustomLogger.saveLog(object: 'LVS', text: 'Login called');
    if (username == null) {
      username = "";
    }
    if (password == null) {
      password = "";
    }
    // if (url == null) {
    //   url = "";
    // }

    var url = 'https://institut';

    Map<String, dynamic> credentials = {
      'url': Uri.parse(url),
      'username': username,
      'password': password
    };

    List res = await this.client.start(credentials);

    if (res[0] == 1) {
      try {
        var req_infos = await this
            .client
            .get(Uri.parse('/vsn.main/WSMenu/infosPortailUser'));

        Map<String, dynamic> raw_infos = jsonDecode(req_infos.body);
        /*  raw_infos = {
          "infoUser": {
            "logo": "https://institut.la-vie-scolaire.fr/vsn.main/WSMenu/logo",
            "etabName": "Intitut",
            "userPrenom": "Inom",
            "userNom": "Iom",
            "profil": "Elève"
          },
          "plateform": ""
        }; */
        appSys.account = LvsAccountConverter.account(raw_infos);

        if (appSys.account != null &&
            appSys.account!.managableAccounts != null) {
          await storage.write(
              key: "appAccount", value: jsonEncode(appSys.account!.toJson()));
          appSys.currentSchoolAccount = appSys.account!.managableAccounts![0];
        } else {
          return [0, "Impossible de collecter les comptes."];
        }
        createStorage("password", password ?? "");
        createStorage("username", username ?? "");
        this.loggedIn = true;
        return ([1, "Bienvenue ${appSys.account?.name ?? "Invité"}!"]);
      } catch (e) {
        CustomLogger.error(
            'An error occured while registering the account: ' + e.toString());
      }
      return [
        0,
        "Erreur à l'inscription du compte. Seuls les comptes élèves sont supportés."
      ];
    }
    return [0, "Erreur à la connection"];
  }

  @override
  Future<List> apiStatus() async {
    return [1, "Pas de problème connu."];
  }

  @override
  app(String appname, {String? args, String? action, CloudItem? folder}) {
    switch (appname) {
    }
    ;
  }

  @override
  Future<List<Homework>?> getHomeworkFor(DateTime? dateHomework,
      {bool? forceReload}) async {
    return await fetch(
        () async => LvsMethods(await this.getClient(), this.offlineController)
            .homeworkFor(dateHomework!),
        () async =>
            HomeworkOffline(offlineController).getHomeworkFor(dateHomework!),
        forceFetch: forceReload ?? false);
  }

  @override
  Future<List<Homework>?> getNextHomework({bool? forceReload}) async {
    return await fetch(
        () async => LvsMethods(await this.getClient(), this.offlineController)
            .nextHomework(),
        () => HomeworkOffline(offlineController).getAllHomework(),
        forceFetch: forceReload ?? false);
  }

  @override
  Future<Request> downloadRequest(Document document) async {
    var cl = await this.getClient();
    var hw_client = await cl.getHwClient();
    var url = hw_client.base_url +
        "/fichier/afficherFichier" +
        hw_client.token +
        '?fichierId=' +
        document.id;
    return new Request('GET', Uri.parse(url));
  }

  @override
  Future<List<Discipline>?> getGrades({bool? forceReload}) async {
    return await fetch(
        () async =>
            LvsMethods(await this.getClient(), this.offlineController).grades(),
        () => DisciplinesOffline(offlineController).getDisciplines(),
        forceFetch: forceReload ?? false);
  }

  @override
  Future<List<Lesson>?> getNextLessons(DateTime from,
      {bool? forceReload}) async {
    // TODO: implement getNextLessons
    throw UnimplementedError();
  }

  @override
  Future<List<SchoolLifeTicket>?> getSchoolLife(
      {bool forceReload = false}) async {
    // TODO: implement getSchoolLife
    throw UnimplementedError();
  }

  @override
  Future<bool?> testNewGrades() async {
    // TODO: implement testNewGrades
    return (true);
  }

  @override
  Future uploadFile(String context, String id, String filepath) async {
    // Not available
    throw UnimplementedError();
  }

  getClient() async {
    if (!this.client.started) {
      throw ('Client is called but not started.');
    }
    return this.client;
  }
}
