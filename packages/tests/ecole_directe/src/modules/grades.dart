part of ecole_directe;

class _GradesModule extends GradesModule {
  _GradesModule({required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable);

  @override
  Future<Response<List<Grade>>> fetch({bool force = false}) async {
    return const Response(
      error: "Not implemented",
    );
  }

  @override
  Response<double> calculateAverage({List<Grade>? grades}) => const Response(error: "Not implemented");
}
