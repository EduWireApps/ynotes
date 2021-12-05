part of ecole_directe;

class _GradesRepository extends Repository {
  @protected
  late final _GradesProvider gradesProvider = _GradesProvider(api);

  _GradesRepository(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async {
    final res = await gradesProvider.get();
    if (res.error != null) {
      return Response(error: res.error);
    }
    try {
      print(res.data!);
      final List<Period> periods = res.data!["data"]["periodes"]
          .map<Period>((e) => Period(
              id: e["idPeriode"],
              name: e["periode"],
              startDate: DateTime.parse(e["dateDebut"]),
              endDate: DateTime.parse(e["dateFin"]),
              headTeacher: e["ensembleMatieres"]["nomPP"],
              overallAverage: e["ensembleMatieres"]["moyenneGenerale"],
              classAverage: e["ensembleMatieres"]["moyenneClasse"],
              maxAverage: e["ensembleMatieres"]["moyenneMax"],
              minAverage: e["ensembleMatieres"]["moyenneMin"],
              subjects: HiveList(box, objects: [])))
          .toList();
      return Response(data: {});
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
