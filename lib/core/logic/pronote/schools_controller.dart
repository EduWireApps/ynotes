import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';

class PronoteSchoolsController extends ChangeNotifier {
  bool geolocating = false;
  PronoteSchool? school;
  String? error;
  List<PronoteSchool>? schools;
  List<PronoteSpace>? spaces;

  set chosenSchool(PronoteSchool? _school) {
    school = _school;
    notifyListeners();
  }

  get getChosenSchool => school;
  convertToSchool(String body, double long, double lat) {
    var decodedData = json.decode(body);
    List<PronoteSchool> _schools = [];
    decodedData.forEach((rawData) {
      _schools.add(PronoteSchool(
          name: rawData["nomEtab"],
          coordinates: [
            rawData["lat"].toString(),
            rawData["long"].toString(),
            Geolocator.distanceBetween(double.tryParse(rawData["lat"])!, double.tryParse(rawData["long"])!, lat, long)
                .toString()
          ],
          url: rawData["url"],
          postalCode: rawData["cp"].toString()));
    });
    //sort schools by distance
    _schools.sort(
        (a, b) => (double.tryParse(a.coordinates![2]) ?? 0.0).compareTo(double.tryParse(b.coordinates![2]) ?? 0.0));
    schools = _schools;
  }

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
      error = LoginPageTextContent.pronote.geolocation.geolocationDisabled;
      geolocating = false;
      notifyListeners();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        error = LoginPageTextContent.pronote.geolocation.geolocationPermissionRefused;
        geolocating = false;
        notifyListeners();
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        error = LoginPageTextContent.pronote.geolocation.geolocationPermissionPermanentlyRefused;
        geolocating = false;
        notifyListeners();
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();
    CustomLogger.log("PRONOTE", "(Schools) Current position: ${pos.longitude} ${pos.latitude}");
    try {
      await schoolRequest(pos.longitude, pos.latitude);
    } catch (e) {
      error = e.toString();
    }
    geolocating = false;
    notifyListeners();
  }

  //Request to pronote to get schools around
  getSpaces() async {
    try {
      if (school != null && school!.url != null) {
        String url;

        //Weird address to get metas
        url = school!.url! +
            (school!.url![school!.url!.length - 1] == "/" ? "" : "/") +
            "InfoMobileApp.json?id=0D264427-EEFC-4810-A9E9-346942A862A4";
        var response = await http.get(Uri.parse(url)).catchError((e) {
          throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
        });
        List<PronoteSpace> _spaces = [];
        var data = json.decode(response.body);
        data["espaces"].forEach((space) {
          CustomLogger.log("PRONOTE", "(Schools) Space name: ${space["nom"].toUpperCase()}");
          if (space["nom"].toUpperCase().contains("ÉLÈVES"))
            _spaces.add(PronoteSpace(
                name: space["nom"],
                url: school!.url! + (school!.url![school!.url!.length - 1] == "/" ? "" : "/") + space["URL"],
                originUrl: school!.url));
        });
        spaces = _spaces;
        notifyListeners();
      }
    } catch (e) {
      error = e.toString();
      notifyListeners();
    }
  }

  reset() async {
    geolocating = false;
    school = null;
    error = null;
    schools = null;
    spaces = null;
    notifyListeners();
    await geolocateSchools();
  }

  //Locating schools around
  schoolRequest(double long, double lat) async {
    String url = "https://www.index-education.com/swie/geoloc.php";
    Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};

    var body = 'data=%7B%22nomFonction%22%3A%22geoLoc%22%2C%22lat%22%3A$lat%2C%22long%22%3A$long%7D';
    var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });
    if (response.statusCode == 200) {
      convertToSchool(response.body, long, lat);
    } else {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    }
    CustomLogger.log("PRONOTE", "(Schools) Request response status code: ${response.statusCode}");
  }
}
