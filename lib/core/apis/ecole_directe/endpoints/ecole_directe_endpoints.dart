import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_api_endpoints.dart';
import 'package:ynotes/core/apis/ecole_directe/endpoints/ecole_directe_demo_endpoints.dart';

class EcoleDirecteEndpoints {
  final bool debug;
  final String id;
  EcoleDirecteEndpoints({required this.debug, required this.id});
  String get grades => _url(EcoleDirecteDemoEndpoints.grades, EcoleDirecteApiEndpoints.grades);
  String get lessons => _url(EcoleDirecteDemoEndpoints.lessons, EcoleDirecteApiEndpoints.lessons);
  String get login => _url(EcoleDirecteDemoEndpoints.login, EcoleDirecteApiEndpoints.login);
  String get mails => _url(EcoleDirecteDemoEndpoints.mails, EcoleDirecteApiEndpoints.mails);
  String get nextHomework => _url(EcoleDirecteDemoEndpoints.nextHomework, EcoleDirecteApiEndpoints.nextHomework);
  String get recipients => _url(EcoleDirecteDemoEndpoints.recipients, EcoleDirecteApiEndpoints.recipients);
  String get schoolLife => _url(EcoleDirecteDemoEndpoints.schoollife, EcoleDirecteApiEndpoints.schoolLife);
  String get testToken => _url(EcoleDirecteDemoEndpoints.grades, EcoleDirecteApiEndpoints.testToken);
  String get workspaces => _url(EcoleDirecteDemoEndpoints.workspaces, EcoleDirecteApiEndpoints.workspaces);

  String homeworkFor(String date) =>
      _url(EcoleDirecteDemoEndpoints.homeworkFor, EcoleDirecteApiEndpoints.homeworkFor, optional: [date]);

  _url(Endpoint demoEndpoint, Endpoint regularEndpoint, {List? optional}) {
    return debug
        ? demoEndpoint.getUrl(optionalParameters: optional)
        : regularEndpoint.getUrl(optionalParameters: optional);
  }
}

class Endpoint {
  final String definition;

  Endpoint(this.definition);

  String getUrl({List? optionalParameters}) {
    if (optionalParameters != null) {
      String temp = definition;
      for (int index = 0; index < optionalParameters.length; index++) {
        temp = temp.replaceAll("%$index", optionalParameters[index]);
      }
      return temp;
    } else {
      return definition;
    }
  }
}
