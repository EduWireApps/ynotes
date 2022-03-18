part of pronote;

/* class PronotePeriod {
  DateTime? end;

  DateTime? start;

  dynamic name;

  dynamic id;

  dynamic moyenneGenerale;
  dynamic moyenneGeneraleClasse;

  late PronoteClient _client;

  // Represents a period of the school year. You shouldn't have to create this class manually.

  // Attributes
  // ----------
  // id : str
  //     the id of the period (used internally)
  // name : str
  //     name of the period
  // start : str
  //     date on which the period starts
  // end : str
  //     date on which the period ends

  PronotePeriod(PronoteClient client, Map parsedJson) {
    _client = client;
    id = parsedJson['N'];
    name = parsedJson['L'];
    var inputFormat = DateFormat("dd/MM/yyyy");
    start = inputFormat.parse(parsedJson['dateDebut']['V']);
    end = inputFormat.parse(parsedJson['dateFin']['V']);
  }

  ///Return the eleve average, the max average, the min average, and the class average
  average(var json, var codeMatiere) {
    //The services for the period
    List services = json['donneesSec']['donnees']['listeServices']['V'];
    //The average data for the given matiere

    var averageData = services.firstWhere((element) => element["L"].hashCode.toString() == codeMatiere);
    //Logger.log("PRONOTE", averageData["moyEleve"]["V"]);

    return [
      gradeTranslate(averageData["moyEleve"]["V"]),
      gradeTranslate(averageData["moyMax"]["V"]),
      gradeTranslate(averageData["moyMin"]["V"]),
      gradeTranslate(averageData["moyClasse"]["V"])
    ];
  }


  grades(int codePeriode) async {
    //Get grades from the period.
    List<Grade> list = [];
    var jsonData = {
      'donnees': {
        'Periode': {'N': id, 'L': name}
      },
      "_Signature_": {"onglet": 198}
    };

    //Tests

    /*var a = await Requests.get("http://192.168.1.99:3000/posts/2");

    var response = (codePeriode == 2) ? a.json() : {};
    */
    var response = await _client.communication!.post('DernieresNotes', data: jsonData);
    var grades = safeMapGetter(response, ['donneesSec', 'donnees', 'listeDevoirs', 'V']) ?? [];
    moyenneGenerale = gradeTranslate(safeMapGetter(response, ['donneesSec', 'donnees', 'moyGenerale', 'V']) ?? "");
    moyenneGeneraleClasse = gradeTranslate(safeMapGetter(response, ['donneesSec', 'donnees', 'moyGeneraleClasse', 'V']) ?? "");

    var other = [];
    grades.forEach((element) async {
      list.add(Grade(
          value: gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? ""),
          name: element["commentaire"],
          periodCode: id,
          periodName: name,
          disciplineCode: (safeMapGetter(element, ["service", "V", "L"]) ?? "").hashCode.toString(),
          subdisciplineCode: null,
          disciplineName: safeMapGetter(element, ["service", "V", "L"]),
          letters: (safeMapGetter(element, ["note", "V"]) ?? "").contains("|"),
          weight: safeMapGetter(element, ["coefficient"]).toString(),
          scale: safeMapGetter(element, ["bareme", "V"]),
          min: gradeTranslate(safeMapGetter(element, ["noteMin", "V"]) ?? ""),
          max: gradeTranslate(safeMapGetter(element, ["noteMax", "V"]) ?? ""),
          classAverage: gradeTranslate(safeMapGetter(element, ["moyenne", "V"]) ?? ""),
          date: safeMapGetter(element, ["date", "V"]) != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          notSignificant: gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? "") == "NonNote",
          testType: "Interrogation",
          entryDate: safeMapGetter(element, ["date", "V"]) != null
              ? DateFormat("dd/MM/yyyy").parse(safeMapGetter(element, ["date", "V"]))
              : null,
          countAsZero: shouldCountAsZero(gradeTranslate(safeMapGetter(element, ["note", "V"]) ?? ""))));
      other.add(average(response, (safeMapGetter(element, ["service", "V", "L"]) ?? "").hashCode.toString()));
    });
    return [list, other];
  }

  gradeTranslate(String value) {
    List gradeTranslate = [
      'Absent',
      'Dispensé',
      'Non noté',
      'Inapte',
      'Non rendu',
      'Absent zéro',
      'Non rendu zéro',
      'Félicitations'
    ];
    if (value.contains("|")) {
      return gradeTranslate[int.parse(value[1]) - 1];
    } else {
      return value;
    }
  }

  shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else {
      return false;
    }
  }
}
 */
class _GradesModule extends GradesModule<_GradesRepository> {
  _GradesModule(SchoolApi api) : super(repository: _GradesRepository(api), api: api);
}

class _GradesProvider extends Provider {
  _GradesProvider(SchoolApi api) : super(api);

  Future<Response<List<Grade>>> get() async {
    List<Grade> grades = [];
    Response<List<PronotePeriod>> res = await (api as PronoteApi).client!.periods();
    if (res.hasError) return Response(error: res.error);
    Future.forEach(res.data!, (PronotePeriod pronotePeriod) async {
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
    final Response<List<Grade>> res = await gradesProvider.get();
    if (res.hasError) {
      return Response(error: res.error!);
    }

    List<Period> periods = [];
    List<Subject> subjects = [];
    List<Grade> grades = [];
    grades.addAll(res.data!);
    res.data!.forEach(((element) {
      element.load();
      if (!periods.any((Period period) => period.id == element.period.value?.id)) {
        periods.add(element.period.value!);
      }
      if (!subjects.any((Subject subject) => subject.id == element.subject.value?.id)) {
        subjects.add(element.subject.value!);
      }
    }));
    return Response(data: {
      "periods": periods,
      "subjects": subjects,
      "grades": grades,
    });
  }
}
