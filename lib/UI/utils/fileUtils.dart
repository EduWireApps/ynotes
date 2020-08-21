import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/services.dart';

import 'package:open_file/open_file.dart';

import 'package:path/path.dart' as path;

import 'package:path_provider/path_provider.dart';

class FileInfo {
  final element;
  final DateTime lastModifiedDate;
  final String fileName;
  bool selected;
  FileInfo(this.element, this.lastModifiedDate, this.fileName, {this.selected = false});
}

class FolderAppUtil {
  static getDirectory({bool download = false}) async {
    if (download && Platform.isAndroid) {
      final dir = await DownloadsPathProvider.downloadsDirectory;
      return dir;
    }
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      return dir;
    }
    if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      return dir;
    } else {
      ///DO NOTHING
    }
  }

  static createDirectory(String path) async {
    final Directory _appDocDirFolder = Directory(path);

    if (!await _appDocDirFolder.exists()) {
      print("creating $path");
      //if folder already exists return path
      final Directory _appDocDirNewFolder = await _appDocDirFolder.create(recursive: true);
    } else {
      print("$path");
    } //if folder not exists create folder and then return its path
  }
}

///Every action related to files
class FileAppUtil {
  static Future<String> getFileNameWithExtension(var file) async {
    if (await file.exists()) {
      return path.basename(file.path);
    } else {
      return null;
    }
  }

  ///Get new file path
  static Future<File> getFilePath(String filename) async {
    final dir = await FolderAppUtil.getDirectory(download: true);
    return File("${dir.path}/yNotesDownloads/$filename");
  }

  static Future<DateTime> getLastModifiedDate(var item) async {
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

  static remove(var file) async {
    if (await file.exists()) {
      file.delete(recursive:true);
    } else {
      return null;
    }
  }

//Open a file
  static Future<void> openFile(filename) async {
    final dir = await FolderAppUtil.getDirectory(download: true);
    final filePath = '${dir.path}/yNotesDownloads';
    await OpenFile.open(filePath);
  }

  static Future<List<FileInfo>> getFilesList(String path) async {

    try {
      String directory;
      List file = new List();

      directory = (await FolderAppUtil.getDirectory(download: true)).path;

      if (await Permission.storage.request().isGranted) {
        try {
          file = Directory(path).listSync();
        } catch (e) {
          print("HOLA " + e.toString());
        }
        //use your folder name insted of resume.
        List<FileInfo> listFiles = List<FileInfo>();

        await Future.forEach(file, (element) async {
          try {
            listFiles.add(new FileInfo(element, await FileAppUtil.getLastModifiedDate(element),
                await FileAppUtil.getFileNameWithExtension(element)));
          } catch (e) {
            print(e);
          }
        });

        listFiles = listFiles.reversed.toList();
        return listFiles;
      }
    } catch (e) {
      List<FileInfo> listFiles = List<FileInfo>();
      return listFiles;
    }
  }
}
