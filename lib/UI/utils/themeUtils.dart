import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flushbar/flushbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;
import 'package:tinycolor/tinycolor.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'dart:io';
import 'package:dio/src/response.dart' as dioResponse;

class ThemeUtils {
  static textColor(context) => Theme.of(context).toString();
}

ThemeData darkTheme = ThemeData(
    backgroundColor: Color(0xff313131),
    primaryColor: Color(0xff414141),
    //In reality that is primary ColorLighter
    primaryColorDark: Color(0xff525252),
    indicatorColor: Color(0xff525252),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));

ThemeData lightTheme = ThemeData(
    backgroundColor: Colors.white,
    primaryColor: Color(0xffF3F3F3),
    primaryColorDark: Color(0xffDCDCDC),
    indicatorColor: Color(0xffDCDCDC),
    tabBarTheme: TabBarTheme(labelColor: Colors.black));