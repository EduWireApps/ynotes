library pronote_content;

/// The content for the login pages.
class PronoteContent {
  static final loginErrors = _LoginErrors();

  static final gradesErrors = _GradesErrors();
  PronoteContent._();
}

class _GradesErrors {
  final parsingFailed = "Impossible de convertir les notes.";
  final requestFailed = "Impossible de collecter les notes.";

  final periodsFetchFailed = "Impossible de collecter les périodes scolaires.";
}

class _LoginErrors {
  final invalidCredentials = "Tes identifiants sont probablement erronés.";
  final unexpectedError =
      "Une erreur inatendue a eu lieu lors de la connexion. Merci de bien vouloir réessayer ou contacter le support.";

  final ipSuspended =
      "L'adresse IP du compte a été suspendue temporairement après trop de mauvaises tentatives de connexion. Merci de réessayer dans plus de 5 minutes.";
  final expiredConnexion = "La connexion est expirée cela peut arriver si vous êtes connectés depuis un certain temps.";
}
