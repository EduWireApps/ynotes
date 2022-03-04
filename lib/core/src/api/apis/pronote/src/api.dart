part of pronote;

final Metadata metadata = Metadata(
    name: "Pronote",
    imagePath: "assets/images/icons/oribite/PronoteIcon.png",
    color: AppColors.green,
    beta: true,
    api: Apis.pronote,
    coloredLogo: true,
    loginRoute: "/login/pronote");

const ModulesSupport modulesSupport =
    ModulesSupport(grades: true, schoolLife: false, emails: false, homework: false, documents: false);

class PronoteApi extends SchoolApi implements SchoolApiModules {
  PronoteApi() : super(metadata: metadata, modulesSupport: modulesSupport);

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
