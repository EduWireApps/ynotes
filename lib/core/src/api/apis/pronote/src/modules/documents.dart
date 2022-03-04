part of pronote;

class _DocumentsModule extends DocumentsModule<_DocumentsRepository> {
  _DocumentsModule(SchoolApi api) : super(repository: _DocumentsRepository(api), api: api);
}

class _DocumentsRepository extends DocumentsRepository {
  _DocumentsRepository(SchoolApi api) : super(api);

  @override
  Response<http.Request> download(Document document) {
    return const Response(error: "Not implemented");
  }

  @override
  Future<Response<http.Request>> upload(Document document) async {
    return const Response(error: "Not implemented");
  }
}
