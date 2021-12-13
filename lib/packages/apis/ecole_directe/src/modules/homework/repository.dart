part of ecole_directe;

class _HomeworkRepository extends Repository {
  @protected
  late final _HomeworkProvider homeworkProvider = _HomeworkProvider(api);

  _HomeworkRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await homeworkProvider.get();
    if (res.error != null) return res;
    try {
      final List<Homework> homework = [];
      (res.data!["data"] as Map<String, List<dynamic>>).forEach((k, v) {
        homework.addAll(v
            .map<Homework>((e) => Homework(
                  id: (e["idDevoir"] as int).toString(),
                  subjectId: e["codeMatiere"],
                  content: null,
                  date: DateTime.parse(k),
                  entryDate: DateTime.parse(e["donneLe"]),
                  done: e["effectue"],
                  due: e["rendreEnLigne"],
                  assessment: e["interrogation"],
                ))
            .toList());
      });
      final Map<String, dynamic> map = {"homework": homework};
      return Response(data: map);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
