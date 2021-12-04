library school_api;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/packages/school_api_models/school_api_models.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes/packages/shared/shared.dart';

// TODO: document all

// TODO: refactor like in tests/ecole_directe

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