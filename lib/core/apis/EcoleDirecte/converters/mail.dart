import 'package:ynotes/core/apis/EcoleDirecte/convertersExporter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

class EcoleDirecteMailConverter {
  static Mail mail(Map<String, dynamic> mailData) {
    var to = mailData["to"];
    String id = mailData["id"].toString();
    String messageType = mailData["mtype"] ?? "";
    bool isMailRead = mailData["read"] ?? false;
    String idClasseur = mailData["idClasseur"].toString();
    Map<String, dynamic> from = mailData["from"] ?? "";
    String subject = mailData["subject"] ?? "";
    String date = mailData["date"];
    String loadedContent = "";
    List<Map<String, dynamic>> filesData = mailData["files"].cast<Map<String, dynamic>>();
    List<Document> files = EcoleDirecteDocumentConverter.documents(filesData);
    Mail mail = Mail(
        id: id,
        mtype: messageType,
        read: isMailRead,
        idClasseur: idClasseur,
        from: from,
        subject: subject,
        date: date,
        to: to);
    mail.files.addAll(files);
    return mail;
  }

  static List<Recipient> recipients(var recipientsData) {
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
  }
}
