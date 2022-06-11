part of pronote;

class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api) : super(repository: _GradesRepository(api), api: api);
}

class _GradesProvider extends Provider {
  _GradesProvider(SchoolApi api) : super(api);

  Future<Response<List<Grade>>> get() async {
    List<Grade> grades = [];
    Response<List<PronotePeriod>> res = (api as PronoteApi).client!.periods();
    if (res.hasError) return Response(error: res.error);
    await Future.forEach(res.data!, (PronotePeriod pronotePeriod) async {
      Response gradeRes = await pronotePeriod.grades();
      if (gradeRes.hasError) return Response(error: gradeRes.error);
      grades.addAll(gradeRes.data!);
    });
    return Response(data: grades);
  }
}

class _GradesRepository extends Repository {
  @protected
  late final _GradesProvider gradesProvider = _GradesProvider(api);

  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    try {
      final Response<List<Grade>> res = await gradesProvider.get();
      if (res.hasError) {
        return Response(error: res.error!);
      }

      List<Period> periods = [];
      List<Subject> subjects = [];
      List<Grade> grades = [];
      List<GradeValue> gradesValues = [];
      grades.addAll(res.data!);
      res.data!.forEach(((element) {
        if (!periods.any((Period period) => period.id == element.period.value?.id)) {
          periods.add(element.period.value!);
        }
        if (!subjects.any((Subject subject) => subject.id == element.subject.value?.id)) {
          subjects.add(element.subject.value!);
        }

        gradesValues.add(element.gradeValue.value!);
      }));
      return Response(data: {"periods": periods, "subjects": subjects, "grades": grades, "gradesValues": gradesValues});
    } catch (e) {
      return Response(error: e.toString());
    }
  }
}
