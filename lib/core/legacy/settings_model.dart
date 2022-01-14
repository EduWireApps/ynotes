class AgendaPageSettings {
  bool lighteningOverride;
  bool agendaOnGoingNotification;
  bool reverseWeekNames;
  int lessonReminderDelay;
  bool enableDNDWhenOnGoingNotifEnabled;
  bool disableAtDayEnd;

  AgendaPageSettings({
    required this.lighteningOverride,
    required this.agendaOnGoingNotification,
    required this.reverseWeekNames,
    required this.lessonReminderDelay,
    required this.enableDNDWhenOnGoingNotifEnabled,
    required this.disableAtDayEnd,
  });

  factory AgendaPageSettings.fromJson(Map<String, dynamic> json) => AgendaPageSettings(
        lighteningOverride: (json['lighteningOverride'] as bool?) ?? false,
        agendaOnGoingNotification: (json['agendaOnGoingNotification'] as bool?) ?? false,
        reverseWeekNames: (json['reverseWeekNames'] as bool?) ?? false,
        lessonReminderDelay: (json['lessonReminderDelay'] as int?) ?? 5,
        enableDNDWhenOnGoingNotifEnabled: (json['enableDNDWhenOnGoingNotifEnabled'] as bool?) ?? false,
        disableAtDayEnd: (json['disableAtDayEnd'] as bool?) == false,
      );

  Map<String, Object> toJson() => {
        'lighteningOverride': lighteningOverride,
        'agendaOnGoingNotification': agendaOnGoingNotification,
        'reverseWeekNames': reverseWeekNames,
        'lessonReminderDelay': lessonReminderDelay,
        'enableDNDWhenOnGoingNotifEnabled': enableDNDWhenOnGoingNotifEnabled,
        'disableAtDayEnd': disableAtDayEnd,
      };
}

@Deprecated("Use SettingsService for any settings related action.")
class FormSettings {
  SystemSettings system;
  UserSettings user;

  FormSettings({
    required this.system,
    required this.user,
  });

