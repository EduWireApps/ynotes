part of school_api;

abstract class GradesModule<R extends Repository> extends Module<R, OfflineGrades> {
  GradesModule({required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(
            isSupported: isSupported,
            isAvailable: isAvailable,
            repository: repository,
            api: api,
            offline: OfflineGrades());

  List<Grade> grades = [];
  List<Period> periods = [];
  List<Subject> subjects = [];
  Period? currentPeriod;
  List<SubjectsFilter> filters = [];
  bool simulating = false;

  // TODO: calculate method

  @override
  Future<void> reset({bool offline = false}) async {
    grades = [];
    periods = [];
    subjects = [];
    filters = [];
    currentPeriod = null;
    simulating = false;
    await super.reset(offline: offline);
  }
}

/* 
Things to do:
- current period. Saved to offline or KVS
- handle simulation. basically a boolean in a grade
- handle custom grades.
- handle custom subjects.
- handle filters
- handle averages calculations
- handle offline
*/