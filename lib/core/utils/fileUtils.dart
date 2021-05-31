import 'dart:async';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

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
    var file = "$dir";
    File f = new File(file + "filename.csv");

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
    final dir = await FolderAppUtil.getDirectory(download: true);
    return File("$dir/yNotesDownloads/$filename");
  }

  static Future<List<FileInfo>> getFilesList(String path) async {
    try {
      List file = [];

      if (await Permission.storage.request().isGranted) {
        try {
          file = Directory(path).listSync();
        } catch (e) {
          print("Error while getting file list " + e.toString());
        }
        //use your folder name insted of resume.
        List<FileInfo> listFiles = [];

        await Future.forEach(file, (dynamic element) async {
          try {
            listFiles.add(new FileInfo(
                element,
                await FileAppUtil.getLastModifiedDate(element),
                await FileAppUtil.getFileNameWithExtension(element)));
          } catch (e) {
            print(e);
          }
        });

        listFiles = listFiles.reversed.toList();
        return listFiles;
      }
    } catch (e) {
      List<FileInfo> listFiles = [];
      return listFiles;
    }
    return [];
  }

  static Future<DateTime?> getLastModifiedDate(var item) async {
    try {
      if (await item.exists()) {
        return await item.lastModified();
      } else {
        return null;
      }
    } catch (e) {}
  }

  static Future<String> loadAsset(path) async {
    return await rootBundle.loadString(path);
  }

  static Future<void> openFile(String? filePath,
      {bool usingFileName = false}) async {
    try {
      String? path = "";

      //Get root dir path
      if (usingFileName) {
        final dir = await FolderAppUtil.getDirectory(download: true);
        path = '$dir/yNotesDownloads/$filePath';
      } else {
        path = filePath;
      }

      await OpenFile.open(path!);
    } catch (e) {
      print("Failed to open file : " + e.toString());
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
    print("Writing");
    try {
      final directory = await FolderAppUtil.getDirectory();
      final File file = File('${directory.path}/$fileName.txt');
      await file.writeAsString(data, mode: FileMode.write);
    } catch (e) {
      print(e.toString());
    }
  }
}

class FileInfo {
  final element;
  final DateTime? lastModifiedDate;
  final String? fileName;
  bool selected;
  FileInfo(this.element, this.lastModifiedDate, this.fileName,
      {this.selected = false});
}

class FolderAppUtil {
  static createDirectory(String path) async {
    final Directory _appDocDirFolder = Directory(path);

    if (!await _appDocDirFolder.exists()) {
      print("creating $path");
    }
  }

  static getDirectory({bool download = false}) async {
    if (download && Platform.isAndroid) {
      final dir = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);

      return dir;
    }
    if (Platform.isAndroid) {
      var dir = await getExternalStorageDirectory();

      return download ? dir!.path : dir;
    }
    if (Platform.isIOS) {
      var dir = await getApplicationDocumentsDirectory();
      return download ? dir.path : dir;
    } else {
      ///DO NOTHING
    }
  }

  static getTempDirectory() async {
    final dir = await getTemporaryDirectory();
    return dir;
  }
}
