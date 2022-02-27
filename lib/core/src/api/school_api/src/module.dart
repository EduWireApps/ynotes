part of school_api;

abstract class Module<R extends Repository> extends ChangeNotifier {
  late final bool _isSupported;
  late final bool _isAvailable;
  bool get isEnabled => _isSupported && _isAvailable;

  Module({
    required bool isSupported,
    required bool isAvailable,
    required this.repository,
    required this.api,
  }) {
    _isSupported = isSupported;
    _isAvailable = isAvailable;
  }

  Future<void> _init() async {
    await Offline.init();
  }

  @protected
  final R repository;

  @protected
  final SchoolApi api;

  bool get isFetching => fetching;

  @protected
  bool fetching = false;

  @protected
  Isar get offline => Offline.isar;

  Future<Response<void>> fetch();

  Future<void> reset();
}
