part of login_content;

class _Pronote {
  final methods = _PMethods();
  final subtitle = "Choisis un moyen de connexion";
  String notAvailable(String os) => "Indisponible sur $os";
  final qrCode = _PQrCode();
  final url = _PUrl();
  final geolocation = _PGeolocation();
}

class _PMethods {
  final qrCode = _PMethod(title: "QR Code", subtitle: "Il suffit de flasher !");
  final geolocation = _PMethod(title: "Géolocalisation", subtitle: "Trouve les établissements à proximité");
  final url = _PMethod(title: "Url", subtitle: "Connecte-toi directement");
}

class _PMethod {
  _PMethod({required this.title, required this.subtitle});

  final String title;
  final String subtitle;
}

class _PQrCode {
  final permissionDenied = "Permission refusée";
  final title = "QR Code";
  final connecting = "Connexion en cours...";
  final code = "Code";
  final fieldMessage = "Le code doit comporter 4 caractères";
  final error = "Erreur";
  final errorMessage = "Votre code PIN est invalide";
  final connected = "Connecté !";
}

class _PUrl {
  final connected = "Connecté !";
  final error = "Erreur";
  final subtitle = "Par Url Pronote";
  final fieldLabel = "Url Pronote";
  final requiredField = "Ce champ est obligatoire";
  final errorMessage = "Url invalide";
  final logIn = "SE CONNECTER";
  final form = _PUrlForm();
  final webview = _PUrlWebview();
}

class _PUrlForm {
  final subtitle = "Pronote";
}

class _PUrlWebview {
  final title = "Connexion à l'ENT";
  final dialog = _PUrlWebviewDialog();
  final connecting = "Connexion en cours...";
}

class _PUrlWebviewDialog {
  final title = "Je ne parviens pas à me connecter";
  final body =
      "Impossible de se connecter, une page blanche ou une question ? Rejoignez le serveur Discord de support pour obtenir une réponse. \n\nSi votre problème est une simple erreur d'affichage ou ne vous empêche pas de vous connecter signalez l'erreur avec l'outil de rapport ci-dessous.";
  final support = "Besoin d'une assistance rapide";
  final report = "Signaler un problème mineur";
}

class _PGeolocation {
  final searching = "Recherche des établissements à proximité en cours...";
  final search = "Rechercher un établissement";
  final noResults = "Aucun résultat ! Réessaie...";
  final title = "Géolocalisation";
  String getDistance(String distance) => "à $distance kilomètres";
  final noDistance = "(distance non définie)";
  final chooseSpace = "Choisis un espace";
}
