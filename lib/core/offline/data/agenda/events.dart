import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/offline.dart';

class AgendaEventsOffline extends Offline {
  Offline parent;
  AgendaEventsOffline(bool locked, Offline _parent) : super(locked) {
    parent = _parent;
  }

  Future<List<AgendaEvent>> getAgendaEvents(int week, {var selector}) async {
    try {
      if (selector == null) {
        if (parent.agendaEventsData != null && parent.agendaEventsData[week] != null) {
          List<AgendaEvent> agendaEvents = List();
          agendaEvents.addAll(parent.agendaEventsData[week].cast<AgendaEvent>());
          return agendaEvents;
        } else {
          await parent.refreshData();
          if (parent.agendaEventsData != null && parent.agendaEventsData[week] != null) {
            List<AgendaEvent> agendaEvents = List();
            agendaEvents.addAll(parent.agendaEventsData[week].cast<AgendaEvent>());
            return agendaEvents;
          } else {
            return null;
          }
        }
      } else {
        if (parent.agendaEventsData != null) {
          var values = parent.agendaEventsData.keys;
          var selectedValues = values.where(await selector);
          if (selectedValues != null) {
            List<AgendaEvent> agendaEvents = List();

            selectedValues.forEach((element) {
              agendaEvents.addAll(parent.agendaEventsData[element].cast<AgendaEvent>());
              print(agendaEvents);
            });
            return agendaEvents;
          } else {
            return null;
          }
        } else {
          await parent.refreshData();
          if (parent.agendaEventsData != null) {
            var values = parent.agendaEventsData.keys;
            var selectedValues = values.where(await selector);
            if (selectedValues != null) {
              List<AgendaEvent> agendaEvents = List();

              selectedValues.forEach((element) {
                agendaEvents.addAll(parent.agendaEventsData[element].cast<AgendaEvent>());
              });
              return agendaEvents;
            }
          } else {
            return null;
          }
        }
      }
    } catch (e) {
      print("Error while returning agenda events for week $week " + e.toString());
      return null;
    }
  }

  ///Remove an agenda event with a given `id` and at a given `week`
  removeAgendaEvent(String id, var fetchID) async {
    if (!locked) {
      try {
        Map<dynamic, dynamic> timeTable = Map();
        var offline = await parent.agendaBox.get("agendaEvents");
        List<AgendaEvent> events = List();
        if (offline != null) {
          timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox.get("agendaEvents"));
        }
        if (timeTable == null) {
          timeTable = Map();
        } else {
          if (timeTable[fetchID] != null) {
            events.addAll(timeTable[fetchID].cast<AgendaEvent>());
            events.removeWhere((element) => element.id == id);
            print("Removed offline agenda event (fetchID : $fetchID, id: $id)");
          }
        }
        //Update the timetable
        timeTable.update(fetchID, (value) => events, ifAbsent: () => events);
        await parent.agendaBox.put("agendaEvents", timeTable);
        await parent.refreshData();
      } catch (e) {
        print("Error while removing offline agenda events " + e.toString());
      }
    }
  }

  ///Update existing agenda events with passed data
  addAgendaEvent(AgendaEvent newData, var id) async {
    if (!locked) {
      try {
        if (newData != null) {
          Map<dynamic, dynamic> timeTable = Map();
          var offline = await parent.agendaBox.get("agendaEvents");
          List<AgendaEvent> events = List();
          if (offline != null) {
            timeTable = Map<dynamic, dynamic>.from(await parent.agendaBox.get("agendaEvents"));
          }
          if (timeTable == null) {
            timeTable = Map();
          } else {
            if (timeTable[id] != null) {
              events.addAll(timeTable[id].cast<AgendaEvent>());
              events.removeWhere((element) => element.id == newData.id);
            }
          }
          events.add(newData);
          //Update the timetable
          timeTable.update(id, (value) => events, ifAbsent: () => events);
          await parent.agendaBox.put("agendaEvents", timeTable);
          await parent.refreshData();
        }
        print("Update offline agenda events (id : $id)");
      } catch (e) {
        print("Error while updating offline agenda events " + e.toString());
      }
    }
  }
}
