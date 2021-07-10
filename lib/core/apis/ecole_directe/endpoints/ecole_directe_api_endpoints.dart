import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_endpoints.dart';

class EcoleDirecteApiEndpoints {
  static const String _rootUrl = "https://api.ecoledirecte.com/v3/";
  static final Endpoint workspaces = Endpoint(_rootUrl + "workspaces");
  static final Endpoint login = Endpoint(_rootUrl + "login.awp");
  static final Endpoint testToken = Endpoint(_rootUrl + "eleves/timeline.awp?verbe=get&");
  static final Endpoint grades = Endpoint(_rootUrl + "eleves/grades.awp");
  static final Endpoint homeworkFor = Endpoint(_rootUrl + "Eleves/cahierdetexte/%0.awp?verbe=get&");
  static final Endpoint nextHomework = Endpoint(_rootUrl + "Eleves/cahierdetexte.awp?verbe=get&");
  static final Endpoint lessons = Endpoint(_rootUrl + "E/emploidutemps.awp?verbe=get&");
  static final Endpoint mails = Endpoint(_rootUrl + "eleves/messages.awp?verbe=getall&typeRecuperation=all");
  static final Endpoint recipients = Endpoint(_rootUrl + "messagerie/contacts/professeurs.awp?verbe=get");
  static final Endpoint schoolLife = Endpoint(_rootUrl + "eleves/viescolaire.awp?verbe=get&");

  EcoleDirecteApiEndpoints._();
}
