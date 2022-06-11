library app;

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:ynotes/core/src/api/apis/pronote/pronote.dart';
import 'package:ynotes/core/utilities.dart';

import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/ui/screens/error/error.dart';
import 'package:ynotes/ui/screens/grades/routes.dart';
import 'package:ynotes/ui/screens/home/routes.dart';
import 'package:ynotes/ui/screens/intro/routes.dart';
import 'package:ynotes/ui/screens/loading/loading.dart';
import 'package:ynotes/ui/screens/login/routes.dart';
import 'package:ynotes/ui/screens/settings/routes.dart';
import 'package:ynotes/ui/screens/terms/terms.dart';
import 'package:ynotes/ui/themes/themes.dart';
import 'package:ynotes/ui/themes/utils/fonts.dart';
import 'package:ynotes_packages/config.dart';
import 'package:ynotes_packages/theme.dart';

part 'src/app.dart';
part 'src/migrations.dart';
part 'src/config.dart';
part 'src/school_api.dart';
part 'src/router.dart';
