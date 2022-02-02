library ecole_directe;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:html_character_entities/html_character_entities.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:ynotes_packages/theme.dart';

part 'src/api.dart';
part 'src/utils.dart';

// GRADES MODULE
part 'src/modules/grades/module.dart';
part 'src/modules/grades/repository.dart';
part 'src/modules/grades/provider.dart';

// SCHOOL LIFE MODULE
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/repository.dart';
part 'src/modules/school_life/provider.dart';

// AUTH MODULE
part 'src/modules/auth/module.dart';
part 'src/modules/auth/repository.dart';
part 'src/modules/auth/providers.dart';

// EMAILS MODULE
part 'src/modules/emails/module.dart';
part 'src/modules/emails/repository.dart';
part 'src/modules/emails/provider.dart';

// HOMEWORK MODULE
part 'src/modules/homework/module.dart';
part 'src/modules/homework/repository.dart';
part 'src/modules/homework/provider.dart';

// DOCUMENTS MODULE
part 'src/modules/documents/module.dart';
part 'src/modules/documents/repository.dart';
part 'src/modules/documents/provider.dart';
