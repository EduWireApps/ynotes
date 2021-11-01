import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ynotes/core/apis/lvs/converters_exporter.dart';
import 'package:ynotes/core/apis/lvs/lvs_client.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/disciplines/disciplines.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

import '../../../globals.dart';
import '../../../useful_methods.dart';

Future<dynamic> fetch(Function onlineFetch, Function offlineFetch,
    {bool forceFetch = false}) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    return await offlineFetch();
  } else if (forceFetch) {
    try {
      await onlineFetch();
      return await offlineFetch();
    } catch (e) {
      CustomLogger.error("Error while fetching: " + e.toString());
      return await offlineFetch();
    }
  }
}

class LvsMethods {
  LvsClient client;
  final Offline _offlineController;

  LvsMethods(this.client, this._offlineController);

  Future<List<Discipline>?> grades() async {
    List<Discipline> disciplines = [];
    var req =
        await this.client.get(Uri.parse('/vsn.main/releveNote/releveNotes'));
    List periods = ['1er Trimestre', '2nd Trimestre', '3ème Trimestre'];
    var periodsData = LvsDisciplineConverter.getPeriods(req.body);

    for (var index = 0; index < periodsData.length; index++) {
      var resp =
          await this.client.get(Uri.parse(periodsData[index].toString()));
      var dis = LvsDisciplineConverter.get_disciplines(resp.body);
      dis.forEach((element) {
        element.periodName = periods[index];
        element.periodCode = periods[index];
      });
      disciplines.addAll(dis);
    }
    await DisciplinesOffline(_offlineController).updateDisciplines(disciplines);
    appSys.settings.system.lastGradeCount =
        (getAllGrades(disciplines, overrideLimit: true) ?? []).length;
    appSys.saveSettings();
  }

  Future<List<Homework>?> homeworkFor(DateTime date) async {
    HwClient hwClient = await this.client.getHwClient();
    var h = await searchHw(hwClient, date, date.add(Duration(days: 2)));
  }

  nextHomework() async {
    var date = new DateTime.now();
    var end_date = date.add(Duration(days: 25));
    HwClient hwClient = await this.client.getHwClient();
    await searchHw(hwClient, date, end_date);
  }

  searchHw(HwClient hwClient, DateTime date, DateTime end_date) async {
    CustomLogger.log('LVS_HW', 'searching hw');

    DateTime search_date = end_date.subtract(const Duration(days: 2));

    var search = await hwClient.post(
        Uri.parse('/rechercheActivite/rechercheJournaliere'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded; charset=UTF-8"
        },
        body: "params=%7B%22start%22%3A0%2C%22limit%22%3A100%2C%22contexteId%22%3A-1%2C%22typeId%22%3A-1%2C%22cdtId%22%3A-1%2C%22matiereId%22%3A-1%2C%22groupeId%22%3A-1%2C%22dateDebut%22%3A%22" +
            date.day.toString() +
            "%2F" +
            date.month.toString() +
            "%2F" +
            date.year.toString() +
            "%22%2C%22dateFin%22%3A%22" +
            search_date.day.toString() +
            "%2F" +
            search_date.month.toString() +
            "%2F" +
            search_date.year.toString() +
            "%22%2C%22actionRecherche%22%3Atrue%2C%22activeTab%22%3A%22idlisteTab%22%7D&xaction=read");

    List searchIds = [];
    Map af = {}; //attached files
    json.decode(search.body)['activites'].forEach((element) {
      af[element['activiteId'].toString()] = element['activiteDocuments'];
      searchIds.add(element['activiteId'].toString());
    });

    var req = await hwClient.get(Uri.parse('/vueCalendaire/eleve'),
        params: '?timeshift=-120&from=' +
            date.year.toString() +
            '-' +
            date.month.toString() +
            '-' +
            date.day.toString() +
            '&to=' +
            end_date.year.toString() +
            '-' +
            end_date.month.toString() +
            '-' +
            end_date.day.toString());
    List<Homework>? hw = LvsHomeworkConverter.homework(req.body);
    (hw).removeWhere((element) => !searchIds.contains(element.id));

    var ids = [];
    hw.reversed.toList().forEach((element) {
      if (ids.contains(element.id)) {
        hw.remove(element);
      } else {
        element.files
            .addAll(LvsHomeworkConverter.get_af(af[element.id], hwClient));
        ids.add(element.id);
      }
    });
    if (hw.length > 0) {
      await HomeworkOffline(_offlineController).updateHomework(hw);
      CustomLogger.log('LVS_HW', "Hw updated");
    }
  }
}
