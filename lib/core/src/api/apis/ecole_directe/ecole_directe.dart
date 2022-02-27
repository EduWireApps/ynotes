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

part 'src/modules/auth.dart';
part 'src/modules/documents.dart';
part 'src/modules/emails.dart';
part 'src/modules/grades.dart';
part 'src/modules/homework.dart';
part 'src/modules/school_life.dart';
