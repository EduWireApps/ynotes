library login_content;

part 'widgets.dart';
part 'pronote.dart';

/// The content for the login pages.
class LoginContent {
  LoginContent._();

  static final widgets = _Widgets();
  static final login = _Login();
  static final ecoleDirecte = _EcoleDirecte();
  static final lvs = _Lvs();
  static final demos = _Demos();
  static final pronote = _Pronote();
}

class _Login {
  final subtitle = "Choisis ton service scolaire";
  final missingService = "Je ne vois pas mon service";
  final dialogBody =
      "Si ton service scolaire n'apparait pas dans la liste, c'est que yNotes ne le prend pas en charge. Tu sais coder ? Prend contact avec nous sur Github ou Discord pour en apprendre plus sur l'implémentation des services et peut-être même participer à l'implémentation du tien.";
}

class _EcoleDirecte {
  final subtitle = "EcoleDirecte";
}

class _Lvs {
  final subtitle = "La vie scolaire";
}

class _Demos {
  final subtitle = "Choisis ton service scolaire";
}
