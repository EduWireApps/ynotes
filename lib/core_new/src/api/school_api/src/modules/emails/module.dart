part of school_api;

abstract class EmailsModule<R extends EmailsRepository> extends Module<R, OfflineEmails> {
  EmailsModule({required R repository, required SchoolApi api})
      : super(
            isSupported: api.modulesSupport.emails,
            isAvailable: api.modulesAvailability.emails,
            repository: repository,
            api: api,
            offline: OfflineEmails());

  List<Email> get emailsSent => _emailsSent;
  List<Email> get emailsReceived => _emailsReceived;
  List<Email> get favoriteEmails => _favoriteEmails;
  List<Recipient> get recipients => _recipients;
  List<Email> _emailsSent = [];
  List<Email> _emailsReceived = [];
  List<Email> _favoriteEmails = [];
  List<Recipient> _recipients = [];

  @override
  Future<Response<void>> fetch({bool online = false}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      final res = await repository.get();
      if (res.error != null) return res;
      final List<Email> __emailsReceived = res.data!["emailsReceived"] ?? [];
      if (__emailsReceived.length > _emailsReceived.length) {
        final List<Email> newEmails = __emailsReceived.sublist(_emailsReceived.length);
        // TODO: foreach: trigger notifications
        _emailsReceived.addAll(newEmails);
        await offline.setEmailsReceived(_emailsReceived);
      }
      final List<Email> __emailsSent = res.data!["emailsSent"] ?? [];
      if (__emailsSent.length > _emailsSent.length) {
        final List<Email> newEmails = __emailsSent.sublist(_emailsSent.length);
        _emailsSent.addAll(newEmails);
        await offline.setEmailsSent(_emailsSent);
      }
      final List<Recipient> __recipients = res.data!["recipients"] ?? [];
      if (__recipients.length > _recipients.length) {
        final List<Recipient> newRecipients = __recipients.toSet().difference(_recipients.toSet()).toList();
        _recipients.addAll(newRecipients);
        await offline.setRecipients(_recipients);
      }
    } else {
      _emailsReceived = await offline.getEmailsReceived();
      _emailsSent = await offline.getEmailsSent();
      _recipients = await offline.getRecipients();
    }
    final List<String> favoriteEmailsIds = await offline.getFavoriteEmailsIds();
    _favoriteEmails =
        [..._emailsReceived, ..._emailsSent].where((email) => favoriteEmailsIds.contains(email.id)).toList();
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<void> addFavoriteEmail(Email email) async {
    _favoriteEmails.add(email);
    await offline.setFavoriteEmailsIds(_favoriteEmails.map((e) => e.id).toList());
  }

  Future<void> removeFavoriteEmail(Email email) async {
    _favoriteEmails.remove(email);
    await offline.setFavoriteEmailsIds(_favoriteEmails.map((e) => e.id).toList());
  }

  Future<Response<void>> read(Email email) async {
    if (email.content != null) return const Response();
    final bool received = _emailsReceived.contains(email);
    final res = await repository.getEmailContent(email, received);
    if (res.error != null) return res;
    if (received) {
      _emailsReceived.firstWhere((e) => e.id == email.id).read = true;
      _emailsReceived.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsReceived(_emailsReceived);
    } else {
      _emailsSent.firstWhere((e) => e.id == email.id).read = true;
      _emailsSent.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsSent(_emailsSent);
    }
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> send(Email email) async {
    final res = await repository.sendEmail(email);
    if (res.error != null) {
      return Response(error: res.error);
    }
    await fetch(online: true);
    return const Response();
  }

  @override
  Future<void> reset({bool offline = false}) async {
    _emailsSent = [];
    _recipients = [];
    _emailsReceived = [];
    _favoriteEmails = [];
    await super.reset(offline: offline);
  }
}
