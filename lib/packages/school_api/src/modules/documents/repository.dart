part of school_api;

abstract class DocumentsRepository extends Repository {
  DocumentsRepository(SchoolApi api) : super(api);

  Future<Response<http.Request>> download(Document document);

  Future<Response<http.Request>> upload(Document document);
}
