part of pronote_client;

class PronotePeriod {
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
    var grades = response['donneesSec']['donnees']['listeDevoirs']['V'] ?? [];
    moyenneGenerale = gradeTranslate(response['donneesSec']['donnees']['moyGenerale']['V'] ?? "");
    moyenneGeneraleClasse = gradeTranslate(response['donneesSec']['donnees']['moyGeneraleClasse']['V'] ?? "");

    var other = [];
    grades.forEach((element) async {
      list.add(Grade(
          value: gradeTranslate(element["note"]["V"] ?? ""),
          testName: element["commentaire"],
          periodCode: id,
          periodName: name,
          disciplineCode: (element["service"]["V"]["L"] ?? "").hashCode.toString(),
          subdisciplineCode: null,
          disciplineName: element["service"]["V"]["L"],
          letters: (element["note"]["V"] ?? "").contains("|"),
          weight: element["coefficient"].toString(),
          scale: element["bareme"]["V"],
          min: gradeTranslate(element["noteMin"]["V"] ?? ""),
          max: gradeTranslate(element["noteMax"]["V"] ?? ""),
          classAverage: gradeTranslate(element["moyenne"]["V"] ?? ""),
          date: element["date"]["V"] != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          notSignificant: gradeTranslate(element["note"]["V"] ?? "") == "NonNote",
          testType: "Interrogation",
          entryDate: element["date"]["V"] != null ? DateFormat("dd/MM/yyyy").parse(element["date"]["V"]) : null,
          countAsZero: shouldCountAsZero(gradeTranslate(element["note"]["V"] ?? ""))));
      other.add(average(response, (element["service"]["V"]["L"] ?? "").hashCode.toString()));
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
