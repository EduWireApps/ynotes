part of school_api;

class ModulesAvailability {
  bool grades;
  bool schoolLife;
  bool emails;
  bool homework;
  bool documents;

  ModulesAvailability(
      {this.grades = false,
      this.schoolLife = false,
      this.emails = false,
      this.homework = false,
      this.documents = false});
}
