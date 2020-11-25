import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/notifications.dart';

import '../../../main.dart';
import '../agendaPage.dart';
import 'agenda.dart';

addEvent(context) async {
  AgendaEvent temp = await agendaEventEdit(context, true, defaultDate: agendaDate);
  if (temp != null) {
    print(temp.recurrenceScheme);
    if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
      await offline.addAgendaEvent(temp, temp.recurrenceScheme);
    } else {
      await offline.addAgendaEvent(temp, await get_week(temp.start));
    }
    await LocalNotification.scheduleAgendaReminders(temp);
  }
}
