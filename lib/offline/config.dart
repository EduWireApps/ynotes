import 'package:ynotes/classes.dart';
import 'package:ynotes/offline/configPattern.dart';



//store all data
List<OfflineConfig> configList = [
  OfflineConfig(name: "homework", type: Homework, wrappingType: List, storedType: List, keepOldData: false, adapters: [HomeworkAdapter(), DocumentAdapter()]),
  OfflineConfig(name: "grades", type: Homework, wrappingType: List, storedType: List, keepOldData: false, adapters: [DisciplineAdapter(), GradeAdapter()]),
  OfflineConfig(name: "doneHomework", type: bool, storedType: Map, keepOldData: true, getter: String),
  OfflineConfig(name: "polls", type: PollInfo, wrappingType: List, storedType: List, keepOldData: false, adapters: [PollInfoAdapter()]),
  OfflineConfig(name: "lessons", type: Lesson, wrappingType: List, storedType: Map, keepOldData: true, adapters: [LessonAdapter()]),
  OfflineConfig(name: "agendaEvents", type: AgendaEvent, wrappingType: List, storedType: Map, keepOldData: true, adapters: [AgendaEventAdapter()]),
  OfflineConfig(name: "agendaReminders", type: AgendaReminder, wrappingType: List, storedType: Map, keepOldData: true, adapters: [AgendaReminderAdapter()]),
];
