library pronote_content;

/// The content for the login pages.
class PronoteContent {
  PronoteContent._();

  static final loginErrors = _LoginErrors();
}

class _LoginErrors {
  final invalid_credentials = "Tes identifiants sont probablement erronés.";
  final unexpected_error =
      "Une erreur inatendue a eu lieu lors de la connexion. Merci de bien vouloir réessayer ou contacter le support.";

  final ip_suspended =
      "L'adresse IP du compte a été suspendue temporairement après trop de mauvaises tentatives de connexion. Merci de réessayer dans plus de 5 minutes.";
  final expired_connexion =
      "La connexion est expirée cela peut arriver si vous êtes connectés depuis un certain temps.";
}
