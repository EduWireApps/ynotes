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
