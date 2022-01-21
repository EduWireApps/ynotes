part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Metadata metadata;

  final ModulesSupport modulesSupport;

  final ModulesAvailability modulesAvailability = ModulesAvailability();

  SchoolApi({required this.metadata, required this.modulesSupport});

  late final List<Module> modules = [
    authModule,
    gradesModule,
    schoolLifeModule,
    emailsModule,
    homeworkModule,
    documentsModule
  ];

  /// Should only be called after [modulesAvailability] update ([modulesAvailability.save]).
  void refreshModules() {
    for (Module module in modules) {
      module = module;
    }
  }

  Future<void> fetch({bool online = false}) async {
    for (final module in modules) {
      await module.fetch(online: online);
    }
  }

  Future<void> init() async {
    await Offline.init();
    await modulesAvailability.load();
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
