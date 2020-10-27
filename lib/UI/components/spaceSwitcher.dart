import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:flutter/src/scheduler/binding.dart';
import 'package:ynotes/UI/components/modalBottomSheets/utils.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/UI/utils/fileUtils.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/classes.dart';
import 'dart:async';
import 'package:ynotes/UI/components/expandable_bottom_sheet-master/src/raw_expandable_bottom_sheet.dart';
import 'dart:io';

class SpaceSwitcher extends StatefulWidget {
  @override
  _SpaceSwitcherState createState() => _SpaceSwitcherState();
}

class _SpaceSwitcherState extends State<SpaceSwitcher> {
  @override
  Widget build(BuildContext context) {
        MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      height: screenSize.size.height/10*5,
      
    );
  }
}