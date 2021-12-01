part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R> {
  GradesModule({required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: repository, api: api);

  @protected
  Response<double> calculateAverage();

  List<Grade> get grades => _grades;

  @protected
  // ignore: prefer_final_fields
  List<Grade> _grades = [];
}
