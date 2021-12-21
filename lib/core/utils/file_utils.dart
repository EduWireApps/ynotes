import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/ui.dart';

///Every action related to files
class FileAppUtil {
  static getCsv(List<Grade> associateGradeList) async {
    //create an element rows of type list of list. All the above data set are stored in associate list
//Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.

    List<List<dynamic>> rows = [];
    for (int i = 0; i < associateGradeList.length; i++) {
      List<dynamic> row = [];

      //row refer to each column of a row in csv file and rows refer to each row in a file
      row.add(associateGradeList[i].value);
      row.add(associateGradeList[i].disciplineName);
      row.add(associateGradeList[i].date);
      row.add(associateGradeList[i].entryDate);
      row.add(associateGradeList[i].countAsZero);
      row.add(associateGradeList[i].periodCode);
      row.add(associateGradeList[i].periodName);
      row.add(associateGradeList[i].testName);

      row.add(associateGradeList[i].hashCode);

      rows.add(row);
    }

//store file in documents folder

    String dir = (await getExternalStorageDirectory())!.absolute.path + "/";
    var file = dir;
    File f = File(file + "filename.csv");

// convert rows to String and write as csv file

    String csv = const ListToCsvConverter().convert(rows);
    f.writeAsString(csv);
  }

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
          CustomLogger.log("FILE UTILS", "An error occured while getting the file list");
          CustomLogger.error(e, stackHint:"Nzk=");
        }
        //use your folder name insted of resume.
        List<FileInfo> listFiles = [];

        await Future.forEach(file, (dynamic element) async {
          try {
            listFiles.add(FileInfo(element, await FileAppUtil.getLastModifiedDate(element),
                await FileAppUtil.getFileNameWithExtension(element)));
          } catch (e) {
            CustomLogger.log("FILE UTILS", "An error occured while adding file to list");
            CustomLogger.error(e, stackHint:"ODA=");
          }
        });

        listFiles = listFiles.reversed.toList();
        return listFiles;
      }
    } catch (e) {
      List<FileInfo> listFiles = [];
      return listFiles;
    }
    UIUtils.setSystemUIOverlayStyle();
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
      CustomLogger.error(e, stackHint:"ODE=");
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
      CustomLogger.log("FILE UTILS", "An error occured while opening file");
      CustomLogger.error(e, stackHint:"ODI=");
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
    CustomLogger.log("FILE UTILS", "Writing file");
    try {
      final directory = await FolderAppUtil.getDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      await file.writeAsString(data, mode: FileMode.write);
    } catch (e) {
      CustomLogger.log("FILE UTILS", "An error occured while writing $fileName²");
      CustomLogger.error(e, stackHint:"ODM=");
    }
  }
}

class FileInfo {
  final dynamic element;
  final DateTime? lastModifiedDate;
  final String? fileName;
  bool selected;
  FileInfo(this.element, this.lastModifiedDate, this.fileName, {this.selected = false});
}

class FolderAppUtil {
  static Future<Directory> createDirectory(String path) async {
    final Directory dir = Directory(path);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
      CustomLogger.log("FILE UTILS", "Created $path folder");
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
        return Directory("${appDirectory.path}/yNotesApp/files");
      }
    }
    throw 'Unsupported on web';
  }

  static Future<Directory> getTempDirectory() async => await getTemporaryDirectory();
}
