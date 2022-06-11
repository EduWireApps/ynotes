part of shared;

Future<Response<T>> handleNetworkError<T>(Future<Response<T>> Function() fn) async {
  try {
    return await fn();
  } on SocketException {
    return Response<T>(error: "No internet connection");
  }
}

/// Safely returns a map value without error
dynamic safeMapGetter(Map? map, List path) {
  assert(path.isNotEmpty);
  var m = map ?? {};
  for (int i = 0; i < path.length - 1; i++) {
    m = m[path[i]] ?? {};
  }

  return m[path.last];
}
