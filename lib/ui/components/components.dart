library components;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_version/new_version.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/api.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/settings.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// BUTTONS
part 'src/buttons/buttons.dart';
part 'src/buttons/legal_link_button.dart';

// DIALOGS
part 'src/dialogs/about_dialog.dart';
part 'src/dialogs/dialogs.dart';
part 'src/dialogs/legal_links_dialog.dart';
part 'src/dialogs/report_loader_dialog.dart';
part 'src/dialogs/color_picker_dialog.dart';

// NAVIGATION
part 'src/navigation/app.dart';
part 'src/navigation/connection_status.dart';
part 'src/navigation/drawer.dart';

// MISC
part 'src/misc/theme_switcher_tile.dart';
part 'src/misc/subjects_filter_manager.dart';
part 'src/misc/account_switcher_tile.dart';

// SHEETS
part 'src/sheets/sheets.dart';
part 'src/sheets/add_subject_filter_sheet.dart';
part 'src/sheets/edit_subject_filter_sheet.dart';
