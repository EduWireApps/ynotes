part of ecole_directe;

class _HomeworkModule extends HomeworkModule<_HomeworkRepository> {
  _HomeworkModule(SchoolApi api, {required bool isSupported, required bool isAvailable})
      : super(isSupported: isSupported, isAvailable: isAvailable, repository: _HomeworkRepository(api), api: api);

  @override
  Future<Response<void>> updateHomework(Homework homework) async {
    // repository.updateHomework(homework);
    return const Response(error: 'Not implemented');
  }
}
