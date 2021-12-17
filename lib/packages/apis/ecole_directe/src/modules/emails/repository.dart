part of ecole_directe;

class _EmailsRepository extends EmailsRepository {
  @protected
  late final _EmailsProvider emailsProvider = _EmailsProvider(api);

  _EmailsRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    // We get the emails as raw data.
    final res0 = await emailsProvider.getEmails();
    // If an error occured during the request, we return it.
    if (res0.error != null) {
      return Response(error: res0.error);
    }

    // We get the email recipients as raw data.
    final res1 = await emailsProvider.getRecipients();
    // If an error occured during the request, we return it.
    if (res1.error != null) {
      return Response(error: res1.error);
    }

    // We now turn rawData into classes to be used in the app.
    try {
      // We prepare an empty list before looping through the emails.
      final List<List<Document>> documentsReceived = [];
      // For each email, we get the documents.
      for (final h in (res0.data!["data"]["messages"]["received"] as List<dynamic>)) {
        final List<Document> d = [];
        for (final e in (h["files"] as List<dynamic>)) {
          d.add(Document(id: (e["id"] as int).toString(), name: e["libelle"], type: e["type"], saved: false));
        }
        documentsReceived.add(d);
      }
      // We save the documents to Hive.
      await api.documentsModule.addDocuments(documentsReceived.expand<Document>((e) => e).toList());
      // We then convert the raw data to a list of emails.
      final List<Email> emailsReceived =
          (res0.data!["data"]["messages"]["received"] as List<dynamic>).asMap().entries.map((entry) {
        final int i = entry.key;
        final dynamic e = entry.value;
        return Email(
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
            date: DateTime.parse(e["date"]),
            documentsIds: documentsReceived[i].map((e) => e.id).toList());
      }).toList();

      // We prepare an empty list before looping through the emails.
      final List<List<Document>> documentsSent = [];
      // For each email, we get the documents.
      for (final h in (res0.data!["data"]["messages"]["received"] as List<dynamic>)) {
        final List<Document> d = [];
        for (final e in (h["files"] as List<dynamic>)) {
          d.add(Document(id: (e["id"] as int).toString(), name: e["libelle"], type: e["type"], saved: false));
        }
        documentsSent.add(d);
      }
      // We save the documents to Hive.
      await api.documentsModule.addDocuments(documentsSent.expand<Document>((e) => e).toList());
      // We then convert the raw data to a list of emails.
      final List<Email> emailsSent =
          (res0.data!["data"]["messages"]["sent"] as List<dynamic>).asMap().entries.map((entry) {
        final int i = entry.key;
        final dynamic e = entry.value;
        return Email(
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
            date: DateTime.parse(e["date"]),
            documentsIds: documentsReceived[i].map((e) => e.id).toList());
      }).toList();

      // We then convert the raw data to a list of recipients.
      final List<Recipient> recipients = res1.data!["data"]["contacts"]
          .map<Recipient>((e) => Recipient(
              id: (e["id"] as int).toString(),
              firstName: e["prenom"],
              lastName: e["nom"],
              civility: e["civilite"],
              headTeacher: e["isPP"],
              subjects: (e["classes"] as List<dynamic>).map<String>((s) => e["matiere"]).toList()))
          .toList();

      // We return the data, sorted.
      return Response(data: {
        "emailsReceived": emailsReceived..sort((a, b) => a.date.compareTo(b.date)),
        "emailsSent": emailsSent..sort((a, b) => a.date.compareTo(b.date)),
        "recipients": recipients..sort((a, b) => a.lastName.compareTo(b.lastName))
      });
    } catch (e) {
      return Response(error: "$e");
    }
  }

  @override
  Future<Response<String>> getEmailContent(Email email, bool received) async {
    final res = await emailsProvider.getEmailContent(email.id, received);
    if (res.error != null) {
      return Response(error: res.error);
    }
    try {
      final String decoded = utf8.decode(base64.decode((res.data!["data"]["content"] as String).replaceAll("\n", "")));
      return Response(data: decoded);
    } catch (e) {
      return Response(error: "$e");
    }
  }

  @override
  Future<Response<void>> sendEmail(Email email) async {
    final String content = encodeContent(email.content!);
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
