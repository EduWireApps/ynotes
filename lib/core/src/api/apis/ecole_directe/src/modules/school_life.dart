part of ecole_directe;

class _SchoolLifeModule extends SchoolLifeModule<_SchoolLifeRepository> {
  _SchoolLifeModule(SchoolApi api) : super(repository: _SchoolLifeRepository(api), api: api);
}

class _SchoolLifeProvider extends Provider {
  _SchoolLifeProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async =>
      await _request(api, url: "eleves/${api.authModule.schoolAccount?.entityId}/viescolaire.awp?verbe=get");
}

class _SchoolLifeRepository extends Repository {
  @protected
  late final _SchoolLifeProvider schoolLifeProvider = _SchoolLifeProvider(api);

  _SchoolLifeRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    final res = await schoolLifeProvider.get();
    if (res.error != null) return res;
    try {
      final List<SchoolLifeTicket> tickets = res.data!["data"]["absencesRetards"]
          .map<SchoolLifeTicket>((e) => SchoolLifeTicket(
                duration: e["libelle"],
                displayDate: e["displayDate"],
                reason: e["motif"],
                type: e["typeElement"],
                isJustified: e["justifie"],
                date: DateTime.parse(e["date"]),
              ))
          .toList();
      final List<SchoolLifeSanction> sanctions = res.data!["data"]["sanctionsEncouragements"]
          .map<SchoolLifeSanction>((e) => SchoolLifeSanction(
              type: e["typeElement"],
              registrationDate: e["dateDeroulement"],
              reason: e["motif"],
              by: e["par"],
              date: DateTime.parse(e["date"]),
              sanction: e["libelle"],
              work: e["aFaire"]))
          .toList();
      final Map<String, dynamic> map = {
        "tickets": tickets..sort((a, b) => a.date.compareTo(b.date)),
        "sanctions": sanctions..sort((a, b) => a.date.compareTo(b.date)),
      };
      return Response(data: map);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
