import 'dart:convert';
import 'dart:io';

import 'package:alice/model/alice_http_call.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:tinycolor/tinycolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/landGrades.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:ynotes/main.dart';

_launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

bool isDarkModeEnabled = false;

//Change notifier to deal with themes
class AppStateNotifier extends ChangeNotifier {
  bool isDarkMode = false;

  void updateTheme(bool isDarkMode) {
    this.isDarkMode = isDarkMode;
    isDarkModeEnabled = isDarkMode;

    notifyListeners();
  }
}

//Class download to notify view when download is ended
class DownloadModel extends ChangeNotifier {
  bool _isDownloading = false;
  double _progress = 0;
  get downloadProgress => _progress;
  get isDownloading => _isDownloading;
  Future<File> _getFile(String filename) async {
    final dir = await getExternalStorageDirectory();
    return File("${dir.path}/$filename");
  }

//check if file exists
  Future<bool> fileExists(filename) async {
    final dir = await getExternalStorageDirectory();
    return File("${dir.path}/$filename").exists();
  }

//Download a file in the app directory
  download(id, type, filename) async {
    _isDownloading = true;
    _progress = null;
    notifyListeners();
    var url =
        'https://api.ecoledirecte.com/v3/telechargement.awp?verbe=get';

    Map<String, String> headers = {"Content-type": "x"};

    String body =
        "leTypeDeFichier=$type&fichierId=$id&token=$token";
    Request request = Request('POST', Uri.parse(url));
    request.body = body.toString();

    //Make a response client
    final StreamedResponse response =
        await Client().send(request);
    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();
    print("Downloading a file : $filename");

    List<int> bytes = [];
    final file = await _getFile(filename);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;
        print(_progress);
        notifyListeners();
      },
      onDone: () async {
        _progress = 100;
        notifyListeners();
        print(
            "Téléchargement du fichier terminé : $filename");
        await file.writeAsBytes(bytes);
      },
      onError: (e) {
        print("Downloading file error : $e, on $filename");
      },
      cancelOnError: true,
    );
  }
}

Route router(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        widget,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end)
          .chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//Open a file
Future<void> openFile(filename) async {
  final dir = await getExternalStorageDirectory();
  final filePath = '${dir.path}/$filename';
  await OpenFile.open(filePath);
}

///Color theme switcher, actually 0 for darkmode and 1 for lightmode
int colorTheme = 0;
String actualUser;
Color GetColorFor(String element) {
  if (colorTheme == 0) {
    switch (element) {
      case "menuForeground":
        {}
        break;
      case "generalBackground":
        {
          return Color(0xff141414);
        }
        break;
    }
    if (colorTheme == 1) {
      switch (element) {
        case "menuForeground":
          {}
          break;
        case "generalBackground":
          {
            return Color(0xff141414);
          }
          break;
      }
    }
  }
}

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff1F1E1E),
    primaryColor: Color(0xff2C2C2C),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff404040),
    indicatorColor: Color(0xff404040),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));
ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Color(0xffF3F3F3),
    primaryColorDark: Color(0xffDCDCDC),
    indicatorColor: Color(0xffDCDCDC),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));
Future<bool> getSetting(String setting) async {
  final prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(setting);
  if (value == null) {
    setSetting(setting, false);
    value = false;
  }
  return value;
}

setSetting(String setting, bool value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);
}

///Make the selected color darker
Color darken(Color color, {double forceAmount}) {
  double amount = 0.05;
  var ColorTest = TinyColor(color);
  //Test if the color is not too light
  if (forceAmount == null) {
    if (ColorTest.isLight()) {
      amount = 0.2;
    }
    //Test if the color is something like yellow
    if (ColorTest.getLuminance() > 0.5) {
      amount = 0.2;
    }
    if (ColorTest.getLuminance() < 0.5) {
      amount = 0.18;
    }
  } else {
    amount = forceAmount;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness(
      (hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

class AppUtil {
  static Future<String> getFileNameWithExtension(
      File file) async {
    if (await file.exists()) {
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  static Future<DateTime> getLastModifiedDate(
      File file) async {
    if (await file.exists()) {
      return await file.lastModified();
    } else {
      return null;
    }
  }

  static remove(File file) async {
    if (await file.exists()) {
      file.delete();
    } else {
      return null;
    }
  }
}

class FileInfo {
  final File file;
  final DateTime lastModifiedDate;
  final String fileName;

  FileInfo(this.file, this.lastModifiedDate, this.fileName);
}

Future<List<FileInfo>> getListOfFiles() async {
  String directory;
  List file = new List();
  directory = (await getExternalStorageDirectory()).path;

  file = Directory("$directory")
      .listSync(); //use your folder name insted of resume.
  List<FileInfo> listFiles = List<FileInfo>();
  await Future.forEach(file, (element) async {
    listFiles.add(new FileInfo(
        element,
        await AppUtil.getLastModifiedDate(element),
        await AppUtil.getFileNameWithExtension(element)));
    listFiles.sort((a, b) =>
        a.lastModifiedDate.compareTo(b.lastModifiedDate));
  });

  listFiles = listFiles.reversed.toList();
  return listFiles;
}
