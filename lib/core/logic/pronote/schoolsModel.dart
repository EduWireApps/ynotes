class PronoteSchool {
  ///School name
  final String name;

  ///Coordinates if geolocated
  ///`long`, `lat`, `distance`
  final List<String> coordinates;

  ///Pronote URL
  final String url;

  final String postalCode;
  PronoteSchool({this.name, this.coordinates, this.url, this.postalCode});
}

class PronoteSpace {
  final String name;
  final String url;

  PronoteSpace({this.name, this.url});
}