  factory FormSettings.fromJson(Map<String, dynamic> json) => FormSettings(
        system: SystemSettings.fromJson(
          json['system'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        user: UserSettings.fromJson(
          json['user'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
      );
  Map<String, Object> toJson() => {
        'system': system.toJson(),
        'user': user.toJson(),
      };
}

class GlobalUserSettings {
  bool nightmode;
  String theme;
  bool batterySaver;
  bool notificationNewMail;
  bool notificationNewGrade;
  bool shakeToReport;
  bool autoCloseDrawer;

  GlobalUserSettings({
    required this.nightmode,
    required this.theme,
    required this.batterySaver,
    required this.notificationNewMail,
    required this.notificationNewGrade,
    required this.shakeToReport,
    required this.autoCloseDrawer,
  });

  factory GlobalUserSettings.fromJson(Map<String, dynamic> json) => GlobalUserSettings(
        nightmode: (json['nightmode'] as bool?) ?? false,
        theme: (json['theme'] as String?) ?? 'clair',
        batterySaver: (json['batterySaver'] as bool?) ?? false,
        notificationNewMail: (json['notificationNewMail'] as bool?) ?? false,
        notificationNewGrade: (json['notificationNewGrade'] as bool?) ?? false,
        shakeToReport: (json['shakeToReport'] as bool?) ?? false,
        autoCloseDrawer: (json['autoCloseDrawer'] as bool?) ?? false,
      );

  Map<String, Object> toJson() => {
        'nightmode': nightmode,
        'theme': theme,
        'batterySaver': batterySaver,
        'notificationNewMail': notificationNewMail,
        'notificationNewGrade': notificationNewGrade,
        'shakeToReport': shakeToReport,
        'autoCloseDrawer': autoCloseDrawer,
      };
}

class HomeworkPageSettings {
  bool isExpandedByDefault;
  bool forceMonochromeContent;
  int fontSize;
  int pageColorVariant;
  String customDisciplinesList;

  HomeworkPageSettings({
    required this.isExpandedByDefault,
    required this.forceMonochromeContent,
    required this.fontSize,
    required this.pageColorVariant,
    required this.customDisciplinesList,
  });

  factory HomeworkPageSettings.fromJson(Map<String, dynamic> json) => HomeworkPageSettings(
        isExpandedByDefault: (json['isExpandedByDefault'] as bool?) ?? false,
        forceMonochromeContent: (json['forceMonochromeContent'] as bool?) ?? false,
        fontSize: (json['fontSize'] as int?) ?? 20,
        pageColorVariant: (json['pageColorVariant'] as int?) ?? 0,
        customDisciplinesList: (json['customDisciplinesList'] as String?) ?? '[]',
      );

  Map<String, Object> toJson() => {
        'isExpandedByDefault': isExpandedByDefault,
        'forceMonochromeContent': forceMonochromeContent,
        'fontSize': fontSize,
        'pageColorVariant': pageColorVariant,
        'customDisciplinesList': customDisciplinesList,
      };
}

class SummaryPageSettings {
  int summaryQuickHomework;

  SummaryPageSettings({
    required this.summaryQuickHomework,
  });

  factory SummaryPageSettings.fromJson(Map<String, dynamic> json) => SummaryPageSettings(
        summaryQuickHomework: (json['summaryQuickHomework'] as int?) ?? 11,
      );

  Map<String, Object> toJson() => {
        'summaryQuickHomework': summaryQuickHomework,
      };
}

class SystemSettings {
  bool firstUse;
  String lastReadUpdateNote;
  int chosenParser;
  int lastMailCount;
  int lastGradeCount;
  bool migratedHW;
  int accountIndex;
  String? uuid;
  int? lastFetchDate;

  SystemSettings(
      {required this.firstUse,
      required this.lastReadUpdateNote,
      required this.chosenParser,
      required this.lastMailCount,
      required this.lastGradeCount,
      required this.migratedHW,
      required this.accountIndex,
      required this.uuid,
      required this.lastFetchDate});

  factory SystemSettings.fromJson(Map<String, dynamic> json) => SystemSettings(
      firstUse: (json['firstUse'] as bool?) ?? false,
      lastReadUpdateNote: (json['lastReadUpdateNote'] as String?) ?? '',
      chosenParser: (json['chosenParser'] as int?) ?? 0,
      lastMailCount: (json['lastMailCount'] as int?) ?? 0,
      lastGradeCount: (json['lastGradeCount'] as int?) ?? 0,
      migratedHW: (json['migratedHW'] as bool?) ?? false,
      accountIndex: (json['accountIndex'] as int?) ?? 0,
      uuid: (json['uuid'] as String?),
      lastFetchDate: (json['lastFetchDate'] as int?));

  Map<String, Object?> toJson() => {
        'firstUse': firstUse,
        'lastReadUpdateNote': lastReadUpdateNote,
        'chosenParser': chosenParser,
        'lastMailCount': lastMailCount,
        'lastGradeCount': lastGradeCount,
        'migratedHW': migratedHW,
        'accountIndex': accountIndex,
        'lastFetchDate': lastFetchDate,
        'uuid': uuid,
      };
}

class UserSettings {
  GlobalUserSettings global;
  SummaryPageSettings summaryPage;
  HomeworkPageSettings homeworkPage;
  AgendaPageSettings agendaPage;

  UserSettings({
    required this.global,
    required this.summaryPage,
    required this.homeworkPage,
    required this.agendaPage,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) => UserSettings(
        global: GlobalUserSettings.fromJson(
          json['global'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        summaryPage: SummaryPageSettings.fromJson(
          json['summaryPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        homeworkPage: HomeworkPageSettings.fromJson(
          json['homeworkPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
        agendaPage: AgendaPageSettings.fromJson(
          json['agendaPage'] as Map<String, dynamic>? ?? <String, dynamic>{},
        ),
      );

  Map<String, Object> toJson() => {
        'global': global,
        'summaryPage': summaryPage,
        'homeworkPage': homeworkPage,
        'agendaPage': agendaPage,
      };
}
