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
            from: Recipient(
                id: (e["from"]["id"] as int).toString(),
                firstName: e["from"]["prenom"],
                lastName: e["from"]["nom"],
                civility: e["from"]["civilite"],
                headTeacher: false,
                subjects: []),
            to: [],
            subject: e["subject"],
            date: DateTime.parse(e["date"])))
        .toList();
    final List<Email> emailsSent = res0.data!["data"]["messages"]["sent"]
        .map<Email>((e) => Email(
            id: (e["id"] as int).toString(),
            read: e["read"],
            from: Recipient(
                id: (e["from"]["id"] as int).toString(),
                firstName: e["from"]["prenom"],
                lastName: e["from"]["nom"],
                civility: e["from"]["civilite"],
                headTeacher: false,
                subjects: []),
            to: (e["to"] as List<dynamic>)
                .map<Recipient>((e) => Recipient(
                    id: (e["id"] as int).toString(),
                    firstName: e["prenom"],
                    lastName: e["nom"],
                    civility: e["civilite"],
                    headTeacher: false,
                    subjects: []))
                .toList(),
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

  Future<Response<String>> getEmailContent(Email email, bool received) async {
    final res = await emailsProvider.getEmailContent(email.id, received);
    if (res.error != null) {
      return Response(error: res.error);
    }
    final String decoded = utf8.decode(base64.decode((res.data!["data"]["content"] as String).replaceAll("\n", "")));
    return Response(data: decoded);
  }

  Future<Response<void>> sendEmail(Email email) async {
    final String content = base64Encode(utf8.encode(HtmlCharacterEntities.encode(email.content!,
        characters: "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåæçèéêëìíîïðñòóôõö÷øùúûüýþÿŒœŠšŸƒˆ˜")));
    final Map<String, dynamic> body = {
      "anneeMessages": "",
      "message": {
        "content": content,
        "subject": email.subject,
        "brouillon": false,
        "files": [],
        "groupesDestinataires": [
          {
            "destinataires": email.to
                .map((e) => {
                      "to_cc_cci": "to",
                      "type": "P",
                      "id": int.parse(e.id),
                      "isSelected": true,
                      "nom": e.lastName,
                      "prenom": e.firstName,
                      "fonction": {"id": 0, "libelle": ""},
                      "classe": {"id": 0, "libelle": "", "code": ""},
                      "classes": [],
                      "responsable": {"id": 0, "typeResp": "", "versQui": "", "contacts": []}
                    })
                .toList(),
          }
        ],
      }
    };
    final res = await emailsProvider.sendEmail(body);
    if (res.error != null) {
      return Response(error: res.error);
    }
    return const Response();
  }
}
