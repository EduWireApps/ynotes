library pronote_controllers;

import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:html_unescape/html_unescape.dart';
import 'package:http/http.dart';
import 'package:latlong2/latlong.dart';
import 'package:convert/convert.dart' as conv;
import 'package:crypto/crypto.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:uuid/uuid.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/core/src/api/apis/pronote/pronote.dart';
import 'package:ynotes/packages/pronote_client.dart';

import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/src/api/apis/pronote/pronote.dart';

part 'src/pronote/geolocation/geolocation_controller.dart';
part 'src/pronote/geolocation/school_model.dart';
part 'src/pronote/qr_code/qr_login_controller.dart';
