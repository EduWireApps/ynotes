part of ecole_directe;

class _GradesRepository extends Repository {
  @protected
  late final _GradesProvider gradesProvider = _GradesProvider(api);

  _GradesRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await gradesProvider.get();
    if (res.error != null) return res;

    final List<dynamic> filteredPeriods = (res.data!["data"]["periodes"] as List<dynamic>)
        // Keep the space after "Relevé"
        .where((element) => !["Relevé ", "Année"].contains(element["periode"]))
        .toList();
    final List<Period> periods = filteredPeriods.map<Period>((e) {
      for (var d in e["ensembleMatieres"]["disciplines"]) {
        d["codePeriode"] = e["idPeriode"];
      }
      return Period(
          entityId: e["idPeriode"],
          name: e["periode"],
          startDate: DateTime.parse(e["dateDebut"]),
          endDate: DateTime.parse(e["dateFin"]),
          headTeacher: e["ensembleMatieres"]["nomPP"],
          overallAverage: (e["ensembleMatieres"]["moyenneGenerale"] as String).toDouble() ?? double.nan,
          classAverage: (e["ensembleMatieres"]["moyenneClasse"] as String).toDouble() ?? double.nan,
          maxAverage: (e["ensembleMatieres"]["moyenneMax"] as String).toDouble() ?? double.nan,
          minAverage: (e["ensembleMatieres"]["moyenneMin"] as String).toDouble() ?? double.nan);
    }).toList();
    periods.sort((a, b) => a.startDate.compareTo(b.startDate));
    List<Map<String, dynamic>> disciplines = [];
    for (var period in filteredPeriods) {
      for (var d in period["ensembleMatieres"]["disciplines"]) {
        disciplines.add(d);
      }
    }
    for (final grade in res.data!["data"]["notes"]) {
      final _subjects = disciplines.map<String>((e) => e["codeMatiere"] as String).toList();
      if (!_subjects.contains(grade["codeMatiere"])) {
        disciplines.add(
          {
            "codePeriode": grade["codePeriode"],
            "id": grade["codeMatiere"] as String,
            "codeMatiere": grade["codeMatiere"] as String,
            "codeSousMatiere": "",
            "discipline": grade["libelleMatiere"] as String,
            "moyenne": "",
            "moyenneClasse": "",
            "moyenneMin": "",
            "moyenneMax": "",
            "coef": 1,
            "effectif": 0,
            "rang": 0,
            "groupeMatiere": false,
            "idGroupeMatiere": 0,
            "option": 0,
            "sousMatiere": false,
            "saisieAppreciationSSMat": false,
            "professeurs": [
              {"id": 0, "nom": "Inconnu"}
            ]
          },
        );
      }
    }
    final colors = List.from(AppColors.colors);
    final Random random = Random();
    final Map<String, YTColor> assignedColors = {};
    final List<Subject> subjects = disciplines.map<Subject>((e) {
      late YTColor color;
      if (assignedColors.containsKey(e["codeMatiere"])) {
        color = assignedColors[e["codeMatiere"]]!;
      } else {
        color = colors[random.nextInt(colors.length)];
        assignedColors[e["codeMatiere"]] = color;
        colors.remove(color);
      }
      return Subject(
          entityId: e["codeMatiere"],
          name: e["discipline"],
          classAverage: (e["moyenneClasse"] as String).toDouble() ?? double.nan,
          maxAverage: (e["moyenneMax"] as String).toDouble() ?? double.nan,
          minAverage: (e["moyenneMin"] as String).toDouble() ?? double.nan,
          coefficient: (e["coef"] as int).toDouble(),
          teachers: (e["professeurs"] as List<dynamic>).map<String>((e) => e["nom"]).toList().join(", "),
          average: (e["moyenne"] as String).toDouble() ?? double.nan,
          color: color)
        ..period.value = periods.firstWhere((p) => p.entityId == e["codePeriode"]);
    }).toList();
    // When this setting is set to [false], all grades' coefficient are set to 0. To counter this,
    // we set the coefficient to 1 for all grades.
    final bool gradesCoefficientsEnabled = res.data!["data"]["parametrage"]["coefficientNote"] as bool;
    final List<Grade> grades = res.data!["data"]["notes"].map<Grade>((e) {
      Grade g = Grade(
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
      )
        ..subject.value =
            subjects.firstWhere((s) => s.entityId == e["codeMatiere"] && s.period.value!.entityId == e["codePeriode"])
        ..period.value = periods.firstWhere((p) => p.entityId == e["codePeriode"]);
      return g;
    }).toList();
    return Response(data: {
      "periods": periods,
      "subjects": subjects,
      "grades": grades,
    });
  }
}
