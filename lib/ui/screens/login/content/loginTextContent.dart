class ApiChoiceTextContent {
  String pageTitle = "Connexion";
  String pageDescription = "Choisis ton service de vie scolaire";
}

class LoginPageTextContent {
  static LoginTextContent login = LoginTextContent();
  static ApiChoiceTextContent apiChoice = ApiChoiceTextContent();

  static PronoteTextContent pronote = PronoteTextContent();
}

class LoginTextContent {
  String pageDescription = "Entre tes identifiants";
  String login = "Identifiant";
  String unavailableService = "Je ne vois pas mon service";
  String password = "Mot de passe";
  String forgotPassword = "Mot de passe oublié ?";
  String buttonLabel = "Se connecter";
}

class PronoteGeolocation {
  String pageDescription = "Géolocalisation";
  String geolocatingDescription = "Nous cherchons les établissements proches de toi...";
  String statusSearchingDescription = "Nous cherchons les statuts disponibles...";
  String qrCodeScanner = "Scanner un QR Code";
  String qrCodeScannerDescription = "Cheese !";
  String url = "Saisir l'URL";
  String urlDescription = "Posez les termes";
  String buttonLabel = "Continuer";
  String statusLabel = "Choisissez un statut :";
  String statusDescription = "Vous devrez vous connecter en utilisant les identifiants correspondant au statut choisi.";
  //errors
  String noData = "Oups ! Nous n'avons rien trouvé....";
  String error = "Oups, une erreur a eu lieu :";
  String geolocationDisabled = 'La géolocalisation est desactivée sur votre appareil.';
  String geolocationPermissionRefused = "L'accès à la géolocalisation nous a été refusée";
  String geolocationPermissionPermanentlyRefused =
      "L'accès à la géolocalisation est refusée de manière permanente : vous devez la réactiver depuis les paramètres.";
}

class PronoteLoginWaysTextContent {
  String pageDescription = "Choisis un moyen de connexion";
  String geolocation = "Géolocaliser";
  String geolocationDescription = "On sait où tu es";
  String qrCodeScanner = "Scanner un QR Code";
  String qrCodeScannerDescription = "Cheese !";
  String url = "Saisir l'URL";
  String urlDescription = "Posez les termes";
}

class PronoteQRCodeTextContent {
  String pageDescription = "Scanner un QR Code fourni par l'établissement";
  String pinDescription = "Entre le code PIN entré lors de la génération du QR Code";
  String buttonLabel = "Se connecter";
}

class PronoteTextContent {
  PronoteGeolocation geolocation = PronoteGeolocation();
  PronoteLoginWaysTextContent loginWays = PronoteLoginWaysTextContent();
  PronoteQRCodeTextContent qrCode = PronoteQRCodeTextContent();
  PronoteUrlTextContent url = PronoteUrlTextContent();
}

class PronoteUrlTextContent {
  String pageDescription = "Saisis l'URL Pronote fournie par ton établissement";
  String url = "URL Pronote";
  String buttonLabel = "Continuer";
  String forgotUrl = "Tu ne la connais pas ?";
  String reformatting =
      "Nous avons corrigé automatiquement l'adresse URL. Vérifiez puis appuyez à nouveau sur Se connecter";
  String emptyFields =
      "Nous avons corrigé automatiquement l'adresse URL. Vérifiez puis appuyez à nouveau sur Se connecter";
  String invalidAddress = "Adresse invalide";
  String impossibleToConnect = "Impossible de se connecter à cette adresse";
}
