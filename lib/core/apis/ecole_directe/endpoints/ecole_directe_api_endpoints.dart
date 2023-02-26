import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_endpoints.dart';

class EcoleDirecteApiEndpoints {
  static const String _rootUrl = "https://api.ecoledirecte.com/v3/";
  static const String particle = "v=4.27.1";
  static final Endpoint workspaces = Endpoint(_rootUrl + "workspaces");
  static final Endpoint login = Endpoint(_rootUrl + "login.awp?" + particle);
  static final Endpoint recipients = Endpoint(_rootUrl + "messagerie/contacts/professeurs.awp?verbe=get&" + particle);
  EcoleDirecteApiEndpoints._();
  static Endpoint grades(String id) => Endpoint(_rootUrl + "eleves/$id/notes.awp?verbe=get&" + particle);
  static Endpoint homeworkFor(String id) =>
      Endpoint(_rootUrl + "Eleves/$id/cahierdetexte/%0.awp?verbe=get&" + particle);
  static Endpoint lessons(String id) => Endpoint(_rootUrl + "E/$id/emploidutemps.awp?verbe=get&" + particle);
  static Endpoint mails(String id) =>
      Endpoint(_rootUrl + "eleves/$id/messages.awp?verbe=getall&typeRecuperation=all&" + particle);
  static Endpoint nextHomework(String id) => Endpoint(_rootUrl + "Eleves/$id/cahierdetexte.awp?verbe=get&" + particle);
  static Endpoint schoolLife(String id) => Endpoint(_rootUrl + "eleves/$id/viescolaire.awp?verbe=get&" + particle);

  static Endpoint testToken(String id) => Endpoint(_rootUrl + "eleves/$id/timeline.awp?verbe=get&" + particle);
}
