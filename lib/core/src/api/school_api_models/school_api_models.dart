library models;

// flutter packages pub run build_runner build --delete-conflicting-outputs

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:ynotes/core/api.dart';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/offline.dart';
import 'package:ynotes/core/src/api/school_api/school_api.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:crypto/crypto.dart';
import 'package:crypto/crypto.dart';
import 'package:ynotes/core/extensions.dart';

// ISAR GENERATED FILE
part 'school_api_models.g.dart';

// INTERNAL
part 'src/internal/adapters.dart';
part 'src/internal/linked_model.dart';

// MODELS
part 'src/grade.dart';
part 'src/subject.dart';
part 'src/subjects_filter.dart';
part 'src/period.dart';
part 'src/app_account.dart';
part 'src/document.dart';
part 'src/email.dart';
part 'src/homework.dart';
part 'src/recipient.dart';
part 'src/school_account.dart';
part 'src/school_life_sanction.dart';
part 'src/school_life_ticket.dart';
