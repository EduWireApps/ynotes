library pronote;

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';


import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/extensions.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/packages/shared.dart';
import 'package:ynotes_packages/theme.dart';

part 'src/api.dart';
part 'src/client/communication.dart';
part 'src/client/encryption.dart';
part 'src/client.dart';
part 'src/utils.dart';


part 'src/modules/auth.dart';
part 'src/modules/documents.dart';
part 'src/modules/emails.dart';
part 'src/modules/grades.dart';
part 'src/modules/homework.dart';
part 'src/modules/school_life.dart';
