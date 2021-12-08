part of ecole_directe;

class _EmailsRepository extends Repository {
  @protected
  late final _EmailsProvider emailsProvider = _EmailsProvider(api);

  _EmailsRepository(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> get() async {
    final res0 = await emailsProvider.getEmails();
    if (res0.error != null) {
      return Response(error: res0.error);
    }
    final res1 = await emailsProvider.getRecipients();
    if (res1.error != null) {
      return Response(error: res1.error);
    }
    final List<Email> emailsReceived = res0.data!["data"]["messages"]["received"]
        .map<Email>((e) => Email(
            id: (e["id"] as int).toString(),
            read: e["read"],
            sender: e["from"]["name"],
            subject: e["subject"],
            date: DateTime.parse(e["date"])))
        .toList();
    final List<Email> emailsSent = res0.data!["data"]["messages"]["sent"]
        .map<Email>((e) => Email(
            id: (e["id"] as int).toString(),
            read: e["read"],
            sender: e["from"]["name"],
            subject: e["subject"],
            date: DateTime.parse(e["date"])))
        .toList();
    final List<Recipient> recipients = res1.data!["data"]["contacts"]
        .map<Recipient>((e) => Recipient(
            id: (e["id"] as int).toString(),
            firstName: e["prenom"],
            lastName: e["nom"],
            civility: e["civilite"],
            headTeacher: e["isPP"],
            subjects: (e["classes"] as List<dynamic>).map<String>((s) => e["matiere"]).toList()))
        .toList();
    return Response(data: {
      "emailsReceived": emailsReceived..sort((a, b) => a.date.compareTo(b.date)),
      "emailsSent": emailsSent..sort((a, b) => a.date.compareTo(b.date)),
      "recipients": recipients..sort((a, b) => a.lastName.compareTo(b.lastName))
    });
  }
}
