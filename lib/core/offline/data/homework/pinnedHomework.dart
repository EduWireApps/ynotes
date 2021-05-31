import 'package:intl/intl.dart';
import 'package:ynotes/core/offline/offline.dart';

class PinnedHomeworkOffline extends Offline {
  late Offline parent;
  PinnedHomeworkOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }

  ///Set a homework date as pinned (or not)
  void set(String date, bool? value) async {
    if (!locked) {
      try {
        parent.pinnedHomeworkBox!.put(date, value);
      } catch (e) {
        print("Error during the setPinnedHomeworkDateProcess $e");
      }
    }
  }

  ///Get pinned homework dates
  getPinnedHomeworkDates() async {
    try {
      Map notParsedList = parent.pinnedHomeworkBox!.toMap();
      List<DateTime> parsedList = [];
      notParsedList.removeWhere((key, value) => value == false);
      notParsedList.keys.forEach((element) {
        parsedList.add(DateTime.parse(
            DateFormat("yyyy-MM-dd").format(DateTime.parse(element))));
      });
      return parsedList;
    } catch (e) {
      print("Error during the getPinnedHomeworkDateProcess $e");
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
      print("Error during the getPinnedHomeworkProcess $e");

      return null;
    }
  }
}
