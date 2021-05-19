import 'package:ynotes/core/offline/offline.dart';

class Example {}

class ExampleOffline extends Offline {
  late Offline parent;

  //Locked bool is often useless but add it if you don't want your class to be collected
  //in isolates.
  ExampleOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }

  //A really simple get example
  Future<List<Example>?> get() async {
    /*
    try {
      //If cache is not empty return from cache
      if (parent.exampleData != null) {
        //Commented because schoo
        //return parent.exampleData;//
      } else {
        //Else, refresh data (query the DB)
        await refreshData();
        //return parent.exampleData!.cast<Example>();
      }
    } catch (e) {
      //Something happened :(
      print("Error while returning example " + e.toString());
      return null;
    }
    */
  }

  ///Update existing examples objects (clear old data) with passed data

  update(List<Example>? newData) async {
    /*
    if (!locked) {
      print("Update examples (length : ${newData!.length})");
      try {
        //IMPORTANT :
        //Here we are using `offlineBox` and the `example` key
        await parent.offlineBox!.delete("example");
        await parent.offlineBox!.put("example", newData);
        //refresh cached data
        await parent.refreshData();
      } catch (e) {
        print("Error while updating examples " + e.toString());
      }
    }
    */
  }
}
