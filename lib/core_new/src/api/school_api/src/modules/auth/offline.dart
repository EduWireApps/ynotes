part of school_api;

class OfflineAuth extends OfflineModel {
  OfflineAuth() : super('auth');

  static const String _accountKey = "account";
  static const String _schoolAccountKey = "schoolAccount";

  Future<AppAccount?> getAccount() async {
    return box?.get(_accountKey) as AppAccount?;
  }

  Future<void> setAccount(AppAccount? account) async {
    await box?.put(_accountKey, account);
  }

  Future<SchoolAccount?> getSchoolAccount() async {
    return box?.get(_schoolAccountKey) as SchoolAccount?;
  }

  Future<void> setSchoolAccount(SchoolAccount? account) async {
    await box?.put(_schoolAccountKey, account);
  }
}
