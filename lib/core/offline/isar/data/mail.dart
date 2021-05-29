import 'package:isar/isar.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/isar.g.dart';

class OfflineMail {
  final Isar? isarInstance;
  OfflineMail(this.isarInstance);

  Future<List<Mail>?> getAllMails() async {
    return await isarInstance?.mails.where().findAll();
  }

  Future<void> updateMailContent(String content, String id) async {
    Mail? mail = await isarInstance?.mails.where().filter().idEqualTo(id).findFirst();
    if (mail != null) {
      mail.content = content;
      await isarInstance?.writeTxn((isar) async {
        await isar.mails.put(mail);
      });
    }
  }

  Future<void> updateMails(List<Mail> mails) async {
    await isarInstance?.writeTxn((isar) async {
      // await isar.mails.where().deleteAll();
      //We get all mails we want to update
      final List<Mail>? oldMails = await isarInstance?.mails
          .where()
          .filter()
          .repeat(mails, (q, Mail mail) => q.idEqualTo(mail.id).and().not().contentIsNull())
          .findAll();
      if (oldMails != null) {
        oldMails.forEach((oldMail) {
          mails.forEach((mail) {
            if (mail.id == oldMail.id) {
              //Fields succeptible to be updated (technically mails are immutable but "read" boolean can change)
              oldMail.read = mail.read;
              oldMail.idClasseur = mail.idClasseur;
            }
          });
        });
        mails.removeWhere((mail) => oldMails.any((oldMail) => oldMail.id == mail.id));
        //we put the old mails
        //no need to remove the old ones (Isar will automatically update them)
        await isar.mails.putAll(oldMails);
      }
      //we put the new ones
      await isar.mails.putAll(mails);
    });
  }
}
