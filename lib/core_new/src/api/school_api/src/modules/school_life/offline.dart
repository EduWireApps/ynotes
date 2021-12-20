part of school_api;

class OfflineSchoolLife extends OfflineModel {
  OfflineSchoolLife() : super('schoolLife');

  static const String _ticketsKey = "tickets";
  static const String _sanctionsKey = "sanctions";

  Future<List<SchoolLifeTicket>> getTickets() async {
    return (box?.get(_ticketsKey) as List<dynamic>?)?.map<SchoolLifeTicket>((e) => e).toList() ?? [];
  }

  Future<void> setTickets(List<SchoolLifeTicket> tickets) async {
    await box?.put(_ticketsKey, tickets);
  }

  Future<List<SchoolLifeSanction>> getSanctions() async {
    return (box?.get(_sanctionsKey) as List<dynamic>?)?.map<SchoolLifeSanction>((e) => e).toList() ?? [];
  }

  Future<void> setSanctions(List<SchoolLifeSanction> sanctions) async {
    await box?.put(_sanctionsKey, sanctions);
  }
}
