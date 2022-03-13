part of school_api;

abstract class DocumentsRepository extends Repository {
  DocumentsRepository(SchoolApi api) : super(api);

  Response<http.Request> download(Document document);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return Response(error: "Unavailable");
  }

  Future<Response<http.Request>> upload(Document document);
}
