import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/data/agenda/events.dart';
import 'package:ynotes/core/services/notifications.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/screens/agenda/agenda.dart';
import 'package:ynotes/ui/screens/agenda/widgets/agenda_event_edit_bottom_sheet.dart';

addEvent(context) async {
  AgendaEvent? temp = (await (agendaEventEdit(context, true, defaultDate: agendaDate))) as AgendaEvent?;
  if (temp != null) {
    CustomLogger.log("AGENDA", "(Add event) Recurrence scheme: ${temp.recurrenceScheme}");
    if (temp.recurrenceScheme != null && temp.recurrenceScheme != "0") {
      await AgendaEventsOffline(appSys.offline).addAgendaEvent(temp, temp.recurrenceScheme);
    } else {
      await AgendaEventsOffline(appSys.offline).addAgendaEvent(temp, await getWeek(temp.start!));
    }
    await AppNotification.scheduleAgendaReminders(temp);
  }
}
