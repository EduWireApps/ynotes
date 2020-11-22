import 'package:flutter/material.dart';

class OfflineConfig {
  ///Name of stored data
  final String name;

  ///Runtime type
  final Type type;

  ///Wrapping class (List or Map)
  final Type wrappingType;

  ///Saved as
  final Type storedType;

  ///Change if updating clean old data
  final List<dynamic> adapters;

  ///Change if updating clean old data
  final bool keepOldData;

  //Getter, if null returns all data
  final dynamic getter;

  OfflineConfig({
    @required this.name,
    @required this.type,
    this.wrappingType,
    this.storedType,
    this.adapters,
    @required this.keepOldData,
    this.getter,
  });
}
