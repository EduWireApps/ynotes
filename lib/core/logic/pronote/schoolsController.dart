import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ynotes/core/apis/Pronote/PronoteCas.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class PronoteSchoolsController extends ChangeNotifier {
  bool geolocating = false;
  PronoteSchool school;
  String error;
  List<PronoteSchool> schools;
  List<PronoteSpace> spaces;
  set chosenSchool(PronoteSchool _school) {
    school = _school;
    notifyListeners();
  }

  get getChosenSchool => school;
  reset() async {
    geolocating = false;
    school = null;
    error = null;
    schools = null;
    spaces = null;
    notifyListeners();
    await geolocateSchools();
  }

  getSpaces() async {
    try {
      if (school != null && school.url != null) {
        String url;

        //Weird address to get metas
        url = school.url +
            (school.url[school.url.length - 1] == "/" ? "" : "/") +
            "InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4";
        var response = await http.get(url).catchError((e) {
          return "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
        });
        if (response.body != null) {
          List<PronoteSpace> _spaces = List();
          var data = json.decode(response.body);
          data["espaces"].forEach((space) {
            print(space["nom"].toUpperCase());
            if (space["nom"].toUpperCase().contains("ÉLÈVES"))
              _spaces.add(PronoteSpace(
                  name: space["nom"],
                  url: school.url + (school.url[school.url.length - 1] == "/" ? "" : "/") + space["URL"]));
          });
          spaces = _spaces;
          notifyListeners();
        } else {
          throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
        }
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  //Request to pronote to get schools around
  schoolRequest(double long, double lat) async {
    String url = "https://www.index-education.com/swie/geoloc.php";
    Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};

    var body = 'data=%7B%22nomFonction%22%3A%22geoLoc%22%2C%22lat%22%3A$lat%2C%22long%22%3A$long%7D';
    var response = await http.post(url, headers: headers, body: body).catchError((e) {
      return "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });
    if (response.statusCode == 200) {
      convertToSchool(response.body, long, lat);
    } else {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    }
    print(response.statusCode);
  }

  convertToSchool(String body, double long, double lat) {
    var decodedData = json.decode(body);
    List<PronoteSchool> _schools = List();
    decodedData.forEach((rawData) {
      _schools.add(PronoteSchool(
          name: rawData["nomEtab"],
          coordinates: [
            rawData["lat"].toString(),
            rawData["long"].toString(),
            Geolocator.distanceBetween(double.tryParse(rawData["lat"]), double.tryParse(rawData["long"]), lat, long)
                .toString()
          ],
          url: rawData["url"],
          postalCode: rawData["cp"].toString()));
    });
    schools = _schools;
  }

  //Locating schools around
  geolocateSchools() async {
    geolocating = true;
    error = null;
    notifyListeners();
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      error = 'Les services de géolocalisation sont desactivés.';
      geolocating = false;
      notifyListeners();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        error =
            "L'accès aux services de géolocalisation est refusé de manière permanente : vous devez la réactiver depuis les paramètres.";
        geolocating = false;
        notifyListeners();
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        error = "L'accès aux services de géolocalisation est refusé.";
        geolocating = false;
        notifyListeners();
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();
    print(pos.longitude.toString() + " " + pos.latitude.toString());
    try {
      await schoolRequest(pos.longitude, pos.latitude);
    } catch (e) {
      error = e.toString();
    }
    geolocating = false;
    notifyListeners();
  }
}
