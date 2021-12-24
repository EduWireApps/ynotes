part of ecole_directe;

String? _token;
const String _baseUrl = "https://api.ecoledirecte.com/v3/";

class EcoleDirecteApi extends SchoolApi implements SchoolApiModules {
  EcoleDirecteApi()
      : super(
            metadata: Metadata(
                name: "Ecole Directe",
                imagePath: "assets/images/icons/ecoledirecte/EcoleDirecteIcon.png",
                color: AppColors.blue,
                beta: true,
                api: Apis.ecoleDirecte,
                coloredLogo: true,
                loginRoute: "/login/ecoledirecte"));

  @override
  void refreshModules() {
    gradesModule = _GradesModule(this, isSupported: true, isAvailable: modulesAvailability.grades);
    // TODO: complete
  }

  @override
  late AuthModule authModule = _AuthModule(this);

  @override
  late GradesModule gradesModule = _GradesModule(this, isSupported: true, isAvailable: modulesAvailability.grades);

  @override
  late SchoolLifeModule schoolLifeModule =
      _SchoolLifeModule(this, isSupported: true, isAvailable: modulesAvailability.schoolLife);

  @override
  late EmailsModule emailsModule = _EmailsModule(this, isSupported: true, isAvailable: modulesAvailability.emails);

  @override
  late HomeworkModule homeworkModule =
      _HomeworkModule(this, isSupported: true, isAvailable: modulesAvailability.homework);

  @override
  late DocumentsModule documentsModule =
      _DocumentsModule(this, isSupported: true, isAvailable: modulesAvailability.documents);
}
