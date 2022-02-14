part of ecole_directe;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api) : super(repository: _EmailsRepository(api), api: api);
}

class _EmailsProvider extends Provider {
  _EmailsProvider(SchoolApi api) : super(api);

  String? get _studentId => api.authModule.schoolAccount?.entityId;

  Future<Response<Map<String, dynamic>>> getEmails() async =>
      await _request(api, url: "eleves/$_studentId/messages.awp?verbe=getall&typeRecuperation=all");

  Future<Response<Map<String, dynamic>>> getRecipients() async =>
      await _request(api, url: "messagerie/contacts/professeurs.awp?verbe=get");

  Future<Response<Map<String, dynamic>>> getEmailContent(String id, bool received) async => await _request(api,
      url: "eleves/$_studentId/messages/$id.awp?verbe=get&mode=${received ? 'destinataire' : 'expediteur'}");

  Future<Response<Map<String, dynamic>>> sendEmail(Map<String, dynamic> body) async =>
      await _request(api, url: "eleves/$_studentId/messages.awp?verbe=post", body: body);
}

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
          d.add(Document(entityId: (e["id"] as int).toString(), name: e["libelle"], type: e["type"], saved: false));
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
          entityId: (e["id"] as int).toString(),
          read: e["read"],
          subject: e["subject"],
          date: DateTime.parse(e["date"]),
        )
          ..from.value = Recipient(
              entityId: (e["from"]["id"] as int).toString(),
              firstName: e["from"]["prenom"],
              lastName: e["from"]["nom"],
              civility: e["from"]["civilite"],
              headTeacher: false,
              subjects: [])
          ..documents.addAll(documentsReceived[i]);
      }).toList();

      // We prepare an empty list before looping through the emails.
      final List<List<Document>> documentsSent = [];
      // For each email, we get the documents.
      for (final h in (res0.data!["data"]["messages"]["received"] as List<dynamic>)) {
        final List<Document> d = [];
        for (final e in (h["files"] as List<dynamic>)) {
          d.add(Document(entityId: (e["id"] as int).toString(), name: e["libelle"], type: e["type"], saved: false));
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
          entityId: (e["id"] as int).toString(),
          read: e["read"],
          subject: e["subject"],
          date: DateTime.parse(e["date"]),
        )
          ..from.value = Recipient(
              entityId: (e["from"]["id"] as int).toString(),
              firstName: e["from"]["prenom"],
              lastName: e["from"]["nom"],
              civility: e["from"]["civilite"],
              headTeacher: false,
              subjects: [])
          ..to.addAll((e["to"] as List<dynamic>)
              .map<Recipient>((e) => Recipient(
                  entityId: (e["id"] as int).toString(),
                  firstName: e["prenom"],
                  lastName: e["nom"],
                  civility: e["civilite"],
                  headTeacher: false,
                  subjects: []))
              .toList())
          ..documents.addAll(documentsSent[i]);
      }).toList();

      // We then convert the raw data to a list of recipients.
      final List<Recipient> recipients = res1.data!["data"]["contacts"]
          .map<Recipient>((e) => Recipient(
              entityId: (e["id"] as int).toString(),
              firstName: e["prenom"],
              lastName: e["nom"],
              civility: e["civilite"],
              headTeacher: e["isPP"],
              subjects: (e["classes"] as List<dynamic>).map<String>((s) => e["matiere"]).toList()))
          .toList();

      // We return the data.
      return Response(data: {"emailsReceived": emailsReceived, "emailsSent": emailsSent, "recipients": recipients});
    } catch (e) {
      return Response(error: "$e");
    }
  }

  @override
  Future<Response<String>> getEmailContent(Email email, bool received) async {
    final res = await emailsProvider.getEmailContent(email.entityId, received);
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
                      "id": int.parse(e.entityId),
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
