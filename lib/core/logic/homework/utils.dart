import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/data/homework/doneHomework.dart';
import 'package:ynotes/globals.dart';

class HomeworkUtils {
  static Future<List<int>> getHomeworkDonePercent() async {
    List? list = await getReducedListHomework();
    if (list != null) {
      //Number of elements in list
      int total = list.length;
      if (total == 0) {
        return [100, 0, 0];
      } else {
        int done = 0;

        await Future.forEach(list, (dynamic element) async {
          bool isDone = await DoneHomeworkOffline(appSys.offline).getHWCompletion(element.id);
          if (isDone) {
            done++;
          }
        });
        int percent = (done * 100 / total).round();

        return [percent, done, list.length];
      }
    } else {
      return [100, 0, 0];
    }
  }

  static Future<List<Homework>?> getReducedListHomework({forceReload = false}) async {
    List<Homework>? localList = await appSys.api?.getNextHomework(forceReload: forceReload);
    return localList;
  }
}
