part of school_api;

/// The status of the [DocumentsModule].
///
/// Available values: [idle], [error], [processing], [complete].
enum DocumentsModuleStatus {
  /// The module is doing nothing.
  idle,

  /// The module has encountered an error.
  error,

  /// The module can be either downloading or uploading a document.
  processing,

  /// The module has successfully completed the process.
  complete
}

abstract class DocumentsModule<R extends DocumentsRepository> extends Module<R> {
  DocumentsModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.documents,
          isAvailable: api.modulesAvailability.documents,
          repository: repository,
          api: api,
        );

  double progress = 0.0;
  DocumentsModuleStatus status = DocumentsModuleStatus.idle;
  List<Document> get documents => offline.documents.where().findAllSync();

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    return const Response(error: "Not implemented");
  }

  Future<Response<void>> addDocuments(List<Document> documents) async {
    await offline.writeTxn((isar) async {
      await isar.documents.putAll(documents);
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> removeDocuments(List<Document> documents) async {
    await offline.writeTxn((isar) async {
      await isar.documents.deleteAll(documents.map((e) => e.id!).toList());
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> updateDocuments(List<Document> documents) async {
    await offline.writeTxn((isar) async {
      await isar.documents.putAll(documents);
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> download(Document document, {bool force = false}) async {
    if (status == DocumentsModuleStatus.processing) {
      return const Response(error: "Already downloading");
    }
    if (!force && document.saved) {
      return const Response(error: "Already downloaded");
    }
    final res = repository.download(document);
    if (res.error != null) return res;
    status = DocumentsModuleStatus.processing;
    progress = 0.0;
    notifyListeners();

    final http.StreamedResponse request = await http.Client().send(res.data!);
    final int contentLength = request.contentLength ?? 1;
    notifyListeners();

    List<int> buffer = [];
    dynamic error;
    void onData(List<int> bytes) {
      buffer.addAll(bytes);
      progress = (buffer.length / contentLength * 100).asFixed(2);
      notifyListeners();
    }

    void onDone() async {
      progress = 100;
      status = DocumentsModuleStatus.complete;
      notifyListeners();
      await (await document.file()).writeAsBytes(buffer);
      document.saved = true;
      await updateDocuments([document]);
      Timer(const Duration(seconds: 3), () {
        if (status == DocumentsModuleStatus.complete) {
          status = DocumentsModuleStatus.idle;
          progress = 0.0;
          notifyListeners();
        }
      });
    }

    void onError(dynamic e) {
      error = e;
      progress = 0.0;
      status = DocumentsModuleStatus.error;
      notifyListeners();
    }

    request.stream.listen(onData, onDone: onDone, onError: onError, cancelOnError: true);
    switch (status) {
      case DocumentsModuleStatus.error:
        return Response(error: "$error");
      default:
        return const Response();
    }
  }

  Future<Response<void>> upload(Document document) async {
    return const Response(error: "Not implemented");
  }

  @override
  Future<void> reset() async {
    await offline.writeTxn((isar) async {
      await isar.documents.clear();
    });
    notifyListeners();
  }
}
