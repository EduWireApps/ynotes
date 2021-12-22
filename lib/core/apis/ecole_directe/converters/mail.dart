import 'package:ynotes/core/apis/ecole_directe/converters_exporter.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class EcoleDirecteMailConverter {
  static API_TYPE apiType = API_TYPE.ecoleDirecte;

  static YConverter mail = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> mailData) {
        List<Map<String, dynamic>> to = mailData["to"].cast<Map<String, dynamic>>();
        String id = mailData["id"].toString();
        String messageType = mailData["mtype"] ?? "";
        bool isMailRead = mailData["read"] ?? false;
        String idClasseur = mailData["idClasseur"].toString();
        Map<String, dynamic> from = mailData["from"] ?? "";
        String subject = mailData["subject"] ?? "";
        String date = mailData["date"];
        List<Map<String, dynamic>> filesData = mailData["files"].cast<Map<String, dynamic>>();
        List<Document> _files = EcoleDirecteDocumentConverter.documents.convert(filesData);
        Mail mail = Mail(
            id: id,
            mtype: messageType,
            read: isMailRead,
            idClasseur: idClasseur,
            from: from,
            subject: subject,
            date: date,
            to: to);
        mail.files.addAll(_files);
        return mail;
      });

  static YConverter mails = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> mailData) {
        List rawMailsList = [];
        List<Mail> mails = [];
        Map rawMails = mailData['data']['messages'];
        rawMails.forEach((key, value) {
          //We finally get in message items
          value.forEach((e) {
            rawMailsList.add(e);
          });
        });
        for (var element in rawMailsList) {
          Map<String, dynamic> mailData = element;
          mails.add(EcoleDirecteMailConverter.mail.convert(mailData));
        }
        return mails;
      });
  static YConverter recipients = YConverter(
      apiType: apiType,
      converter: (Map<dynamic, dynamic> recipientsData) {
        List<Recipient> recipients = [];
        recipientsData["data"]["contacts"].forEach((recipientData) {
          String id = recipientData["id"].toString();
          String name = recipientData["prenom"].toString();
          bool isTeacher = recipientData["type"] == "P";
          String surname = recipientData["nom"].toString();
          String discipline = recipientData["classes"][0]["matiere"].toString();
          recipients.add(Recipient(name, surname, id, isTeacher, discipline));
        });
        return recipients;
      });
}
