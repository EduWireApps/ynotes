part of models;

class ListMapConverter extends TypeConverter<List<Map?>?, String?> {
  const ListMapConverter(); // Converters need to have an empty const constructor

  @override
  List<Map?> fromIsar(String? object) {
    return jsonDecode(object ?? "").cast<Map?>();
  }

  @override
  String toIsar(List<Map?>? object) {
    return jsonEncode(object);
  }
}

class MapConverter extends TypeConverter<Map?, String?> {
  const MapConverter(); // Converters need to have an empty const constructor

  @override
  Map fromIsar(String? object) {
    return jsonDecode(object ?? "");
  }

  @override
  String toIsar(Map? object) {
    return jsonEncode(object);
  }
}

class YTColorConverter extends TypeConverter<YTColor, String?> {
  const YTColorConverter();

  @override
  YTColor fromIsar(String? object) {
    var map = jsonDecode(object ?? "");
    return YTColor(
        backgroundColor: Color(map?["backgroundColor"]),
        foregroundColor: Color(map?["foregroundColor"]),
        lightColor: Color(map?["lightColor"]));
  }

  @override
  String toIsar(YTColor? object) {
    return jsonEncode({
      "backgroundColor": object?.backgroundColor.value,
      "foregroundColor": object?.foregroundColor.value,
      "lightColor": object?.lightColor.value
    });
  }
}
