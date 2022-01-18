import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/legacy/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utilities.dart';

@Deprecated("Use [FileStorage] instead.")

///Every action related to files
class FileAppUtil {
  static Future<String?> getFileNameWithExtension(var file) async {
    if (await file.exists()) {
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  ///Get new file path
  static Future<File> getFilePath(String? filename) async {
    final Directory dir = await FolderAppUtil.getDirectory(downloads: true);
    return File("${dir.path}/$filename");
  }

  static Future<List<FileInfo>> getFilesList(String path) async {
    try {
      List file = [];

      if (!kIsWeb && (Platform.isLinux || Platform.isWindows || await Permission.storage.request().isGranted)) {
        try {
          file = Directory(path).listSync();
        } catch (e) {
          Logger.log("FILE UTILS", "An error occured while getting the file list");
          Logger.error(e, stackHint: "MjU=");
        }
        //use your folder name insted of resume.
        List<FileInfo> listFiles = [];

        await Future.forEach(file, (dynamic element) async {
          try {
            listFiles.add(FileInfo(element, await FileAppUtil.getLastModifiedDate(element),
                await FileAppUtil.getFileNameWithExtension(element)));
          } catch (e) {
            Logger.log("FILE UTILS", "An error occured while adding file to list");
            Logger.error(e, stackHint: "MjY=");
          }
        });

        listFiles = listFiles.reversed.toList();
        return listFiles;
      }
    } catch (e) {
      List<FileInfo> listFiles = [];
      return listFiles;
    }
    UIU.setSystemUIOverlayStyle();
    return [];
  }

  static Future<DateTime?> getLastModifiedDate(var item) async {
    try {
      if (await item.exists()) {
        return await item.lastModified();
      } else {
        return null;
      }
    } catch (e) {
      Logger.error(e, stackHint: "Mjc=");
    }
  }

  static Future<String> loadAsset(path) async {
    return await rootBundle.loadString(path);
  }

  static Future<void> openFile(String? filePath, {bool usingFileName = false}) async {
    try {
      String? path = "";

      //Get root dir path
      if (usingFileName) {
        final Directory dir = await FolderAppUtil.getDirectory(downloads: true);
        path = '${dir.path}/$filePath';
      } else {
        path = filePath;
      }

      await OpenFile.open(path!);
    } catch (e) {
      Logger.log("FILE UTILS", "An error occured while opening file");
      Logger.error(e, stackHint: "Mjg=");
    }
  }

//Open a file
  static remove(var file) async {
    if (await file.exists()) {
      file.delete(recursive: true);
    } else {
      return null;
    }
  }

  static writeInFile(String data, String fileName) async {
    Logger.log("FILE UTILS", "Writing file");
    try {
      final directory = await FolderAppUtil.getDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      await file.writeAsString(data, mode: FileMode.write);
    } catch (e) {
      Logger.log("FILE UTILS", "An error occured while writing $fileName²");
      Logger.error(e, stackHint: "Mjk=");
    }
  }
}

@Deprecated("Will be deleted in a future release.")
class FileInfo {
  final dynamic element;
  final DateTime? lastModifiedDate;
  final String? fileName;
  bool selected;
  FileInfo(this.element, this.lastModifiedDate, this.fileName, {this.selected = false});
}

@Deprecated("Use [FileStorage] instead.")
class FolderAppUtil {
  static Future<Directory> createDirectory(String path) async {
    final Directory dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      Logger.log("FILE UTILS", "Created $path folder");
    }
    return dir;
  }

  /// Returns the directory of the app
  ///
  /// On Android, if [downloads] is set to `true`, it will return the downloads directory
  static Future<Directory> getDirectory({bool downloads = false}) async {
    if (!kIsWeb) {
      if (Platform.isAndroid) {
        if (downloads) {
          if ((await (Directory(((await getExternalStorageDirectory())?.path ?? "") + "/downloads")).exists()) ==
              false) {
            await Directory(((await getExternalStorageDirectory())?.path ?? "") + "/downloads").create(recursive: true);
          }
        }

        return downloads
            ? Directory(((await getExternalStorageDirectory())?.path ?? "") + "/downloads")
            : (await getExternalStorageDirectory())!;
      } else if (Platform.isIOS) {
        return await getApplicationDocumentsDirectory();
      } else if (Platform.isLinux || Platform.isWindows) {
        final Directory appDirectory = await getApplicationDocumentsDirectory();
        final Directory dir = Directory("${appDirectory.path}/yNotesApp/files/${downloads ? "downloads" : ""}");
        if (!dir.existsSync()) {
          await dir.create(recursive: true);
        }
        return dir;
      }
    }
    throw 'Unsupported on web';
  }

  static Future<Directory> getTempDirectory() async => await getTemporaryDirectory();
}
