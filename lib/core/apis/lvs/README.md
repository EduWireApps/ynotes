# Introduction ✨
Api apportant l'intégration du service scolaire "La Vie Scolaire" à l'application Ynotes. Se référer aux conditions d'utilisation de celle-ci.
Seuls les devoirs, notes et informations de l'élève sont disponibles pour l'instant.

# Fonctionnement 🧙🏻
## Clients
Implementant `SessionClient.dart`, les clients permettent de gérer une session en apportant des méthodes facilitant l'authentification, la gestion de token et les requêtes. Si configuré à cet effet, le client peut assurer le rafraichissement automatique de la session.

## Methods
```nextHomework()```: donne les devoirs sur les 23 prochains jours.

## Converters
Permettent de convertir les données brutes renvoyées par le service scolaire sous forme d'instance d'objets définis par l'application.
- ### Account Converter
Exemple de données attendues pour `account()`:
```json{
          "infoUser": {
            "logo":
                "https://etablissement.la-vie-scolaire.fr/vsn.main/WSMenu/logo",
            "etabName": "Inserer Etablissement",
            "userPrenom": "Inserer prenom",
            "userNom": "Inserer nom",
            "profil": "Elève"
          },
          "plateform": ""
        }
```
- ### Homework Converter
Un contenu json est attendu.

- ### Disciplines Converter
Un contenu html est attendu.