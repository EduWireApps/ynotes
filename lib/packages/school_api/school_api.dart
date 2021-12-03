library school_api;

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/packages/tests.dart';
import 'package:ynotes_packages/theme.dart';
import '../shared/shared.dart';

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

// AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/models/app_account.dart';
part 'src/modules/auth/models/school_account.dart';

// GRADES MODULE
part 'src/modules/grades/module.dart';
part 'src/modules/grades/models/grade.dart';

// SCHOOL LIFE MDOULE
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/models/school_life_sanction.dart';
part 'src/modules/school_life/models/school_life_ticket.dart';

// HIVE GENERATED FILE
part "school_api.g.dart";
