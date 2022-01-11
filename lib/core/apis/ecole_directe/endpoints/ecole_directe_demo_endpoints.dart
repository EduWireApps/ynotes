import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_endpoints.dart';

class EcoleDirecteDemoEndpoints {
  static const _rootUrl = "https://still-earth-97911.herokuapp.com/ecoledirecte/";
  static final Endpoint workspaces = Endpoint(_rootUrl + "workspaces");
  static final Endpoint login = Endpoint(_rootUrl + "login");
  static final Endpoint grades = Endpoint(_rootUrl + "grades");
  static final Endpoint homeworkFor = Endpoint(_rootUrl + "homework/%0");
  static final Endpoint nextHomework = Endpoint(_rootUrl + "homework");
  static final Endpoint lessons = Endpoint(_rootUrl + "agenda");
  static final Endpoint mails = Endpoint(_rootUrl + "mails");
  static final Endpoint recipients = Endpoint(_rootUrl + "recipients");
  static final Endpoint schoollife = Endpoint(_rootUrl + "schoollife");

  EcoleDirecteDemoEndpoints._();
}
