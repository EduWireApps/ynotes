import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:ynotes_packages/theme.dart';

class ListMapConverter extends TypeConverter<List<Map?>?, String?> {
  const ListMapConverter(); // Converters need to have an empty const constructor

  @override
  List<Map?> fromIsar(String? listMap) {
    return jsonDecode(listMap ?? "").cast<Map?>();
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

class YTColorConverter extends TypeConverter<YTColor, String?> {
  const YTColorConverter();

  @override
  YTColor fromIsar(String? stringMap) {
    var map = jsonDecode(stringMap ??"");
    return YTColor(
        backgroundColor: Color(map?["backgroundColor"]),
        foregroundColor: Color(map?["backgroundColor"]),
        lightColor: Color(map?["backgroundColor"]));
  }

  @override
  String toIsar(YTColor? color) {
    return jsonEncode({
      "backgroundColor": color?.backgroundColor.value,
      "foregroundColor": color?.foregroundColor.value,
      "lightColor": color?.lightColor.value
    });
  }
}
