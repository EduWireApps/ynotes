part of ecole_directe;

class _HomeworkModule extends HomeworkModule<_HomeworkRepository> {
  _HomeworkModule(SchoolApi api) : super(repository: _HomeworkRepository(api), api: api);
}
