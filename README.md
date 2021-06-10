# yNotes
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-5-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

[![Vidéo de promotion pour la version 0.9.1](https://img.youtube.com/vi/BHQ5uG2zTS4/0.jpg)](https://www.youtube.com/watch?v=BHQ5uG2zTS4)

# Introduction
 **yNotes est un gestionnaire de notes, d'emploi du temps et de devoirs qui vous permet d'accéder à toutes vos informations scolaires dans une interface moderne et intuitive**. 

*L'application actuelle est basée sur les APIs des sites **École Directe** et **Pronote***. 


- ### Téléchargez dès maintenant yNotes sur le [Google Play Store](https://play.google.com/store/apps/details?id=fr.ynotes) ou l'[App Store](https://apps.apple.com/fr/app/ynotes/id1563624059)
- ### Rejoignez le [serveur Discord officiel](https://discord.gg/uNy7F3hwuA) pour contacter l'équipe et être au courant de chaque nouveauté

```diff
- yNotes n'est pas un client officiel et utilise directement les APIs d'applications scolaires. 
- Vos identifiants sont chiffrés et stockés sur votre appareil et nous n'y avons strictement pas accès
- Nous ne nous portons pas responsables en cas de sanction de l'application scolaire. 
```
# Sommaire
- [yNotes](#ynotes)
- [Introduction](#introduction)
- [Sommaire](#sommaire)
- [Fonctionnalités](#fonctionnalités)
    - [Fonctionnalités mises en place](#fonctionnalités-mises-en-place)
    - [Fonctionnalités à venir](#fonctionnalités-à-venir)
- [Installation](#installation)
    - [Depuis les releases officielles](#depuis-les-releases-officielles)
    - [Android](#android)
    - [iOS](#ios)
- [Compilation](#compilation)
- [Compatibilité](#compatibilité)
- [A propos des APIs officielles](#a-propos-des-apis-officielles)
- [Documentation](#documentation)
    - [Architecture](#architecture)
- [Contributeurs](#contributeurs)
    - [Mentions spéciales](#mentions-spéciales)


# Fonctionnalités 
Les fonctionnalités de yNotes s'étendent chaque jour pour vous permettre d'être le plus efficace dans votre travail, et l'interface est régulièrement revue pour être la plus intuitive possible.
### Fonctionnalités mises en place


- **Notes**
  - Affichage des notes et des données liées
  - Notification de nouvelles notes
  - Partage des notes
  - Filtrage des notes par spécialités ou catégorie (sciences, littérature)

- **Devoirs**
  - Accès aux devoirs à faire
  - Accès aux devoirs à une date spécifique
  - Affichage des pièces jointes liées (EcoleDirecte seulement)
  - Epinglage de devoirs importants
- **Emploi du temps**
  - Accès aux cours programmés
  - Ajout d'évènements personnalisables
  - Ajout de rappels et alarmes
- **Applications supplémentaires**
  - Cloud (EcoleDirecte)
  - Mails (EcoleDirecte) avec notifications
  - Sondages (Pronote)
- **Mode nuit**
- **Application hors ligne**
### Fonctionnalités à venir

- Fonctionnalités supplémentaires dans l'affichage des devoirs, partage et recherche rapide par mot-clé (partenariat avec applications scolaires ?)
- Tickets de vie scolaire
- Actualités et informations
# Installation
L'application est développée avec le framework Flutter, et donc développée en Dart.

### Depuis les releases officielles
Si vous êtes utilisateur et souhaitez télécharger l'application sur votre smartphone, vous pouvez :
### Android
- [Installer l'application depuis le Google Play Store](https://play.google.com/store/apps/details?id=fr.ynotes)
- [Télécharger la dernière release (.apk)](https://github.com/ModernChocolate/ynotes/releases)
- [Compiler vous même votre application](#compilation)
### iOS
- [Installer l'application depuis l'App Store](https://apps.apple.com/fr/app/ynotes/id1563624059)
- [Compiler vous même votre application](#compilation)


# Compilation 

La compilation permet de créer une application interprétable par un appareil donné, dans notre cas votre smartphone à partir du code source.

Il est conseillé de procéder à l'installation guidée indiquée par [la documentation officielle de Flutter](https://flutter.dev/docs/get-started/install).

Notez que pour compiler l'application pour iOS, il vous faut absolument un ordinateur Mac.

Téléchargez une version officielle du code source de l'application depuis cette page, si vous êtes utilisateur, préférez la branche stable, sinon vous pouvez essayer de compiler une version bêta de yNotes. 

Ouvrez le dossier du code source dans votre éditeur favori (VSCode, Android Studio, XCode). 

Assurez vous que votre téléphone est connecté à votre ordinateur si vous souhaitez directement compiler l'application sur ce dernier et vérifiez les conditions suivantes.

Suivez les étapes de compilation de la documentation officielle :
* [Compiler pour Android](https://flutter.dev/docs/deployment/android)
* [Compiler pour iOS](https://flutter.dev/docs/deployment/ios)
*Vous devez disposer d'un compte Apple Developer gratuit (ou payant) pour installer l'application sur un appareil iOS*

# Compatibilité
yNotes est disponible pour les utilisateurs suivants :
- Utilisateurs d'EcoleDirecte (comptes élèves)
- Utilisateurs Pronote (comptes élèves)
  - Par connexion directe (munissez vous d'une [adresse Pronote valide](https://support.ynotes.fr/compte/se-connecter-avec-son-compte-pronote)) ou géolocalisation
    - Support HTTPS et HTTP
    - Support de tous les ENT/CAS
  
  Nous ajoutons actuellement une fonction qui permettra de se connecter à partir de __n'importe quel ENT__.

# A propos des APIs officielles
En réalité, Pronote et EcoleDirecte ne proposent pas vraiment "d'APIs" publiques et faciles d'accès. Je vous invite à regarder le dossier apis (`lib/core/apis`) puis consulter leurs dossiers respectifs pour comprendre comment yNotes accède aux données.

- Pour EcoleDirecte, j'ai intégralement réalisé l'API de l'application. Les requêtes ne sont pas très complexes et vous pouvez facilement obtenir les données après avoir récupéré un `token` qui est valide environ `15 minutes` dans la requête de connexion.
- Pour Pronote, j'ai quasiment recopié l'[API en python](https://github.com/bain3/pronotepy) réalisée par [bain](https://github.com/bain3). Si vous comptez vous lancer dans la réalisation de votre propre API - ce que je vous déconseille - jetez un coup d'oeil à [cette discussion](https://github.com/LelouBil/PronoteLib/blob/master/Protocol.md). Mais Pronote utilisant tellement de méthodes complexes qui vous compliqueront la tache je vous conseille plutôt de vous baser sur [l'API de Bain](https://github.com/bain3/pronotepy) citée précédemment, sur [l'API très complète de Litarvan](https://github.com/Litarvan/pronote-api) ou la [bibliothèque de Leloubil](https://github.com/LelouBil/PronoteLib). 
<br>*Je suis bien moins compétant qu'eux sur le sujet, alors n'hésitez pas à aller consulter leur travail voire leur demander directement !*
# Documentation 

Le fichier principal (exécuté en premier) est `/lib/main.dart`

### Architecture 
yNotes a été codée suivant une architecture MVC.
La partie business `/lib/core` inclut les controlleurs (dans `/logic`) ainsi qu'un dossier `/apis` qui contient tout ce qui est nécessaire pour collecter les données provenant d'EcoleDirecte ou Pronote.

Le dossier `/offline` contient tout ce qui est nécessaire à la mise en cache/hors ligne des données (nous utilisons la base de donnée Hive). Et finalement, le dossier `/services` est à différencier de `/utils`. Le premier servant à organiser les interactions "système" de l'application : notifications, deeplinks, arrière plan, le second contenant des utilitaires plus globaux dans l'application : theming, export de la db en json...

Les vues sont dans `/lib/ui`
L'organisation des fichiers est néanmoins succeptible de changer.


# Contributeurs
### Mentions spéciales
* Merci aux développeurs et bêta testeurs qui ont aidé à participer au projet en me suggérant des fonctionnalités et en montrant des bugs que je n'aurai sûrement jamais remarqués
* L'API Pronote est un portage de [pronotepy](https://github.com/bain3/pronotepy), développée par [bain](https://github.com/bain3) que je remercie énormément pour ses explications et sa disponibilité :)

Je tiens à remercier chaque autre personne ne figurant pas dans cette section pour avoir testé yNotes, collaboré d'une manière ou d'une autre pour la création de l'application et m'avoir donné des idées pour l'améliorer.
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://taokann.one"><img src="https://avatars1.githubusercontent.com/u/38343089?v=4?s=100" width="100px;" alt=""/><br /><sub><b>taokann.one</b></sub></a><br /><a href="https://github.com/ModernChocolate/ynotes/issues?q=author%3Ataokann" title="Bug reports">🐛</a> <a href="#ideas-taokann" title="Ideas, Planning, & Feedback">🤔</a> <a href="#userTesting-taokann" title="User Testing">📓</a></td>
    <td align="center"><a href="https://florian-lefebvre.dev"><img src="https://avatars1.githubusercontent.com/u/69633530?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Florian LEFEBVRE</b></sub></a><br /><a href="https://github.com/ModernChocolate/ynotes/issues?q=author%3Aflorian-lefebvre" title="Bug reports">🐛</a> <a href="#ideas-florian-lefebvre" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="http://bain.cz"><img src="https://avatars0.githubusercontent.com/u/31798786?v=4?s=100" width="100px;" alt=""/><br /><sub><b>bain3</b></sub></a><br /><a href="#ideas-bain3" title="Ideas, Planning, & Feedback">🤔</a> <a href="#plugin-bain3" title="Plugin/utility libraries">🔌</a></td>
    <td align="center"><a href="https://github.com/ShiyukiNeko"><img src="https://avatars3.githubusercontent.com/u/47981502?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ShiyukiNeko</b></sub></a><br /><a href="#ideas-ShiyukiNeko" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/GENERATION2GEEK"><img src="https://avatars3.githubusercontent.com/u/33123296?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Vincent Moucadeau</b></sub></a><br /><a href="https://github.com/ModernChocolate/ynotes/commits?author=GENERATION2GEEK" title="Code">💻</a> <a href="#userTesting-GENERATION2GEEK" title="User Testing">📓</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
