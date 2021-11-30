part of shared;

class Response<T> {
  final T? data;
  final String? error;

  const Response({this.data, this.error}) : assert(data != null || error != null, "Both data and error can't be null.");
}
