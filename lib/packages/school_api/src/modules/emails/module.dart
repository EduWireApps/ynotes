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

  Future<void> addFavoriteEmail(Email email) async {
    favoriteEmails.add(email);
    await offline.setFavoriteEmailsIds(favoriteEmails.map((e) => e.id).toList());
  }

  Future<void> removeFavoriteEmail(Email email) async {
    favoriteEmails.remove(email);
    await offline.setFavoriteEmailsIds(favoriteEmails.map((e) => e.id).toList());
  }

  Future<Response<void>> read(Email email);

  Future<Response<String>> send(Email email);

  @override
  Future<void> reset({bool offline = false}) async {
    emailsSent = [];
    recipients = [];
    emailsReceived = [];
    favoriteEmails = [];
    await super.reset(offline: offline);
  }
}
