part of school_api;

abstract class GradesModule extends Module<Grade> {
  GradesModule({required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable);

  @protected
  Response<double> calculateAverage();
}
