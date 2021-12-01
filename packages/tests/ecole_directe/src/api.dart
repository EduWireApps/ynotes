part of ecole_directe;

String? _token;
const String _baseUrl = "https://api.ecoledirecte.com/v3/";

class EcoleDirecteApi extends SchoolApi<EcoleDirecteClient> {
  EcoleDirecteApi()
      : super(
            metadata: Metadata(
                name: "EcoleDirecte",
                imagePath: "",
                color: YTColor(
                    backgroundColor: Colors.blue[600]!,
                    foregroundColor: Colors.white,
                    lightColor: Colors.blue[600]!.withOpacity(.5))));

  @override
  AuthModule get authModule => _AuthModule(this);

  @override
  GradesModule get gradesModule => _GradesModule(this, isSupported: true, isAvailable: modulesAvailability.schoolLife);

  @override
  SchoolLifeModule get schoolLifeModule =>
      _SchoolLifeModule(this, isSupported: true, isAvailable: modulesAvailability.grades);

  @override
  EcoleDirecteClient get client => EcoleDirecteClient();

  @override
  Future<Response<String>> login({required String username, required String password}) async {
    return const Response<String>(
      error: "Not implemented",
    );
  }
}
