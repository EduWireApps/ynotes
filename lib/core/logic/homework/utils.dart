import 'package:ynotes/core/logic/modelsExporter.dart';
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
          bool isDone = await appSys.offline!.doneHomework.getHWCompletion(element.id);
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
    int? reduce = await appSys.settings!["user"]["summaryPage"]["summaryQuickHomework"];
    if (reduce == 11) {
      reduce = 770;
    }
    List<Homework> localList = await appSys.api!.getNextHomework(forceReload: forceReload);
    if (localList != null) {
      List<Homework> listToReturn = [];
      localList.forEach((element) {
        var now = DateTime.now();
        var date = element.date!;

        //ensure that the list doesn't contain the pinned homework
        if (date.difference(now).inDays < reduce!) {
          listToReturn.add(element);
        }
      });
      return listToReturn;
    } else {
      return null;
    }
  }
}
