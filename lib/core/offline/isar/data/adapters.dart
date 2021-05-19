import 'dart:convert';

import 'package:isar/isar.dart';

class ListMapConverter extends TypeConverter<List<Map?>?, String?> {
  const ListMapConverter(); // Converters need to have an empty const constructor

  @override
  List<Map?> fromIsar(String? listMap) {
    return jsonDecode(listMap ?? "");
  }

  @override
  String toIsar(List<Map?>? map) {
    return jsonEncode(map);
  }
}

class MapConverter extends TypeConverter<Map?, String?> {
  const MapConverter(); // Converters need to have an empty const constructor

  @override
  Map fromIsar(String? mapValue) {
    return jsonDecode(mapValue ?? "");
  }

  @override
  String toIsar(Map? map) {
    return jsonEncode(map);
  }
}
