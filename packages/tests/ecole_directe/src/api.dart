part of ecole_directe;

class EcoleDirecteApi extends SchoolApi {
  EcoleDirecteApi() : super(metadata: const Metadata(name: "EcoleDirecte"));

  @override
  GradesModule get gradesModule => _GradesModule(isSupported: true, isAvailable: modulesAvailability.grades);

  @override
  Future<Response<String>> login({required String username, required String password}) async {
    return const Response<String>(
      error: "Not implemented",
    );
  }
}
