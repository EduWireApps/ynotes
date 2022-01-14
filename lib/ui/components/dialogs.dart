import 'dart:core';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/legacy/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/legacy/theme_utils.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/dialogs/authorizations_dialog.dart';
import 'package:ynotes/ui/components/dialogs/color_picker.dart';
import 'package:ynotes/ui/components/dialogs/update_note_dialog.dart';
import 'package:ynotes/ui/screens/agenda/widgets/persistant_notification_dialog.dart';
import 'package:ynotes/ui/screens/grades/widgets/share_grade_dialog.dart';
import 'package:ynotes/ui/screens/homework/widgets/homework_details.dart';

import '../../useful_methods.dart';
import '../screens/agenda/widgets/recurring_events_dialog.dart';
import '../screens/downloads/widgets/folder_choice_dialog.dart';
import '../screens/mailbox/widgets/new_recipient_dialog.dart';
import '../screens/mailbox/widgets/write_mail_bottom_sheet.dart';
import 'dialogs/multiple_choices_dialog.dart';
import 'dialogs/number_choice_dialog.dart';
import 'dialogs/specialties_dialog.dart';
import 'dialogs/text_field_choice_dialog.dart';

class CustomDialogs {
  static showAnyDialog(BuildContext context, String text) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.green.shade200,
      isDismissible: true,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      messageText: Text(
        text,
        style: const TextStyle(fontFamily: "Asap"),
      ),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  static Future<bool?> showAuthorizationsDialog(BuildContext context, String authName, String goal) async {
    // show the dialog
    return await showDialog<bool>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AuthorizationsDialog(
          authName: authName,
          goal: goal,
        );
      },
    );
  }

  static Future<Color?> showColorPicker(BuildContext context, Color defaultColor) {
    // show the dialog
    return showDialog<Color>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomColorPicker(defaultColor: defaultColor);
      },
    );
  }

  static Future<bool?> showConfirmationDialog(BuildContext context, Function? show,
      {String alternativeText = "Voulez vous vraiment supprimer cet élément (irréversible) ?",
      String alternativeButtonConfirmText = "SUPPRIMER"}) {
    // set up the AlertDialog
    var alert = AlertDialog(
      backgroundColor: Theme.of(context).backgroundColor,
      elevation: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text(
        "Confirmation",
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
      ),
      content: Text(
        alternativeText,
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
      ),
      actions: [
        TextButton(
          child: const Text('ANNULER', style: TextStyle(color: Colors.green), textScaleFactor: 1.0),
          onPressed: () {
            if (show != null) {
              show();
            }

            Navigator.pop(context, false);
          },
        ),
        TextButton(
          child: Text(
            alternativeButtonConfirmText.toUpperCase(),
            style: const TextStyle(color: Colors.red),
            textScaleFactor: 1.0,
          ),
          onPressed: () {
            if (show != null) {
              show();
            }
            Navigator.pop(context, true);
          },
        )
      ],
    );

    // show the dialog
    return showDialog<bool?>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  static showErrorSnackBar(BuildContext context, String text, String? logs) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.red,
      isDismissible: true,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(8),
      messageText: Text(
        text,
        style: const TextStyle(fontFamily: "Asap", color: Colors.white),
      ),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      borderRadius: BorderRadius.circular(8),
      mainButton: logs != null
          ? const Text(
              "Copier les logs",
              style: TextStyle(fontFamily: "Asap", color: Colors.blueGrey),
            )
          : null,
    ).show(context);
  }

  static Future<void> showHomeworkDetailsDialog(BuildContext context, Homework? hw) async {
    await showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Container();
        },
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(scale: a1.value, child: DialogHomework(hw));
        });
  }

  static Future showMultipleChoicesDialog(BuildContext context, List choices, List<int> initialSelection,
      {singleChoice = false, label}) {
    // show the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return MultipleChoicesDialog(
          choices,
          initialSelection,
          singleChoice: singleChoice,
          label: label,
        );
      },
    );
  }

  static Future<bool?> showNewFolderDialog(
      BuildContext context, String path, List<FileInfo>? files, bool selectionMode, Function callback) {
    // show the dialog
    return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return FolderChoiceDialog(
          context,
          path,
          selectionMode,
          callback,
          files: files,
        );
      },
    );
  }

//Bêta purposes : show when a function is not available yet
  static showNewRecipientDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const NewRecipientDialog();
        });
  }

  //Bêta purposes : show when a function is not available yet
  static showNumberChoiceDialog(BuildContext context, {String text = "", bool isDouble = false}) {
    // show the dialog
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return NumberChoiceDialog(
          text,
          isDouble: isDouble,
        );
      },
    );
  }

  static Future showPersistantNotificationDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const PersistantNotificationConfigDialog();
      },
    );
  }

  static Future showRecurringEventDialog(BuildContext context, String? scheme) {
    // show the dialog
    return showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return RecurringEventsDialog(scheme);
      },
    );
  }

  static showShareGradeDialog(BuildContext context, Grade grade) {
    return showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: ShareBox(grade)),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  static showSpecialtiesChoice(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return const DialogSpecialties();
        });
  }

  static Future<String?> showTextChoiceDialog(BuildContext context, {String text = "", String? defaultText = ""}) {
    // show the dialog
    return showDialog<String>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return TextFieldChoiceDialog(text, defaultText);
      },
    );
  }

  static showUnimplementedSnackBar(BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.BOTTOM,
      backgroundColor: Colors.orange.shade200,
      isDismissible: true,
      duration: const Duration(seconds: 2),
      margin: const EdgeInsets.all(8),
      messageText: const Text(
        "Cette fonction n'est pas encore disponible pour le moment.",
        style: TextStyle(fontFamily: "Asap"),
      ),
      mainButton: TextButton(
        onPressed: () {
          const url = 'https://view.monday.com/486453658-df7d6a346f0accba2e9d6a3c45b3f7c1';
          launchURL(url);
        },
        child: const Text(
          "En savoir plus",
          style: TextStyle(color: Colors.blue, fontFamily: "Asap"),
        ),
      ),
      borderRadius: BorderRadius.circular(8),
    ).show(context);
  }

  static showUpdateNoteDialog(BuildContext context) {
    return showGeneralDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(opacity: a1.value, child: const UpdateNoteDialog()),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  static Future writeModalBottomSheet(context, {List<Recipient>? defaultListRecipients, defaultSubject}) async {
    var mailData = await showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: const Color(0xffDCDCDC),
        context: context,
        isScrollControlled: true,
        builder: (BuildContext bc) {
          return WriteMailBottomSheet(defaultRecipients: defaultListRecipients, defaultSubject: defaultSubject);
        });
    if (mailData != null) {
      await (appSys.api as APIEcoleDirecte).methods.sendMail(mailData[0], mailData[1], mailData[2]).then((value) {
        Logger.log("DIALOGS", "Mail sent");
        CustomDialogs.showAnyDialog(context, "Le mail a été envoyé.");
      }).catchError((Object error) {
        CustomDialogs.showAnyDialog(context, "Le mail n'a pas été envoyé !");
      });
    }
  }
}
