part of shared;

class Response<T> {
  final T? data;
  final String? error;

  bool get hasError => error != null;
  const Response({this.data, this.error});
}
