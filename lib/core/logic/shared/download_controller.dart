import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/globals.dart';

///Class download to notify view when download is ended
class DownloadController extends ChangeNotifier {
  bool _isDownloading = false;
  bool _hasError = false;

  double? _progress = 0;
  get downloadProgress => _progress;
  get hasError => _hasError;
  get isDownloading => _isDownloading;

  download(Document document) async {
    _hasError = false;
    _isDownloading = true;
    _progress = null;
    String? filename = document.documentName;
    notifyListeners();
    Request request = await appSys.api!.downloadRequest(document);
    CustomLogger.log("DOWNLOAD", "Download request url: ${request.url}");
    //Make a response client
    final StreamedResponse response = await Client().send(request);
    final contentLength = response.contentLength;
    // final contentLength = double.parse(response.headers['x-decompressed-content-length']);

    _progress = 0;
    notifyListeners();
    CustomLogger.log("DOWNLOAD", "Downloading a file : $filename");

    List<int> bytes = [];
    final file = await FileAppUtil.getFilePath(filename);
    response.stream.listen(
      (List<int> newBytes) {
        bytes.addAll(newBytes);
        final downloadedLength = bytes.length;
        _progress = downloadedLength / (contentLength ?? 1);

        notifyListeners();
      },
      onDone: () async {
        try {
          _progress = 100;
          notifyListeners();
          CustomLogger.log("DOWNLOAD", "Téléchargement du fichier terminé : ${file.path}");
          final Directory dir = await FolderAppUtil.getDirectory(downloads: true);
          final Directory _appDocDirFolder = Directory('${dir.path}/');

          if (!await _appDocDirFolder.exists()) {
            //if folder already exists return path
            await _appDocDirFolder.create(recursive: true);
          } //if folder not exists create folder and then return its path

          await file.writeAsBytes(bytes);
        } catch (e) {
          CustomLogger.log("DOWNLOAD", "An error occured while downloading $filename");
          CustomLogger.error(e, stackHint:"MzM=");
          _isDownloading = false;
          _hasError = true;
          notifyListeners();
        }
      },
      onError: (e) {
        CustomLogger.log("DOWNLOAD", "An error occured while downloading $filename");
        CustomLogger.error(e, stackHint:"MzQ=");
        _isDownloading = false;
        _hasError = true;
        notifyListeners();
      },
      cancelOnError: true,
    );
  }

//Download a file in the app directory
  ///Check if file exists
  Future<bool> fileExists(filename) async {
    try {
      if (await Permission.storage.request().isGranted) {
        final Directory dir = await FolderAppUtil.getDirectory(downloads: true);
        final Directory downloadsDir = await FolderAppUtil.createDirectory("${dir.path}/yNotesDownloads/");
        List<FileSystemEntity> list = downloadsDir.listSync();
        bool toReturn = false;
        await Future.forEach(list, (dynamic element) async {
          if (filename == await FileAppUtil.getFileNameWithExtension(element)) {
            toReturn = true;
          }
        });
        return toReturn;
      } else {
        CustomLogger.log("DOWNLOAD", "Not granted");
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
