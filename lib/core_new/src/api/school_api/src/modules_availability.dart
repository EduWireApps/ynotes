part of school_api;

class ModulesAvailability {
  bool grades;
  bool schoolLife;
  bool emails;
  bool homework;
  bool get documents => emails || homework;

  ModulesAvailability({this.grades = false, this.schoolLife = false, this.emails = false, this.homework = false});

  static const String _offlineKey = "modulesAvailability";

  Future<void> load() async {
    final String? data = await KVS.read(key: _offlineKey);
    if (data == null) {
      await save();
      return;
    }
    final Map<String, dynamic> decoded = json.decode(data);
    grades = decoded["grades"] as bool;
    schoolLife = decoded["schoolLife"] as bool;
    emails = decoded["emails"] as bool;
    homework = decoded["homework"] as bool;
  }

  Future<void> save() async {
    await KVS.write(
        key: _offlineKey,
        value: json.encode({
          "grades": grades,
          "schoolLife": schoolLife,
          "emails": emails,
          "homework": homework,
        }));
  }
}
