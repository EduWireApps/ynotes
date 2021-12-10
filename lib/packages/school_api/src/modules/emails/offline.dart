part of school_api;

class OfflineEmails extends OfflineModel {
  OfflineEmails() : super("emails");

  static const String _emailsReceivedKey = "emailsReceived";
  static const String _emailsSentKey = "emailsSent";
  static const String _favoriteEmailsKey = "favoriteEmails";
  static const String _recipientsKey = "recipients";

  Future<List<Email>> getEmailsReceived() async {
    return (box?.get(_emailsReceivedKey) as List<dynamic>?)?.map<Email>((e) => e).toList() ?? [];
  }

  Future<void> setEmailsReceived(List<Email> emails) async {
    await box?.put(_emailsReceivedKey, emails);
  }

  Future<List<Email>> getEmailsSent() async {
    return (box?.get(_emailsSentKey) as List<dynamic>?)?.map<Email>((e) => e).toList() ?? [];
  }

  Future<void> setEmailsSent(List<Email> emails) async {
    await box?.put(_emailsSentKey, emails);
  }

  Future<List<Email>> getFavoriteEmails() async {
    return (box?.get(_favoriteEmailsKey) as List<dynamic>?)?.map<Email>((e) => e).toList() ?? [];
  }

  Future<void> setFavoriteEmails(List<Email> emails) async {
    await box?.put(_favoriteEmailsKey, emails);
  }

  Future<List<Recipient>> getRecipients() async {
    return (box?.get(_recipientsKey) as List<dynamic>?)?.map<Recipient>((e) => e).toList() ?? [];
  }

  Future<void> setRecipients(List<Recipient> recipients) async {
    await box?.put(_recipientsKey, recipients);
  }
}
