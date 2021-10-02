// TODO: document

class PronoteSchool {
  ///School name
  final String? name;

  ///Coordinates if geolocated
  ///`long`, `lat`, `distance`
  final List<String>? coordinates;

  ///Pronote URL
  final String? url;

  final String? postalCode;

  String get department => postalCode!.substring(0, 2);

  const PronoteSchool({this.name, this.coordinates, this.url, this.postalCode});
}

// TODO: delete
@Deprecated("Will be deleted soon")
class PronoteSpace {
  final String? name;
  final String? url;
  final String? originUrl;

  PronoteSpace({
    this.name,
    this.url,
    this.originUrl,
  });
}
