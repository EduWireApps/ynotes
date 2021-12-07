part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Metadata metadata;

  final ModulesAvailability modulesAvailability = ModulesAvailability();

  SchoolApi({required this.metadata});

  List<Module> get modules => [authModule, gradesModule, schoolLifeModule];
}
