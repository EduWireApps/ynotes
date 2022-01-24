part of school_api;

abstract class EmailsModule<R extends EmailsRepository> extends Module<R> {
  EmailsModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.emails,
          isAvailable: api.modulesAvailability.emails,
          repository: repository,
          api: api,
        );

  List<Email> get emailsSent => offline.emails.filter().entityIdEqualTo("").sortByDate().findAllSync();
  List<Email> get emailsReceived => offline.emails.filter().not().entityIdEqualTo("").sortByDate().findAllSync();
  List<Email> get favoriteEmails => offline.emails.filter().favoriteEqualTo(true).sortByDate().findAllSync();
  List<Recipient> get recipients => offline.recipients.where().sortByLastName().findAllSync();

  @override
  Future<Response<void>> fetch() async {
    fetching = true;
    notifyListeners();
    final res = await repository.get();
    if (res.error != null) return res;
    final List<Email> __emailsReceived = res.data!["emailsReceived"] ?? [];
    if (__emailsReceived.length > emailsReceived.length) {
      final List<Email> newEmails = __emailsReceived.sublist(emailsReceived.length);
      // TODO: foreach: trigger notifications
      await offline.writeTxn((isar) async {
        await isar.emails.putAll(newEmails);
      });
    }
    final List<Email> __emailsSent = res.data!["emailsSent"] ?? [];
    if (__emailsSent.length > emailsSent.length) {
      final List<Email> newEmails = __emailsSent.sublist(emailsSent.length);
      await offline.writeTxn((isar) async {
        await isar.emails.putAll(newEmails);
      });
    }
    final List<Recipient> __recipients = res.data!["recipients"] ?? [];
    await offline.writeTxn((isar) async {
      await isar.recipients.clear();
      await isar.recipients.putAll(__recipients);
    });
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> read(Email email) async {
    if (email.content != null) return const Response();
    final bool received = emailsReceived.contains(email);
    final res = await repository.getEmailContent(email, received);
    if (res.error != null) return res;
    email.read = true;
    email.content = res.data!;
    await offline.writeTxn((isar) async {
      await isar.emails.put(email);
    });
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> send(Email email) async {
    final res = await repository.sendEmail(email);
    if (res.error != null) {
      return Response(error: res.error);
    }
    await fetch();
    return const Response();
  }

  @override
  Future<void> reset() async {
    await offline.writeTxn((isar) async {
      await isar.emails.clear();
      await isar.recipients.clear();
    });
    notifyListeners();
  }
}
