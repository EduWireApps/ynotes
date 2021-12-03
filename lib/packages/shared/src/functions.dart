part of shared;

Future<Response<T>> handleNetworkError<T>(Future<Response<T>> Function() fn) async {
  try {
    return await fn();
  } on SocketException {
    return Response<T>(error: "No internet connection");
  }
}
