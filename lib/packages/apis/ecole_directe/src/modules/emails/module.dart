part of ecole_directe;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _EmailsRepository(api), api: api);

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) {
        return Response(error: res.error);
      }
      emailsSent = res.data!["emailsSent"];
      recipients = res.data!["recipients"];
      final List<Email> _emailsReceived = res.data!["emailsReceived"];
      if (_emailsReceived.length > emailsReceived.length) {
        final List<Email> newEmails = _emailsReceived.toSet().difference(emailsReceived.toSet()).toList();
        // TODO: trigger notifications
      }
      emailsReceived = _emailsReceived;
      // TODO: set offline
    } else {
      // fetch from offline received, sent and recipients
    }
    // fetch favorite
    fetching = false;
    notifyListeners();
    return const Response(error: "Not implemented");
  }
}
