part of ecole_directe;

class _EmailsProvider extends Provider {
  _EmailsProvider(SchoolApi api) : super(api);

  Future<Response<Map<String, dynamic>>> getEmails() async => await _request(api,
      url: "eleves/${api.authModule.schoolAccount?.id}/messages.awp?verbe=getall&typeRecuperation=all");

  Future<Response<Map<String, dynamic>>> getRecipients() async =>
      await _request(api, url: "messagerie/contacts/professeurs.awp?verbe=get");
}
