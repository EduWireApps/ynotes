part of ecole_directe;

String? _token;
const String _baseUrl = "https://api.ecoledirecte.com/v3/";

final Metadata metadata = Metadata(
    name: "Ecole Directe",
    imagePath: "assets/images/icons/ecoledirecte/EcoleDirecteIcon.png",
    color: AppColors.blue,
    beta: true,
    api: Apis.ecoleDirecte,
    coloredLogo: true,
    loginRoute: "/login/ecoledirecte");

const ModulesSupport modulesSupport =
    ModulesSupport(grades: true, schoolLife: true, emails: true, homework: true, documents: true);

class EcoleDirecteApi extends SchoolApi implements SchoolApiModules {
  EcoleDirecteApi() : super(metadata: metadata, modulesSupport: modulesSupport);

  @override
  late AuthModule authModule = _AuthModule(this);

  @override
  late GradesModule gradesModule = _GradesModule(this);

  @override
  late SchoolLifeModule schoolLifeModule = _SchoolLifeModule(this);

  @override
  late EmailsModule emailsModule = _EmailsModule(this);

  @override
  late HomeworkModule homeworkModule = _HomeworkModule(this);

  @override
  late DocumentsModule documentsModule = _DocumentsModule(this);
}
