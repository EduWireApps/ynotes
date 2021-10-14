part of login_content;

class _Pronote {
  final methods = _PMethods();
  final subtitle = "Choisis un moyen de connexion";
  String notAvailable(String os) => "Indisponible sur $os";
  final qrCode = _PQrCode();
  final url = _PUrl();
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
}
