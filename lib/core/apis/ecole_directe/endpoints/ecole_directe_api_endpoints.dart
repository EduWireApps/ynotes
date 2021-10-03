import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_endpoints.dart';

class EcoleDirecteApiEndpoints {
  static const String _rootUrl = "https://api.ecoledirecte.com/v3/";
  static final Endpoint workspaces = Endpoint(_rootUrl + "workspaces");
  static final Endpoint login = Endpoint(_rootUrl + "login.awp");
  static Endpoint testToken(String id) => Endpoint(_rootUrl + "eleves/$id/timeline.awp?verbe=get&");
  static Endpoint grades(String id) => Endpoint(_rootUrl + "eleves/$id/notes.awp?verbe=get");
  static Endpoint homeworkFor(String id) => Endpoint(_rootUrl + "Eleves/$id/cahierdetexte/%0.awp?verbe=get&");
  static Endpoint nextHomework(String id) => Endpoint(_rootUrl + "Eleves/$id/cahierdetexte.awp?verbe=get&");
  static Endpoint lessons(String id) => Endpoint(_rootUrl + "E/$id/emploidutemps.awp?verbe=get&");
  static Endpoint mails(String id) => Endpoint(_rootUrl + "eleves/$id/messages.awp?verbe=getall&typeRecuperation=all");
  static final Endpoint recipients = Endpoint(_rootUrl + "messagerie/contacts/professeurs.awp?verbe=get");
  static Endpoint schoolLife(String id) => Endpoint(_rootUrl + "eleves/$id/viescolaire.awp?verbe=get&");

  EcoleDirecteApiEndpoints._();
}
