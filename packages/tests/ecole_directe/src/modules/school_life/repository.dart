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
      // TODO: implement sanctions
      final List<SchoolLifeTicket> tickets = res.data!["data"]["absencesRetards"]
          .map<SchoolLifeTicket>((e) => SchoolLifeTicket(
              duration: e["libelle"],
              displayDate: e["displayDate"],
              reason: e["motif"],
              type: e["typeElement"],
              isJustified: e["justifie"],
              date: DateTime.parse(e["date"])))
          .toList();
      return Response(data: tickets..sort((a, b) => a.date.compareTo(b.date)));
    } catch (e) {
      return Response(error: "$e");
    }
  }
}
