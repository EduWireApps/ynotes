part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Metadata metadata;

  final ModulesAvailability modulesAvailability = ModulesAvailability();

  SchoolApi({required this.metadata});

  late final List<Module> modules = [authModule, gradesModule, schoolLifeModule, emailsModule, homeworkModule];

  Future<void> init() async {
    await Offline.init();
    for (final module in modules) {
      await module._init();
    }
  }
}
