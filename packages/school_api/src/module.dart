part of school_api;

abstract class Module<T> {
  final bool isSupported;
  final bool isAvailable;

  Module({required this.isSupported, required this.isAvailable});

  bool get isFetching => _isFetching;
  bool _isFetching = false;

  @protected
  Future<Response<List<T>>> fetch({bool force = false});
}
