part of ecole_directe;

class _DocumentsModule extends DocumentsModule<_DocumentsRepository> {
  _DocumentsModule(SchoolApi api) : super(repository: _DocumentsRepository(api), api: api);
}
