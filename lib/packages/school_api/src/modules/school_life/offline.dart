part of school_api;

class OfflineSchoolLife extends OfflineModel {
  OfflineSchoolLife() : super('schoolLife');

  static const String ticketsKey = "tickets";
  static const String sanctionsKey = "sanctions";

  Future<List<SchoolLifeTicket>> getTickets() async {
    return (box?.get(ticketsKey) as List<dynamic>?)?.map<SchoolLifeTicket>((e) => e).toList() ?? [];
  }

  Future<void> setTickets(List<SchoolLifeTicket> tickets) async {
    await box?.put(ticketsKey, tickets);
  }

  Future<List<SchoolLifeSanction>> getSanctions() async {
    return box?.get(sanctionsKey) as List<SchoolLifeSanction>? ?? [];
  }

  Future<void> setSanctions(List<SchoolLifeSanction> sanctions) async {
    await box?.put(sanctionsKey, sanctions);
  }
}
