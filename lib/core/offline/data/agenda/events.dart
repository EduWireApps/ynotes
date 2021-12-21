import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class AgendaEventsOffline {
  late Offline parent;
  AgendaEventsOffline(Offline _parent) {
    parent = _parent;
  }

  ///Update existing agenda events with passed data
  addAgendaEvent(AgendaEvent newData, var id) async {
    try {
      Map<dynamic, dynamic> timeTable = {};
      var offline = await parent.agendaBox?.get("agendaEvents");
      List<AgendaEvent> events = [];
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("agendaEvents"));
      }
      CustomLogger.log("EVENTS", "Timetable: $timeTable");
      if (timeTable[id] != null) {
        events.addAll(timeTable[id].cast<AgendaEvent>());
        events.removeWhere((element) => element.id == newData.id);
      }
      events.add(newData);
      //Update the timetable
      timeTable.update(id, (value) => events, ifAbsent: () => events);
      await parent.agendaBox?.put("agendaEvents", timeTable);
      CustomLogger.log("EVENTS", "Update offline agenda events (id : $id)");
    } catch (e) {
      CustomLogger.log("EVENTS", "An error occured while updating offline agenda events");
      CustomLogger.error(e, stackHint:"MzI=");
    }
  }

  Future<List<AgendaEvent>?> getAgendaEvents(int week, {var selector}) async {
    try {
      if (selector == null) {
        return parent.agendaBox?.get("agendaEvents")?[week]?.cast<AgendaEvent>();
      } else {
        return parent.agendaBox?.get("agendaEvents")?[week]?.cast<AgendaEvent>().where(await selector).toList();
      }
    } catch (e) {
      CustomLogger.log("EVENTS", "An error occured while returning agenda events for week $week");
      CustomLogger.error(e, stackHint:"MzM=");
      return null;
    }
  }

  ///Remove an agenda event with a given `id` and at a given `week`
  removeAgendaEvent(String? id, var fetchID) async {
    try {
      Map<dynamic, dynamic> timeTable = {};
      var offline = await parent.agendaBox?.get("agendaEvents");
      List<AgendaEvent> events = [];
      if (offline != null) {
        timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox?.get("agendaEvents"));
      }
      if (timeTable[fetchID] != null) {
        events.addAll(timeTable[fetchID].cast<AgendaEvent>());
        events.removeWhere((element) => element.id == id);
        CustomLogger.log("EVENTS", "Removed offline agenda event (fetchID : $fetchID, id: $id)");
      }
      //Update the timetable
      timeTable.update(fetchID, (value) => events, ifAbsent: () => events);
      await parent.agendaBox?.put("agendaEvents", timeTable);
    } catch (e) {
      CustomLogger.log("EVENTS", "An error occured while removing offline agenda events");
      CustomLogger.error(e, stackHint:"MzQ=");
    }
  }
}
