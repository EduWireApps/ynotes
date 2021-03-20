import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class PronoteSchoolsController extends ChangeNotifier {
  bool geolocating = false;
  String error;
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
      error = 'Location services are disabled.';
      geolocating = false;
      notifyListeners();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        error = 'Location permissions are permanently denied, we cannot request permissions.';
        geolocating = false;
        notifyListeners();
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        error = 'Location permissions are denied';
        geolocating = false;
        notifyListeners();
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position pos = await Geolocator.getCurrentPosition();
    print(pos.longitude.toString() + " " + pos.latitude.toString());
    geolocating = false;
    notifyListeners();
  }
}
