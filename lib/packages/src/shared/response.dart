part of shared;

class Response<T> {
  final T? data;
  final String? error;

  const Response({this.data, this.error});
}