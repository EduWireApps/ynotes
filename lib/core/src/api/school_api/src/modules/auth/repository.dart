part of school_api;

abstract class AuthRepository extends Repository {
  AuthRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async => Response(error: "Not implemented");

  Future<Response<Map<String, dynamic>>> login(
      {required String username, required String password, Map<String, dynamic>? parameters});
}
