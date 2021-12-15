part of school_api;

abstract class HomeworkModule<R extends HomeworkRepository> extends Module<R, OfflineHomework> {
  HomeworkModule({required bool isSupported, required bool isAvailable, required R repository, required SchoolApi api})
      : super(
            isSupported: isSupported,
            isAvailable: isAvailable,
            repository: repository,
            api: api,
            offline: OfflineHomework());

  List<Homework> homework = [];
  List<Homework> get pinnedHomework => homework.where((h) => h.pinned).toList();
  Map<DateTime, List<Homework>> get homeworkByDate {
    final Map<DateTime, List<Homework>> map = {};
    for (final h in homework) {
      if (map.containsKey(h.date)) {
        map[h.date]!.add(h);
      } else {
        map[h.date] = [h];
      }
    }
    return map;
  }

  @override
  Future<Response<void>> fetch({bool online = false, DateTime? date}) async {
    fetching = true;
    notifyListeners();
    if (online) {
      if (date == null) {
        final res = await repository.get();
        if (res.error != null) return res;
        final List<Homework> _homework = res.data!["homework"] ?? [];
        final List<String> ids = homework.map((h) => h.id).toList();
        // TODO: check if homework added or removed
        for (final h in _homework) {
          // TODO: check if homework property has changed, except id, content and pinned
          if (!ids.contains(h.id)) {
            homework.add(h);
          }
        }
        await offline.setHomework(homework);
        for (final d in homeworkByDate.keys) {
          final res0 = await fetch(online: true, date: d);
          if (res0.error != null) return res0;
        }
      } else {
        final res = await repository.getDay(date);
        if (res.error != null) return res;
        final List<Homework> _homework = res.data!;
        final List<String> ids = homework.map((h) => h.id).toList();
        for (final h in _homework) {
          if (ids.contains(h.id)) {
            homework.firstWhere((e) => e.id == h.id).content = h.content;
          } else {
            homework.add(h);
          }
        }
        await offline.setHomework(homework);
      }
    } else {
      homework = await offline.getHomework();
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> updateHomework(Homework homework);

  @override
  Future<void> reset({bool offline = false}) async {
    homework = [];
    await super.reset(offline: offline);
  }
}
