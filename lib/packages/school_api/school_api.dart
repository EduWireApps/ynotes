library school_api;

import 'dart:async';
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:ynotes/core/utils/app_colors.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/kvs.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes/packages/school_api_models/school_api_models.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes/packages/shared/shared.dart';

// TODO: document all

// COMMON
part 'src/provider.dart';
part 'src/repository.dart';
part 'src/metadata.dart';
part 'src/module.dart';
part 'src/modules_availability.dart';
part 'src/school_api_modules.dart';
part 'src/school_api.dart';
part 'src/offline.dart';

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

// HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/offline.dart';
part 'src/modules/homework/repository.dart';

// DOCUMENTS MODULE
part 'src/modules/documents/module.dart';
part 'src/modules/documents/offline.dart';
part 'src/modules/documents/repository.dart';
