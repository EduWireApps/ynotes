part of ecole_directe;

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
