part of school_api;

class ModulesAvailability {
  final bool grades;
  final bool schoolLife;
  final bool emails;
  final bool homework;
  final bool documents;

  ModulesAvailability(
      {this.grades = false,
      this.schoolLife = false,
      this.emails = false,
      this.homework = false,
      this.documents = false});
}
