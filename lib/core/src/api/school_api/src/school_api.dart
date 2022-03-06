part of school_api;

abstract class SchoolApi extends ChangeNotifier implements SchoolApiModules {
  final Metadata metadata;

  final ModulesSupport modulesSupport;

  final ModulesAvailability modulesAvailability = ModulesAvailability();

  late final List<Module> modules = [
    authModule,
    gradesModule,
    schoolLifeModule,
    emailsModule,
    homeworkModule,
    documentsModule
  ];

  SchoolApi({required this.metadata, required this.modulesSupport});

  Future<List<String>?> fetch() async {
    final List<String> errors = [];
    Logger.log("MODULES", modules.where((element) => element._isAvailable && element._isSupported));
    for (final module in modules.where((element) => element._isAvailable && element._isSupported)) {
      final res = await module.fetch();
      if (res.hasError) {
        errors.add(res.error!);
      }
    }
    return errors.isEmpty ? null : errors;
  }

  Future<void> init() async {
    await _Storage.init();
    await Offline.init();
    await modulesAvailability.load();
    for (final module in modules) {
      await module._init();
    }
  }

  /// Should only be called after [modulesAvailability] update ([modulesAvailability.save]).
  void refreshModules() {
    for (Module module in modules) {
      module = module;
    }
  }

  Future<void> reset({bool auth = false}) async {
    if (!Offline.store.initialized) {
      await init();
    }
    await _Storage.reset();
    for (final module in modules) {
      if (auth) {
        await module.reset();
      } else {
        if (module is! AuthModule) {
          await module.reset();
        }
      }
    }
  }
}
