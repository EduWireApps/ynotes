part of pronote_controllers;

/// The status of the geolocation
enum GeolocationStatus {
  initial,
  loading,
  success,
  error,
}

/// The error thrown when the geolocation fails
class GeolocationError {
  /// The title of the error
  final String title;

  /// The message of the error
  final String message;

  /// The error thrown when the geolocation fails
  const GeolocationError({required this.title, required this.message});
}

/// A class that handles the geolocation method for Pronote login.
class PronoteGeolocationController extends ChangeNotifier {
  /// A class that handles the geolocation method for Pronote login.
  PronoteGeolocationController();

  /// The geolocation status.
  GeolocationStatus get status => _status;
  GeolocationStatus _status = GeolocationStatus.initial;

  /// The geolocation error if there is some.
  GeolocationError? get error => _error;
  GeolocationError? _error;

  /// The schools found around the user's location.
  List<PronoteSchool> get schools => _schools;
  List<PronoteSchool> _schools = [];

  /// The selected coordinates.
  LatLng? get coordinates => _coordinates;
  LatLng? _coordinates;

  void updateCoordinates(LatLng? coordinates) {
    _coordinates = coordinates;
    notifyListeners();
  }

  /// Convert the data received from the Pronote API to a list of [PronoteSchool].
  void _convertDataToSchool({required String body, required double longitude, required double latitude}) {
    // The body is decoded
    final dynamic decodedBody = jsonDecode(body);
    final List<PronoteSchool> _schools = [];
    for (dynamic school in decodedBody) {
      // The school is created
      String schoolUrl = school['url'];
      if (schoolUrl.endsWith("/")) {
        schoolUrl = schoolUrl.substring(0, schoolUrl.length - 1);
      }
      _schools.add(PronoteSchool(
        name: HtmlUnescape().convert(school["nomEtab"]),
        coordinates: [
          school["lat"].toString(),
          school["long"].toString(),
          Geolocator.distanceBetween(
                  double.tryParse(school["lat"])!, double.tryParse(school["long"])!, latitude, longitude)
              .toString()
        ],
        url: schoolUrl,
        postalCode: school["cp"].toString(),
      ));
    }
    // Schools are sorted by distance
    _schools.sort(
        (a, b) => (double.tryParse(a.coordinates![2]) ?? 0.0).compareTo(double.tryParse(b.coordinates![2]) ?? 0.0));
    // We set the class' schools
    this._schools = _schools;
    notifyListeners();
  }

