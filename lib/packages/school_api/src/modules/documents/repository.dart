part of school_api;

abstract class DocumentsRepository extends Repository {
  DocumentsRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response(error: "Not implemented");
  }

  Response<http.Request> download(Document document);

  Future<Response<http.Request>> upload(Document document);
}
