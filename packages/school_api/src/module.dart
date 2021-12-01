part of school_api;

abstract class Module<R extends Repository> extends ChangeNotifier {
  final bool _isSupported;
  final bool _isAvailable;
  bool get isEnabled => _isSupported && _isAvailable;

  Module({required bool isSupported, required bool isAvailable, required this.repository, required this.api})
      : _isSupported = isSupported,
        _isAvailable = isAvailable;

  @protected
  final R repository;

  @protected
  final SchoolApi api;

  bool get isFetching => fetching;

  @protected
  bool fetching = false;

  Future<Response<void>> fetch({bool online = false});
}
