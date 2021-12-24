library school_api;

import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/app_colors.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/core_new/api.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes/core_new/offline.dart';

// TODO: document all
// TODO: use getters and private attributes

// COMMON
part 'src/apis.dart';
part 'src/provider.dart';
part 'src/repository.dart';
part 'src/metadata.dart';
part 'src/module.dart';
part 'src/modules_availability.dart';
part 'src/school_api_modules.dart';
part 'src/school_api.dart';

// AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/offline.dart';

// GRADES MODULE
part 'src/modules/grades/module.dart';
part 'src/modules/grades/offline.dart';

// SCHOOL LIFE MDOULE
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/offline.dart';

// EMAILS MODULE
part 'src/modules/emails/module.dart';
part 'src/modules/emails/offline.dart';
part 'src/modules/emails/repository.dart';

// HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/offline.dart';
part 'src/modules/homework/repository.dart';

// DOCUMENTS MODULE
part 'src/modules/documents/module.dart';
part 'src/modules/documents/offline.dart';
part 'src/modules/documents/repository.dart';
