import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:tinycolor/tinycolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'dart:io';
import 'package:dio/src/response.dart' as dioResponse;
import 'apiManager.dart';

//L
launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "L'adresse $url n'a pas pu être ouverte";
  }
}

//Parsers list
List parsers = ["EcoleDirecte", "Pronote"];

int chosenParser;

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

///Class download to notify view when download is ended
class DownloadModel extends ChangeNotifier {
  bool _isDownloading = false;
  double _progress = 0;
  get downloadProgress => _progress;
  get isDownloading => _isDownloading;

  ///Check if file exists
  Future<bool> fileExists(filename) async {
    final dir = await getDirectory();
    return File("${dir.path}/downloads/$filename").exists();
  }

//Download a file in the app directory
  download(id, type, filename) async {
    _isDownloading = true;
    _progress = null;
    notifyListeners();
    var url = 'https://api.ecoledirecte.com/v3/telechargement.awp?verbe=get';

    Map<String, String> headers = {"Content-type": "x"};

    String body = "leTypeDeFichier=$type&fichierId=$id&token=$token";
    Request request = Request('POST', Uri.parse(url));
    request.body = body.toString();

    //Make a response client
    final StreamedResponse response = await Client().send(request);
    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();
    print("Downloading a file : $filename");

    List<int> bytes = [];
    final file = await FileAppUtil.getFilePath(filename);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / contentLength;

        notifyListeners();
      },
      onDone: () async {
        _progress = 100;
        notifyListeners();
        print("Téléchargement du fichier terminé : $filename");
        final dir = await getDirectory();
        final Directory _appDocDirFolder = Directory('${dir.path}/downloads/');

        if (!await _appDocDirFolder.exists()) {
          //if folder already exists return path
          final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
        } //if folder not exists create folder and then return its path

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
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: Material(child: child),
      );
    },
  );
}

getDirectory() async {
  if (Platform.isAndroid) {
    final dir = await getExternalStorageDirectory();
    return dir;
  }
  if (Platform.isIOS) {
    final dir = await getApplicationDocumentsDirectory();
    return dir;
  } else {
    ///DO NOTHING
  }
}

//Open a file
Future<void> openFile(filename) async {
  final dir = await getDirectory();
  final filePath = '${dir.path}/downloads/$filename';
  await OpenFile.open(filePath);
}

///Color theme switcher, actually 0 for darkmode and 1 for lightmode
int colorTheme = 0;
String actualUser = "";

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff313131),
    primaryColor: Color(0xff414141),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff525252),
    indicatorColor: Color(0xff525252),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));

ThemeData lightTheme = ThemeData(backgroundColor: Colors.white, primaryColor: Color(0xffF3F3F3), primaryColorDark: Color(0xffDCDCDC), indicatorColor: Color(0xffDCDCDC), tabBarTheme: TabBarTheme(labelColor: Colors.black));

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

Future<int> getIntSetting(String setting) async {
  final prefs = await SharedPreferences.getInstance();
  int value = prefs.getInt(setting);
  if (value == null) {
    value = 0;
    if (setting == "summaryQuickHomework") {
      value = 10;
    }

    setIntSetting(setting, value);
  }
  return value;
}

setIntSetting(String setting, int value) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setInt(setting, value);
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
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

///Every action related to files
class FileAppUtil {
  static Future<String> getFileNameWithExtension(File file) async {
    if (await file.exists()) {
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  ///Get new file path
  static Future<File> getFilePath(String filename) async {
    final dir = await getDirectory();
    return File("${dir.path}/downloads/$filename");
  }

  static Future<DateTime> getLastModifiedDate(File file) async {
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
  try {
    String directory;
    List file = new List();
    directory = (await getDirectory()).path;

    file = Directory("$directory/downloads").listSync(); //use your folder name insted of resume.
    List<FileInfo> listFiles = List<FileInfo>();

    await Future.forEach(file, (element) async {
      try {
        listFiles.add(new FileInfo(element, await FileAppUtil.getLastModifiedDate(element), await FileAppUtil.getFileNameWithExtension(element)));
        listFiles.sort((a, b) => a.lastModifiedDate.compareTo(b.lastModifiedDate));
      } catch (e) {
        print(e);
      }
    });

    listFiles = listFiles.reversed.toList();
    return listFiles;
  } catch (e) {
    List<FileInfo> listFiles = List<FileInfo>();
    return listFiles;
  }
}

//Used in the app page
class App {
  final String name;
  final IconData icon;
  final String route;

  App(this.name, this.icon, {this.route});
}

//Connectivity  classs

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton = new ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = new StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    checkConnection();
  }

  Stream get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }
}

