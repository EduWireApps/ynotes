library ecole_directe;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:ynotes/packages/school_api/school_api.dart';
import 'package:ynotes/packages/school_api_models/school_api_models.dart';
import 'package:ynotes/packages/shared/shared.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:html/parser.dart' as html_parser;

part 'src/api.dart';
part 'src/utils.dart';
part 'src/modules/grades/module.dart';
part 'src/modules/grades/repository.dart';
part 'src/modules/grades/providers.dart';
part 'src/modules/school_life/module.dart';
part 'src/modules/school_life/repository.dart';
part 'src/modules/school_life/providers.dart';
part 'src/modules/auth/module.dart';
part 'src/modules/auth/repository.dart';
part 'src/modules/auth/providers.dart';
