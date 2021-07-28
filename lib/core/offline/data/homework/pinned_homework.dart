import 'package:intl/intl.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class PinnedHomeworkOffline {
  late Offline parent;
  PinnedHomeworkOffline(Offline _parent) {
    parent = _parent;
  }

  ///Get pinned homework dates
  getPinnedHomeworkDates() async {
    try {
      Map notParsedList = parent.pinnedHomeworkBox!.toMap();
      List<DateTime> parsedList = [];
      notParsedList.removeWhere((key, value) => value == false);
      notParsedList.keys.forEach((element) {
        parsedList.add(DateTime.parse(DateFormat("yyyy-MM-dd").format(DateTime.parse(element))));
      });
      return parsedList;
    } catch (e) {
      CustomLogger.log("PINNED HOMEWORK", "An error occured during the getPinnedHomeworkDateProcess");
      CustomLogger.error(e);
      return [];
    }
  }

  ///Get homework pinned status for a given `date`
  Future<bool?> getPinnedHomeworkSingleDate(String date) async {
    try {
      bool? toReturn = parent.pinnedHomeworkBox!.get(date);

      //If to return is null return false
      return (toReturn != null) ? toReturn : false;
    } catch (e) {
      CustomLogger.log("PINNED HOMEWORK", "An error occured during the getPinnedHomeworkDateProcess");
      CustomLogger.error(e);
      return null;
    }
  }

  ///Set a homework date as pinned (or not)
  void set(String date, bool? value) async {
    try {
      await parent.pinnedHomeworkBox?.put(date, value);
    } catch (e) {
      CustomLogger.log("PINNED HOMEWORK", "An error occured during the setPinnedHomeworkDateProcess");
      CustomLogger.error(e);
    }
  }
}
