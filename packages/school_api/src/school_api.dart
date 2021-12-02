part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Offline offline;

  final Metadata metadata;

  final ModulesAvailability modulesAvailability;

  SchoolApi({required this.metadata})
      : offline = Offline(),
        modulesAvailability = ModulesAvailability();

  List<Module> get modules => [authModule, gradesModule, schoolLifeModule];
}
