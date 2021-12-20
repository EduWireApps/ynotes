part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Metadata metadata;

  final ModulesAvailability modulesAvailability = ModulesAvailability();

  SchoolApi({required this.metadata});

  late final List<Module> modules = [
    authModule,
    gradesModule,
    schoolLifeModule,
    emailsModule,
    homeworkModule,
    documentsModule
  ];

  Future<void> init() async {
    await Offline.init();
    for (final module in modules) {
      await module._init();
    }
  }

  Future<void> reset({bool auth = false}) async {
    if (!Offline.store.initialized) {
      await init();
    }
    for (final module in modules) {
      if (auth) {
        await module.reset(offline: true);
      } else {
        if (module is! AuthModule) {
          await module.reset(offline: true);
        }
      }
    }
  }
}
