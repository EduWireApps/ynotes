part of shared;

class Response<T> {
  final T? data;
  final String? error;

  Response({this.data, this.error}) {
    if (hasError) {
      Logger.error(error);
    }
  }
  bool get hasError => error != null;
}
