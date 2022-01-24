part of ecole_directe;

class _HomeworkRepository extends HomeworkRepository {
  @protected
  late final _HomeworkProvider homeworkProvider = _HomeworkProvider(api);

  _HomeworkRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await homeworkProvider.get();
    if (res.error != null) return res;
    try {
      final List<Homework> homework = [];
      (res.data!["data"].cast<String, List<dynamic>>() as Map<String, List<dynamic>>).forEach((k, v) {
        homework.addAll(v
            .map<Homework>(
              (e) => Homework(
                entityId: (e["idDevoir"] as int).toString(),
                content: null,
                date: DateTime.parse(k),
                entryDate: DateTime.parse(e["donneLe"]),
                done: e["effectue"],
                due: e["rendreEnLigne"],
                assessment: e["interrogation"],
              )..subject.value =
                  api.gradesModule.subjects.firstWhere((subject) => subject.entityId == e["codeMatiere"]),
            )
            .toList());
      });
      final Map<String, dynamic> map = {"homework": homework};
      return Response(data: map);
    } catch (e) {
      return Response(error: "$e");
    }
  }

  @override
  Future<Response<List<Homework>>> getDay(DateTime date) async {
    final res = await homeworkProvider.getDay(date);
    if (res.error != null) return Response(error: res.error);
    try {
      final List<List<Document>> documents = [];
      for (final h in (res.data!["data"]["matieres"] as List<dynamic>).where((e) => e["aFaire"] != null)) {
        final List<Document> d = [];
        for (final e in (h["aFaire"]["documents"] as List<dynamic>)) {
          d.add(Document(entityId: (e["id"] as int).toString(), name: e["libelle"], type: e["type"], saved: false));
        }
        documents.add(d);
      }
      await api.documentsModule.addDocuments(documents.expand<Document>((e) => e).toList());
      final List<Homework> homework = (res.data!["data"]["matieres"] as List<dynamic>)
          .where((e) => e["aFaire"] != null)
          .toList()
          .asMap()
          .entries
          .map((entry) {
        final int i = entry.key;
        final dynamic e = entry.value;
        return Homework(
          entityId: (e["id"] as int).toString(),
          content: decodeContent(e["aFaire"]["contenu"]),
          date: date,
          entryDate: DateTime.parse(e["aFaire"]["donneLe"]),
          done: e["aFaire"]["effectue"],
          due: e["aFaire"]["rendreEnLigne"],
          assessment: e["interrogation"],
        )
          ..subject.value = api.gradesModule.subjects.firstWhere((subject) => subject.entityId == e["codeMatiere"])
          ..documents.addAll(documents[i]);
      }).toList();
      return Response(data: homework);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
