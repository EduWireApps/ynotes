part of school_api;

abstract class EmailsModule<R extends Repository> extends Module<R, OfflineEmails> {
  EmailsModule({required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(
            isSupported: isSupported,
            isAvailable: isAvailable,
            repository: repository,
            api: api,
            offline: OfflineEmails());

  List<Email> emailsSent = [];
  List<Email> emailsReceived = [];
  List<Email> favoriteEmails = [];
  List<Recipient> recipients = [];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      final List<Email> _emailsReceived = res.data!["emailsReceived"] ?? [];
      if (_emailsReceived.length > emailsReceived.length) {
        final List<Email> newEmails = _emailsReceived.sublist(emailsReceived.length);
        // TODO: foreach: trigger notifications
        emailsReceived.addAll(newEmails);
        await offline.setEmailsReceived(emailsReceived);
      }
      final List<Email> _emailsSent = res.data!["emailsSent"] ?? [];
      if (_emailsSent.length > emailsSent.length) {
        final List<Email> newEmails = _emailsSent.sublist(emailsSent.length);
        emailsSent.addAll(newEmails);
        await offline.setEmailsSent(emailsSent);
      }
      final List<Recipient> _recipients = res.data!["recipients"] ?? [];
      if (_recipients.length > recipients.length) {
        final List<Recipient> newRecipients = _recipients.toSet().difference(recipients.toSet()).toList();
        recipients.addAll(newRecipients);
        await offline.setRecipients(recipients);
      }
    } else {
      emailsReceived = await offline.getEmailsReceived();
      emailsSent = await offline.getEmailsSent();
      recipients = await offline.getRecipients();
    }
    final List<String> favoriteEmailsIds = await offline.getFavoriteEmailsIds();
    favoriteEmails = [...emailsReceived, ...emailsSent].where((email) => favoriteEmailsIds.contains(email.id)).toList();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<void> addFavoriteEmail(Email email) async {
    favoriteEmails.add(email);
    await offline.setFavoriteEmailsIds(favoriteEmails.map((e) => e.id).toList());
  }

  Future<void> removeFavoriteEmail(Email email) async {
    favoriteEmails.remove(email);
    await offline.setFavoriteEmailsIds(favoriteEmails.map((e) => e.id).toList());
  }

  Future<Response<void>> read(Email email);

  Future<Response<void>> send(Email email);

  @override
  Future<void> reset({bool offline = false}) async {
    emailsSent = [];
    recipients = [];
    emailsReceived = [];
    favoriteEmails = [];
    await super.reset(offline: offline);
  }
}
