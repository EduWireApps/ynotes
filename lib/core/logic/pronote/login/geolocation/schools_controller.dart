import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/core/utils/ui.dart';
import 'package:ynotes/ui/screens/login/content/login_text_content.dart';

// TODO: rename files
// TODO: document

enum GeolocationStatus {
  initial,
  loading,
  success,
  error,
}

class GeolocationError {
  final String title;
  final String message;

  const GeolocationError({required this.title, required this.message});
}

class PronoteGeolocationController extends Controller {
  PronoteGeolocationController();

  GeolocationStatus get status => _status;
  GeolocationStatus _status = GeolocationStatus.initial;

  GeolocationError? get error => _error;
  GeolocationError? _error;

  List<PronoteSchool> get schools => _schools;
  List<PronoteSchool> _schools = [];

  void _convertDataToSchool({required String body, required double longitude, required double latitude}) {
    final dynamic decodedBody = jsonDecode(body);
    final List<PronoteSchool> _schools = [];
    for (dynamic school in decodedBody) {
      _schools.add(PronoteSchool(
        name: HtmlUnescape().convert(school["nomEtab"]),
        coordinates: [
          school["lat"].toString(),
          school["long"].toString(),
          Geolocator.distanceBetween(
                  double.tryParse(school["lat"])!, double.tryParse(school["long"])!, latitude, longitude)
              .toString()
        ],
        url: school["url"],
        postalCode: school["cp"].toString(),
      ));
    }
    _schools.sort(
        (a, b) => (double.tryParse(a.coordinates![2]) ?? 0.0).compareTo(double.tryParse(b.coordinates![2]) ?? 0.0));
    setState(() {
      this._schools = _schools;
    });
  }

  Future<void> geolocateSchools() async {
    setState(() {
      _status = GeolocationStatus.loading;
      _error = null;
    });
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = const GeolocationError(
              title: "Permission refusée",
              message:
                  "Vous avez bloqué l'accès à la localisation de façon permanente pour yNotes. Pour accéder à cette fonctionnalité, veuillez la modifier dans les paramètres de votre téléphone.");
          _status = GeolocationStatus.error;
        });
        return;
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        setState(() {
          _error = const GeolocationError(
              title: "Permission refusée",
              message:
                  "Vous avez refusé l'accès à la localisation pour yNotes. Cette fonctionnalité repose sur la localisation, veuillez réessayer et accepter.");
          _status = GeolocationStatus.error;
        });
        return;
      }
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos;
    try {
      pos = await Geolocator.getCurrentPosition();
      CustomLogger.log("PRONOTE", "(Schools) Current position: ${pos.longitude} ${pos.latitude}");
      try {
        await _locateSchoolsAround(longitude: pos.longitude, latitude: pos.latitude);
        setState(() {
          _status = GeolocationStatus.success;
        });
      } catch (e) {
        setState(() {
          _error = GeolocationError(title: "Une erreur est survenue", message: "$e");
        });
      }
    } catch (e) {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.
        setState(() {
          _error = const GeolocationError(
              title: "Oups !",
              message: "La géolocalisation est désactivée, tu en as besoin pour accéder à cette fonctionnalité.");
          _status = GeolocationStatus.error;
        });
      }
    }
    UIUtils.setSystemUIOverlayStyle();
  }

  _locateSchoolsAround({required double longitude, required double latitude}) async {
    const String url = "https://www.index-education.com/swie/geoloc.php";
    const Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final String body = 'data=%7B%22nomFonction%22%3A%22geoLoc%22%2C%22lat%22%3A$latitude%2C%22long%22%3A$longitude%7D';

    dynamic response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });
    if (response.statusCode == 200) {
      _convertDataToSchool(body: response.body, longitude: longitude, latitude: latitude);
    } else {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    }
    CustomLogger.log("PRONOTE", "(Schools) Request response status code: ${response.statusCode}");
  }

  List<PronoteSchool> filteredSchools(String name) {
    if (name.isEmpty) {
      return schools;
    }
    return schools
        .where((school) => school.name!.toUpperCase().contains(name.toUpperCase()) && school.url != null)
        .toList();
  }

  Future<void> reset() async {
    setState(() {
      _status = GeolocationStatus.initial;
      _error = null;
      _schools = [];
    });
    await geolocateSchools();
  }
}

@Deprecated("Use PronoteGeolocationController instead")
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
          if (space["nom"].toUpperCase().contains("ÉLÈVES")) {
            _spaces.add(PronoteSpace(
                name: space["nom"],
                url: school!.url! + (school!.url![school!.url!.length - 1] == "/" ? "" : "/") + space["URL"],
                originUrl: school!.url));
          }
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
