part of pronote;

class _EmailsModule extends EmailsModule<_EmailsRepository> {
  _EmailsModule(SchoolApi api) : super(repository: _EmailsRepository(api), api: api);
}

class _EmailsProvider extends Provider {
  _EmailsProvider(SchoolApi api) : super(api);
}

class _EmailsRepository extends EmailsRepository {
  @protected
  late final _EmailsProvider emailsProvider = _EmailsProvider(api);

  _EmailsRepository(SchoolApi api) : super(api);

  @override
  Future<Response<Map<String, dynamic>>> get() async {
    return const Response(error: "Not implemented");
  }

  @override
  Future<Response<String>> getEmailContent(Email email, bool received) async {
    return const Response(error: "Not implemented");
  }

  @override
  Future<Response<void>> sendEmail(Email email) async {
    return const Response(error: "Not implemented");
  }
}
