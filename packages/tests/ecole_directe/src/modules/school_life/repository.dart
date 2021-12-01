part of ecole_directe;

class _SchoolLifeRepository extends Repository {
  @protected
  late final _SchoolLifeTicketsProvider ticketsProvider = _SchoolLifeTicketsProvider(api);

  _SchoolLifeRepository(SchoolApi api) : super(api);

  Future<Response<List<SchoolLifeTicket>>> getTickets() async {
    // TODO: implement offline support
    final res = await ticketsProvider.get();
    if (res.error != null) {
      return Response(error: res.error);
    }
    try {
      final List<SchoolLifeTicket> tickets = (res.data!["data"]["absencesRetards"] as List<Map<String, dynamic>>)
          .map((e) => SchoolLifeTicket(
              duration: e["libelle"],
              date: e["displayDate"],
              reason: e["motif"],
              type: e["typeElement"],
              isJustified: e["justifie"]))
          .toList();
      return Response(data: tickets);
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
