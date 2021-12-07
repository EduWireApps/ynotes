part of school_api;

abstract class Module<R extends Repository, T extends OfflineModel> extends ChangeNotifier {
  late final bool _isSupported;
  late final bool _isAvailable;
  bool get isEnabled => _isSupported && _isAvailable;

  Module(
      {required bool isSupported,
      required bool isAvailable,
      required this.repository,
      required this.api,
      required this.offline}) {
    _isSupported = isSupported;
    _isAvailable = isAvailable;
  }

  Future<void> _init() async {
    await offline.init();
    await fetch(online: false);
  }

  @protected
  final T offline;

  @protected
  final R repository;

  @protected
  final SchoolApi api;

  bool get isFetching => fetching;

  @protected
  bool fetching = false;

  Future<Response<void>> fetch({bool online = false});

  Future<void> reset({bool offline = false}) async {
    if (offline) {
      await this.offline.reset();
    }
    notifyListeners();
  }
}
