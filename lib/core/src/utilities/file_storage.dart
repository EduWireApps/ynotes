import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ynotes/core/utilities.dart';

import 'package:ynotes/packages/shared.dart';

/// The class that handles storage related actions.
class FileStorage {
  const FileStorage._();

  /// Load a project asset (defined in `pubspec.yaml`) as a string.
  static Future<String> loadProjectAsset(String path) async => await rootBundle.loadString(path);

  /// Open a file using native methods.
  static Future<Response<void>> openFile(File file) async {
    try {
      await OpenFile.open(file.path);
      return const Response();
    } catch (e) {
      Logger.error(e, stackHint:"OQ==");
      return Response(error: e.toString());
    }
  }

  /// Get the directory of the app storage.
  static Future<Directory> getAppDirectory({bool downloads = false}) async {
    if (!kIsWeb) {
      final Directory appDirectory = await getApplicationSupportDirectory();
      final Directory documentsDirectory =
          (Platform.isLinux || Platform.isWindows) ? Directory("${appDirectory.path}/yNotesApp/") : appDirectory;
      final Directory downloadsDirectory = Directory("${documentsDirectory.path}/downloads/");
      if (!downloadsDirectory.existsSync()) {
        downloadsDirectory.createSync(recursive: true);
      }
      return downloads ? downloadsDirectory : documentsDirectory;
    }
    throw 'Unsupported on web';
  }
}
