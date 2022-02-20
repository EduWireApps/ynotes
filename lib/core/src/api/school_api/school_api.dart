library school_api;

// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes/core/offline.dart';

part 'school_api.g.dart';

// TODO: document all

// COMMON
part 'src/apis.dart';
part 'src/provider.dart';
part 'src/repository.dart';
part 'src/metadata.dart';
part 'src/module.dart';
part 'src/modules_availability.dart';
part 'src/modules_support.dart';
part 'src/school_api_modules.dart';
part 'src/school_api.dart';
part 'src/storage.dart';

// AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/repository.dart';

// GRADES MODULE
part 'src/modules/grades/module.dart';

// SCHOOL LIFE MDOULE
part 'src/modules/school_life/module.dart';

// EMAILS MODULE
part 'src/modules/emails/module.dart';
part 'src/modules/emails/repository.dart';

// HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/repository.dart';

// DOCUMENTS MODULE
part 'src/modules/documents/module.dart';
part 'src/modules/documents/repository.dart';
