
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class AgendaEventsOffline {
  late Offline parent;
  AgendaEventsOffline(Offline _parent) {
    parent = _parent;
  }

  ///Update existing agenda events with passed data
  addAgendaEvent(AgendaEvent newData, var id) async {
    try {
      Map<dynamic, dynamic> timeTable = Map();
      var offline = await parent.agendaBox?.get("agendaEvents");
      List<AgendaEvent> events = [];
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("agendaEvents"));
      }
      if (timeTable[id] != null) {
        events.addAll(timeTable[id].cast<AgendaEvent>());
        events.removeWhere((element) => element.id == newData.id);
      }
      events.add(newData);
      //Update the timetable
      timeTable.update(id, (value) => events, ifAbsent: () => events);
      await parent.agendaBox?.put("agendaEvents", timeTable);
      print("Update offline agenda events (id : $id)");
    } catch (e) {
      print("Error while updating offline agenda events " + e.toString());
    }
  }

  Future<List<AgendaEvent>?> getAgendaEvents(int week, {var selector}) async {
    try {
      if (selector == null) {
        return parent.agendaBox?.get("agendaEvents")?[week]?.cast<AgendaEvent>();
      } else {
        return parent.agendaBox?.get("agendaEvents")?[week]?.cast<AgendaEvent>().where(await selector);
      }
    } catch (e) {
      print("Error while returning agenda events for week $week " + e.toString());
      return null;
    }
  }

  ///Remove an agenda event with a given `id` and at a given `week`
  removeAgendaEvent(String? id, var fetchID) async {
    try {
      Map<dynamic, dynamic> timeTable = Map();
      var offline = await parent.agendaBox?.get("agendaEvents");
      List<AgendaEvent> events = [];
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("agendaEvents"));
      }
      if (timeTable[fetchID] != null) {
        events.addAll(timeTable[fetchID].cast<AgendaEvent>());
        events.removeWhere((element) => element.id == id);
        print("Removed offline agenda event (fetchID : $fetchID, id: $id)");
      }
      //Update the timetable
      timeTable.update(fetchID, (value) => events, ifAbsent: () => events);
      await parent.agendaBox?.put("agendaEvents", timeTable);
    } catch (e) {
      print("Error while removing offline agenda events " + e.toString());
    }
  }
}