  /// Get the schools around the user's location or not depending on the permissions.
  Future<void> geolocateSchools() async {
    // We initialize the variables
    _status = GeolocationStatus.loading;
    _error = null;
    notifyListeners();
    LocationPermission permission;

    // We check if the user has granted the permission. Based on the result,
    // we ask again or show an error.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        _error = const GeolocationError(
            title: "Permission refusée",
            message:
                "Vous avez bloqué l'accès à la localisation de façon permanente pour yNotes. Pour accéder à cette fonctionnalité, veuillez la modifier dans les paramètres de votre téléphone.");
        _status = GeolocationStatus.error;
        notifyListeners();
        return;
      }

      if (permission == LocationPermission.denied) {
        _error = const GeolocationError(
            title: "Permission refusée",
            message:
                "Vous avez refusé l'accès à la localisation pour yNotes. Cette fonctionnalité repose sur la localisation, veuillez réessayer et accepter.");
        _status = GeolocationStatus.error;
        notifyListeners();
        return;
      }
    }
    // Permissions are granted but the geolocation may not be activitated yet.
    Position pos;
    try {
      // We get the position. If the geolocation is not activated, a native dialog will be shown.
      // If the user declines, it throws an error and executes the catch block.
      pos = await Geolocator.getCurrentPosition();
      Logger.log("PRONOTE", "Current position: ${pos.longitude} ${pos.latitude}");
      try {
        // await _locateSchoolsAround(longitude: pos.longitude, latitude: pos.latitude);
        _status = GeolocationStatus.success;
        notifyListeners();
        updateCoordinates(LatLng(pos.latitude, pos.longitude));
      } catch (e) {
        _error = GeolocationError(title: "Une erreur est survenue", message: "$e");
        notifyListeners();
      }
    } catch (e) {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _error = const GeolocationError(
            title: "Oups !",
            message: "La géolocalisation est désactivée, tu en as besoin pour accéder à cette fonctionnalité.");
        _status = GeolocationStatus.error;
        notifyListeners();
      }
    }
    // Set the system ui because the native dialog modifies it
    UIU.setSystemUIOverlayStyle();
  }

  /// Get the schools around the user's location.
  Future<void> locateSchoolsAround() async {
    _status = GeolocationStatus.loading;
    notifyListeners();
    final LatLng coordinates = this.coordinates!;
    // We setup the url and request body
    const String url = "https://www.index-education.com/swie/geoloc.php";
    const Map<String, String> headers = {"Content-Type": "application/x-www-form-urlencoded"};
    final String body =
        'data=%7B%22nomFonction%22%3A%22geoLoc%22%2C%22lat%22%3A${coordinates.latitude}%2C%22long%22%3A${coordinates.longitude}%7D';

    // We send a request
    final Response response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
      throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
    });
    if (response.statusCode == 200) {
      // If request has completed successfully, we convert the data to a list of [PronoteSchool]
      _convertDataToSchool(body: response.body, longitude: coordinates.longitude, latitude: coordinates.latitude);
      _status = GeolocationStatus.success;
      notifyListeners();
    } else {
      _error = const GeolocationError(
          title: "Oups !",
          message:
              "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
      _status = GeolocationStatus.error;
      notifyListeners();
    }
    Logger.log("PRONOTE", "(Schools) Request response status code: ${response.statusCode}");
  }

  /// The schools filtered by name. Used for the search bar.
  List<PronoteSchool> filteredSchools(String name) {
    if (name.isEmpty) {
      return schools;
    }
    return schools
        .where((school) => school.name!.toUpperCase().contains(name.toUpperCase()) && school.url != null)
        .toList();
  }

  /// Get the availables spaces related to students for a given school
  Future<List<PronoteSchoolSpace>?> getSchoolSpaces(PronoteSchool school) async {
    try {
      if (school.url != null) {
        final String url = ApisUtilities.getPronoteInfoUrl(school.url!);
        dynamic response = await http.get(Uri.parse(url)).catchError((e) {
          throw "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.";
        });
        final List<PronoteSchoolSpace> spaces = [];
        dynamic data = json.decode(response.body);
        for (var space in data["espaces"]) {
          Logger.log("PRONOTE", "(Schools) Space name: ${space["nom"].toUpperCase()}");
          if (space["nom"].toUpperCase().contains("ÉLÈVES")) {
            spaces.add(PronoteSchoolSpace(
                name: space["nom"], spaceUrl: "${school.url!}/${space["URL"]}", schoolUrl: school.url!));
          }
        }
        return spaces;
      }
    } catch (e) {
      _error = GeolocationError(title: "Une erreur est survenue", message: "$e");
      notifyListeners();
      return null;
    }
  }

  /// Retrieves locations near a location as [String] from the Open Street Map api
  Future<List<OSMLocation>> locateNearPlaces(String location) async {
    _status = GeolocationStatus.loading;
    notifyListeners();
    final String url = Uri.encodeFull("https://nominatim.openstreetmap.org/search.php?q=$location&format=json");
    final Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _status = GeolocationStatus.success;
      notifyListeners();
      final List<dynamic> results = jsonDecode(response.body);
      final List<OSMLocation> locations = results
          .map((result) => OSMLocation(
              coordinates: LatLng(double.parse(result["lat"]), double.parse(result["lon"])),
              name: result["display_name"]))
          .toList();
      return locations;
    } else {
      _error = const GeolocationError(
          title: "Oups !",
          message:
              "Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
      _status = GeolocationStatus.error;
      notifyListeners();
      return [];
    }
  }

  /// Reset the controller
  void reset() {
    _status = GeolocationStatus.initial;
    _error = null;
    _schools = [];
    notifyListeners();
  }
}
