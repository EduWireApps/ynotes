part of shared;

class Response<T> {
  final T? data;
  final String? error;

  Response({this.data, this.error}) {
    if (hasError) {
      Logger.error(error, stackHint:"MA==");
    }
  }
  bool get hasError => error != null;
}
