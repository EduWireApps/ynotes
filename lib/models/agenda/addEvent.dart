import 'package:ynotes/UI/components/modalBottomSheets/agendaEventEditBottomSheet.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/notifications.dart';

import '../../UI/screens/agenda/agendaPage.dart';

addEvent(context) async {
  AgendaEvent temp = await agendaEventEdit(context, true, defaultDate: agendaDate);
  if (temp != null) {
    print(temp.recurrenceScheme);
    if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
      await offline.agendaEvents.addAgendaEvent(temp, temp.recurrenceScheme);
    } else {
      await offline.agendaEvents.addAgendaEvent(temp, await get_week(temp.start));
    }
    await AppNotification.scheduleAgendaReminders(temp);
  }
}
