import 'package:intl/intl.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/usefulMethods.dart';

class HomeworkUtils {
//Homework done percent
  static Future<int> getHomeworkDonePercent() async {
    List list = await getReducedListHomework();
    if (list != null) {
      //Number of elements in list
      int total = list.length;
      if (total == 0) {
        return 100;
      } else {
        int done = 0;

        await Future.forEach(list, (element) async {
          bool isDone = await offline.doneHomework.getHWCompletion(element.id);
          if (isDone) {
            done++;
          }
        });
        print(done);
        int percent = (done * 100 / total).round();

        return percent;
      }
    } else {
      return 100;
    }
  }

  static Future<List<Homework>> getReducedListHomework() async {
    int reduce = await getIntSetting("summaryQuickHomework");
    if (reduce == 11) {
      reduce = 770;
    }
    List<Homework> localList = await localApi.getNextHomework();
    if (localList != null) {
      List<Homework> listToReturn = List<Homework>();
      localList.forEach((element) {
        var now = DateTime.now();
        var date = element.date;

        //ensure that the list doesn't contain the pinned homework
        if (date.difference(now).inDays < reduce &&
            date.isAfter(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.now())))) {
          listToReturn.add(element);
        }
      });
      return listToReturn;
    } else {
      return null;
    }
  }
}
