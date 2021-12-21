import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/offline/offline.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';

class MailsOffline {
  late Offline parent;
  MailsOffline(Offline _parent) {
    parent = _parent;
  }
  Future<List<Mail>?> getAllMails() async {
    try {
      return parent.mailsBox?.values.toList();
    } catch (e) {
      CustomLogger.log("MAILS", "An error occured while returning mail");
      CustomLogger.error(e, stackHint:"NTU=");
      return null;
    }
  }

  Future<void> updateMailContent(String content, String id) async {
    Mail? mail = parent.mailsBox?.values.toList().firstWhere((element) => element.id == id);
    if (mail != null) {
      mail.content = content;
      mail.read = true;
      await mail.save();
    }
  }

  ///Update existing mails with passed data
  updateMails(List<Mail> mails) async {
    CustomLogger.log("MAILS", "Update offline mails");
    try {
      List<Mail>? oldMails = [];
      if (parent.mailsBox?.values != null) {
        oldMails = await getAllMails();
      }
      if (oldMails != null) {
        await Future.forEach(oldMails, (Mail oldMail) async {
          await Future.forEach(mails, (Mail mail) async {
            if (mail.id == oldMail.id) {
              //Fields succeptible to be updated (technically mails are immutable but "read" boolean can change)
              oldMail.read = mail.read;
              oldMail.idClasseur = mail.idClasseur;
              oldMail.files = mail.files;
              await oldMail.save();
            }
          });
        });
      }
      final old = (parent.mailsBox?.values.toList().cast<Mail>())
          ?.where((oldMail) => mails.any((newMail) => newMail.id == oldMail.id));
      if (old != null) {
        mails.removeWhere((newMail) => old.any((oldMail) => oldMail.id == newMail.id));
        CustomLogger.log("MAILS", "Mails length: ${mails.length}");
      }
      await parent.mailsBox?.addAll(mails);
    } catch (e) {
      CustomLogger.log("MAILS", "An error occured while updating mail");
      CustomLogger.error(e, stackHint:"NTY=");
    }
  }
}
