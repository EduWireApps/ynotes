part of ecole_directe;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _EmailsRepository(api), api: api);

  @override
  Future<Response<String>> send(Email email) async {
    final res = await repository.sendEmail(email);
    if (res.error != null) {
      return Response(error: res.error);
    }
    await fetch(online: true);
    return const Response(data: "Email sent");
  }

  @override
  Future<Response<void>> read(Email email) async {
    if (email.content != null) return const Response();
    final bool received = emailsReceived.contains(email);
    final res = await repository.getEmailContent(email, received);
    if (res.error != null) return res;
    if (received) {
      emailsReceived.firstWhere((e) => e.id == email.id).read = true;
      emailsReceived.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsReceived(emailsReceived);
    } else {
      emailsSent.firstWhere((e) => e.id == email.id).read = true;
      emailsSent.firstWhere((e) => e.id == email.id).content = res.data!;
      offline.setEmailsSent(emailsSent);
    }
    notifyListeners();
    return const Response();
  }
}