//Get only grades as a list
List<Grade> getAllGrades(List<Discipline> list, {bool overrideLimit = false}) {
  List<Grade> listToReturn = List<Grade>();
  list.forEach((element) {
    listToReturn.addAll(element.gradesList);
  });

  if (chosenParser == 0) {
    listToReturn.sort((a, b) => a.dateSaisie.compareTo(b.dateSaisie));
  }
  listToReturn = listToReturn.reversed.toList();

  if (overrideLimit == false && listToReturn != null) {
    listToReturn = listToReturn.sublist(0, (listToReturn.length >= 5) ? 5 : listToReturn.length);
  }

  return listToReturn;
}

//Redefine the switch statement
TValue case2<TOptionType, TValue>(
  TOptionType selectedOption,
  Map<TOptionType, TValue> branches, [
  TValue defaultValue = null,
]) {
  if (!branches.containsKey(selectedOption)) {
    return defaultValue;
  }

  return branches[selectedOption];
}

List<Discipline> specialities = List<Discipline>();
//Refresh colors
refreshDisciplinesListColors(List<Discipline> list) async {
  list.forEach((f) async {
    f.color = await getColor(f.codeMatiere);
  });
}

//Leave app
exitApp() async {
  try {
    //Delete sharedPref
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    //Import secureStorage
    final storage = new FlutterSecureStorage();
    //Delete all
    await storage.deleteAll();
    isDarkModeEnabled = false;
    //delete hive files
    final dir = await getDirectory();
    Hive.init("${dir.path}/offline");
    var homeworkBox = await Hive.openBox('homework');
    await homeworkBox.clear();
    var gradeBox = await Hive.openBox('grades');
    await gradeBox.clear();
    var done = await Hive.openBox('doneHomework');
    await done.clear();
    var pinned = await Hive.openBox('pinnedHomework');
    await pinned.clear();
  } catch (e) {
    print(e);
  }
}

logFile(String error) async {
  final directory = await getDirectory();
  final File file = File('${directory.path}/logs.txt');
  await file.writeAsString("\n\n" + DateTime.now().toString() + "\n" + error, mode: FileMode.append);
}

specialtiesSelectionAvailable() async {
  await getChosenParser();
  return  [false];
  if (chosenParser == 0) {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String classe = await storage.read(key: "classe") ?? "";

//E.G : It is always something like "Première blabla"
    var split = classe.split(" ");

    if (split[0] == "PremiÃ¨re" || split[0] == "Terminale") {
      return [true, (split[0] == "PremiÃ¨re") ? "Première" : split[0]];
    } else {
      return [false];
    }
  } else {
    return  [false];
    /*SharedPreferences preferences = await SharedPreferences.getInstance();
    String classe = await storage.read(key: "classe");
    if (classe != null) {
      if (classe.toLowerCase().contains("1e") || classe.toLowerCase().contains("terminale")) {
        if (classe.toLowerCase().contains("1e")) {
          classe = "Premiere";
        }
        if (classe.toLowerCase().contains("terminale")) {
          classe = "Terminale";
        }
        return [true, classe];
      } else {
        return [false];
      }
    } else {
      return [false];
    }*/
  }
}

class AppNews {
  static Future<List> checkAppNews() async {
    try {
      dioResponse.Response response = await dio.Dio().get("https://ynotes.fr/src/app-src/news.json", options: dio.Options(responseType: dio.ResponseType.plain));

      Map map = json.decode(response.data.toString());
      List list = map["tickets"];
      list.sort((a, b) => a["ticketnb"].compareTo(b["ticketnb"]));
      return list.reversed.toList();
    } catch (e) {
      print(e);
      return null;
    }
  }
}

String cloudUsedFolder = "";
ReadStorage(_key) async {
  String u = await storage.read(key: _key);
  return u;
}
