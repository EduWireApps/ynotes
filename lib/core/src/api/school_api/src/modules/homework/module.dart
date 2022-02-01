part of school_api;

abstract class HomeworkModule<R extends HomeworkRepository> extends Module<R> {
  HomeworkModule({required R repository, required SchoolApi api})
      : super(
          isSupported: api.modulesSupport.homework,
          isAvailable: api.modulesAvailability.homework,
          repository: repository,
          api: api,
        );

  List<Homework> get homework => offline.homeworks.where().findAllSync();
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
  Future<Response<void>> fetch({DateTime? date}) async {
    fetching = true;
    notifyListeners();
    if (date == null) {
      final res = await repository.get();
      if (res.error != null) return res;
      final List<Homework> __homework = res.data!["homework"] ?? [];
      final List<String> ids = homework.map((h) => h.entityId).toList();
      // TODO: check if homework added or removed
      for (final h in __homework) {
        // TODO: check if homework property has changed, except id, content and pinned
        if (!ids.contains(h.entityId)) {
          await offline.writeTxn((isar) async {
            await isar.homeworks.put(h);
          });
        }
      }
      for (final d in homeworkByDate.keys) {
        final res0 = await fetch(date: d);
        if (res0.error != null) return res0;
      }
    } else {
      final res = await repository.getDay(date);
      if (res.error != null) return res;
      final List<Homework> __homework = res.data!;
      final List<String> ids = homework.map((h) => h.entityId).toList();
      for (final _h in __homework) {
        if (ids.contains(_h.id)) {
          Homework h = homework.firstWhere((e) => e.id == _h.id);
          h.content = _h.content;
          h.documents
            ..clear()
            ..addAll(_h.documents);
        } else {
          await offline.writeTxn((isar) async {
            await isar.homeworks.put(_h);
          });
        }
      }
    }
    fetching = false;
    notifyListeners();
    return const Response();
  }

  Future<Response<void>> updateHomework(List<Homework> h) async {
    return const Response(error: "Not implemented");
  }

  @override
  Future<void> reset() async {
    await offline.writeTxn((isar) async {
      await isar.homeworks.clear();
    });
    notifyListeners();
  }
}
