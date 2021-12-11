part of ecole_directe;

class _EmailsProvider extends Provider {
  _EmailsProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> getEmails() async => await _request(api,
      url: "eleves/${api.authModule.schoolAccount?.id}/messages.awp?verbe=getall&typeRecuperation=all");

  Future<Response<Map<String, dynamic>>> getRecipients() async =>
      await _request(api, url: "messagerie/contacts/professeurs.awp?verbe=get");

  Future<Response<Map<String, dynamic>>> getEmailContent(String id, bool received) async => await _request(api,
      url:
          "eleves/${api.authModule.schoolAccount?.id}/messages/$id.awp?verbe=get&mode=${received ? 'destinataire' : 'expediteur'}");
}
