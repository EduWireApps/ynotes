import 'dart:async';

import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';

import 'apiManager.dart';

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
  get details => _details;

  init() async {
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    internetConnexion = connectionStatus.connectionChange.listen(connectionChanged);
    if (_actualState != loginStatus.offline && localApi.loggedIn == false) {
      await login();
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
      getChosenParser();
      String u = await ReadStorage("username");
      String p = await ReadStorage("password");
      String url = await ReadStorage("pronoteurl");
      String cas = await ReadStorage("pronotecas");
      var z = await storage.read(key: "agreedTermsAndConfiguredApp");
      if (u != null && p != null && z != null) {
        try {
        
          await localApi.login(u, p, url: url, cas: cas);
          _details = "Connecté";
          _actualState = loginStatus.loggedIn;
          notifyListeners();
        } catch (e) {
          _details = "Erreur de connexion.";
          _logs = e.toString();
          _actualState = loginStatus.error;
          notifyListeners();
        }
      } else {
        _details = "Déconnecté";
        _actualState = loginStatus.loggedOff;
        notifyListeners();
      }
    } catch (e) {
      _details = "Erreur de connexion.";
      _logs = e.toString();
      _actualState = loginStatus.error;
      notifyListeners();
    }
  }
}
