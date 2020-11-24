import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/utils/fileUtils.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/apis/Pronote.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';

import 'classes.dart';

///Class download to notify view when download is ended
class DownloadModel extends ChangeNotifier {
  bool _isDownloading = false;
  double _progress = 0;
  get downloadProgress => _progress;
  get isDownloading => _isDownloading;

  ///Check if file exists
  Future<bool> fileExists(filename) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final dir = await FolderAppUtil.getDirectory(download: true);
        FolderAppUtil.createDirectory("$dir/yNotesDownloads/");
        Directory downloadsDir = Directory("$dir/yNotesDownloads/");
        List<FileSystemEntity> list = downloadsDir.listSync();
        bool toReturn = false;
        await Future.forEach(list, (element) async {
          if (filename == await FileAppUtil.getFileNameWithExtension(element)) {
            toReturn = true;
          }
        });
        return toReturn;
      } else {
        print("Not granted");
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//Download a file in the app directory
  download(Document document) async {
    _isDownloading = true;
    _progress = null;
    String filename = document.libelle;
    notifyListeners();
    Request request = await localApi.downloadRequest(document);
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
        print("Téléchargement du fichier terminé : ${file.path}");
        final dir = await FolderAppUtil.getDirectory(download: true);
        final Directory _appDocDirFolder = Directory('$dir/yNotesDownloads/');

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

enum loginStatus { loggedIn, loggedOff, offline, error }

//the transparent login manager
class TransparentLogin extends ChangeNotifier {
  //Login state
  var _actualState = loginStatus.loggedOff;
  //Login status details
  String _details = "Déconnecté";
  //Error logs
  String _logs = "";
  var internetConnexion;
  //getters
  get actualState => _actualState;
  set actualState(loginStatus) {
    _actualState = loginStatus;
    notifyListeners();
  }

  get details => _details;
  set details(details) {
    _details = details;
    notifyListeners();
  }

  init() async {
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    if (await connectionStatus.checkConnection() == false) {
      _actualState = loginStatus.offline;
      _details = "Vous êtes hors ligne";
      notifyListeners();
    }
    internetConnexion = connectionStatus.connectionChange.listen(connectionChanged);
    if (_actualState != loginStatus.offline && localApi.loggedIn == false) {
      await login();
    } else if (localApi.loggedIn) {
      _details = "Connecté";
      _actualState = loginStatus.loggedIn;
      notifyListeners();
    }
  }

  void connectionChanged(dynamic hasConnection) async {
    if (hasConnection != true) {
      _actualState = loginStatus.offline;
      _details = "Vous êtes hors ligne";
      notifyListeners();
    } else {
      _actualState = loginStatus.loggedOff;
      _details = "Reconnecté";
      notifyListeners();
      await login();
    }
  }

  login() async {
    try {
      _actualState = loginStatus.loggedOff;
      _details = "Connexion à l'API...";
      notifyListeners();
      await getChosenParser();
      String u = await ReadStorage("username");
      String p = await ReadStorage("password");
      String url = await ReadStorage("pronoteurl");
      String cas = await ReadStorage("pronotecas");
      var z = await storage.read(key: "agreedTermsAndConfiguredApp");
      if (u != null && p != null && z != null) {
        await localApi.login(u, p, url: url, cas: cas).then((String value) {
          if (value == null) {
            _actualState = loginStatus.loggedOff;
            _details = "Connexion à l'API...";
            notifyListeners();
          }
          if (value.contains("Bienvenue")) {
            gradeRefreshRecursive = false;
            hwRefreshRecursive = false;
            lessonsRefreshRecursive = false;
            _details = "Connecté";
            _actualState = loginStatus.loggedIn;
            notifyListeners();
          } else {
            print("La valeur est :" + value.toString());
            if (value.contains("IP")) {
              _details = "Ban temporaire IP !";
            } else {
              _details = "Erreur de connexion.";
            }

            _logs = value.toString();
            _actualState = loginStatus.error;
            notifyListeners();
          }
        });
      } else {
        _details = "Déconnecté";
        _actualState = loginStatus.loggedOff;
        notifyListeners();
      }
    } catch (e) {}
  }
}
