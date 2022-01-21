part of ecole_directe;

class _DocumentsRepository extends DocumentsRepository {
  _DocumentsRepository(SchoolApi api) : super(api);

  @override
  Response<http.Request> download(Document document) {
    final String type = document.type;
    final String id = document.id;
    final String url = "${_baseUrl}telechargement.awp?verbe=post&leTypeDeFichier=$type&fichierId=$id";
    http.Request request = http.Request("POST", Uri.parse(url));
    request.body = _encodeBody(null);
    request.headers["X-Token"] = _token!;
    return Response(data: request);
  }

  @override
  Future<Response<http.Request>> upload(Document document) async {
    return const Response(error: "Not implemented");
  }
}
