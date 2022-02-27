part of school_api;

// TODO: provide default modules returning "Not implemented" or smtg like that

abstract class SchoolApiModules {
  late AuthModule authModule;

  late GradesModule gradesModule;

  late SchoolLifeModule schoolLifeModule;

  late EmailsModule emailsModule;

  late HomeworkModule homeworkModule;

  late DocumentsModule documentsModule;
}
