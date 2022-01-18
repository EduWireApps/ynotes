part of pronote_controllers;

/// A Pronote school provided by the Pronote geolocation API.
class PronoteSchool {
  /// The school name
  final String? name;

  ///Coordinates if geolocated: `long`, `lat`, `distance`
  final List<String>? coordinates;

  /// The school url
  final String? url;

  /// The full postal code
  final String? postalCode;

  /// The department code
  String get departmentCode => postalCode!.substring(0, 2);

  /// A Pronote school provided by the Pronote geolocation API.
  const PronoteSchool({this.name, this.coordinates, this.url, this.postalCode});
}

/// A Pronote school space provided by the Pronote geolocation API.
class PronoteSchoolSpace {
  /// The space name
  final String name;

  /// The school url
  final String schoolUrl;

  /// The full space url
  final String spaceUrl;

  /// A Pronote school space provided by the Pronote geolocation API.
  const PronoteSchoolSpace({
    required this.name,
    required this.schoolUrl,
    required this.spaceUrl,
  });
}

/// A model for an Open Street Map location
class OSMLocation {
  /// The coordinates of the location
  final LatLng coordinates;

  /// The name of the location
  final String name;

  /// A model for an Open Street Map location
  const OSMLocation({required this.coordinates, required this.name});
}
