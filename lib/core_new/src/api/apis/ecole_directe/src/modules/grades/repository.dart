part of ecole_directe;

class _GradesRepository extends Repository {
  @protected
  late final _GradesProvider gradesProvider = _GradesProvider(api);

  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await gradesProvider.get();
    if (res.error != null) return res;
    try {
      final List<Period> periods = res.data!["data"]["periodes"]
          .map<Period>((e) => Period(
              id: e["idPeriode"],
              name: e["periode"],
              startDate: DateTime.parse(e["dateDebut"]),
              endDate: DateTime.parse(e["dateFin"]),
              headTeacher: e["ensembleMatieres"]["nomPP"],
              overallAverage: (e["ensembleMatieres"]["moyenneGenerale"] as String).toDouble() ?? double.nan,
              classAverage: (e["ensembleMatieres"]["moyenneClasse"] as String).toDouble() ?? double.nan,
              maxAverage: (e["ensembleMatieres"]["moyenneMax"] as String).toDouble() ?? double.nan,
              minAverage: (e["ensembleMatieres"]["moyenneMin"] as String).toDouble() ?? double.nan))
          .toList();
      periods.sort((a, b) => a.startDate.compareTo(b.startDate));
      final Period yearPeriod = periods.firstWhere((e) => e.id == "A999Z");
      periods.remove(yearPeriod);
      periods.add(yearPeriod);
      List<Map<String, dynamic>> disciplines = [];
      for (var period in res.data!["data"]["periodes"]) {
        for (var d in period["ensembleMatieres"]["disciplines"]) {
          if (disciplines.firstWhereOrNull((e) => e["codeMatiere"] == d["codeMatiere"]) == null) {
            disciplines.add(d);
          }
        }
      }
      final colors = AppColors.colors;
      final Random random = Random();
      final List<Subject> subjects = disciplines.map<Subject>((e) {
        final color = colors[random.nextInt(colors.length)];
        colors.remove(color);
        return Subject(
            id: e["codeMatiere"],
            name: e["discipline"],
            classAverage: (e["moyenneClasse"] as String).toDouble() ?? double.nan,
            maxAverage: (e["moyenneMax"] as String).toDouble() ?? double.nan,
            minAverage: (e["moyenneMin"] as String).toDouble() ?? double.nan,
            coefficient: (e["coef"] as int).toDouble(),
            teachers: (e["professeurs"] as List<dynamic>).map<String>((e) => e["nom"]).toList().join(", "),
            average: (e["moyenne"] as String).toDouble() ?? double.nan,
            color: color);
      }).toList();
      // When this setting is set to [false], all grades' coefficient are set to 0. To counter this,
      // we set the coefficient to 1 for all grades.
      final bool gradesCoefficientsEnabled = res.data!["data"]["parametrage"]["coefficientNote"] as bool;
      final List<Grade> grades = res.data!["data"]["notes"]
          .map<Grade>((e) => Grade(
              name: e["devoir"],
              type: e["typeDevoir"],
              coefficient: gradesCoefficientsEnabled ? (e["coef"] as String).toDouble() ?? double.nan : 1,
              outOf: (e["noteSur"] as String).toDouble() ?? double.nan,
              value: (e["valeur"] as String).toDouble() ?? double.nan,
              significant: !(e["nonSignificatif"] as bool),
              date: DateTime.parse(e["date"]),
              entryDate: DateTime.parse(e["dateSaisie"]),
              classAverage: (e["moyenneClasse"] as String).toDouble() ?? double.nan,
              classMax: (e["maxClasse"] as String).toDouble() ?? double.nan,
              classMin: (e["minClasse"] as String).toDouble() ?? double.nan,
              subjectId: e["codeMatiere"],
              periodId: e["codePeriode"]))
          .toList();
      return Response(data: {
        "periods": periods,
        "subjects": subjects..sort((a, b) => a.name.compareTo(b.name)),
        "grades": grades..sort((a, b) => a.entryDate.compareTo(b.entryDate)),
      });
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
