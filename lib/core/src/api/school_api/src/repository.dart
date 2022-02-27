part of school_api;

abstract class Repository {
  @protected
  final SchoolApi api;

  Repository(this.api);

  Future<Response<Map<String, dynamic>>> get();
}
