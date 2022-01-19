# Documentation yNotes

Vous trouverez dans ce dossier toute la documentation nécessaire à la compréhension et la contribution de l'application.

Ce fichier permet d'avoir une vue d'ensemble de yNotes sans pour autant rentrer dans les détails. Chaque section sera détaillée dans un dossier/fichier dédié.

## Technologies

yNotes est une application cross-platform réalisée à l'aide du framework [Flutter](https://flutter.dev) basé sur le langage [Dart](https://dart.dev).

## Setup et développement

Voici les outils nécessaires au développement de yNotes:

- [Flutter](https://flutter.dev) (^2.9.0)
- [Visual Studio Code](https://code.visualstudio.com/) avec l'[extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) pour Flutter
- [Git](https://git-scm.com/downloads)
- [Python 3](https://www.python.org/downloads/)

Avant de développer pour une plateforme, soyez sûr de l'avoir activé dans Flutter (Windows, Linux et MacOS encore en bêta et nécessitent une configuration particulière, voir sur le site officiel de Flutter).

Pour développer, il est recommandé d'utiliser l'outil intégré à Visual Studio Code (`F5`) mais il est également possible de lancer l'application avec une commande:

```bash
$ flutter run --flavor dev -d <platform>
```

For example for windows: `flutter run --flavor dev -d windows`.

## Debugging

Nous recommandons pour le debugging d'utiliser [Visual Studio Code](https://code.visualstudio.com/) avec l'[extension](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter) pour Flutter. Cet éditeur contient des outils de déboguage puissants.

Pour avoir accès aux logs d'une application téléchargée depuis un store, il faut connecter le téléphone à l'ordinateur et exécuter la commande `flutter logs`.

A noter que les erreurs enregistrées grâce à `Logger.error` se voient attribués un code (`stackHint`) en exécutant le fichier python `errors_stack_trace.py` à la racine du repository. Il es donc important d'exécuter ce fichier dès l'ajout, la suppression ou la modification de l'instruction `Logger.error`.

Tout usage de `print` ou `debugPrint` est à proscrire en dehors du `Logger`, qui doit être utilisé à la place.

## Architecture

En tant qu'application Flutter, yNotes a donc une structure "classique" mais ce qui nous intéresse ici est l'architecture au sein du dossier `/lib`, vértiable emplacement du développement de l'application. Elle s'organise de la façon suivante :

- `/app`: Contient des fichiers de configuration globale tels que le routeur ou bien le widget `App`, parent de l'arbre des widgets
- `/core`: Contient le code qui n'a rien à voir avec l'ui et est lui même divisé en plusieurs catégories ([Voir](architecture.md))
- `/ui`: Contient les widgets (interface). A noter qu'une partie conséquente de l'interface est développée au sein du package `ynotes_packages` ([Github](https://github.com/EduWireApps/ynotes-packages))
- `/packages`: Contient des modules autres, des utilitaires ou des APIs (indépendantes de l'application) par exemple
- `/experiments`: Contient des tests qui n'ont pas vocation à être utilisé dans l'application mais seulement pendant le développement.
- `logs_stacklist.dart`: Fichier qui liste les erreurs soulevés via le `Logger` ([Voir plus bas](#debugging))
- `main.dart`: Point d'entrée de l'application. Lors de son exécution, la fonction `main` est exécutée

[En savoir plus](architecture.md)

## APIs

Pour communiquer avec les APIs des services scolaires, une classe abstraite a été définie: `SchoolApi` (`/lib/core/src/api/school_api`). Toute API doit être dérivée de cette classe.

Voici les APIS disponibles pour le moment:

- EcoleDirecte
- Pronote

L'ajout d'API est documenté dans le fichier qui lui est dédié.

[En savoir plus](apis.md)

## Déploiement

Pour déployer l'application, nous automatisons ce processus grâce à [Github actions](https://github.com/features/actions).

Pour le déploiement sur les boutiques pour mobile (Play Store et App Store), nous utilisons [Fastlane](https://fastlane.tools/).

Pour en savoir plus, inspectez le code dans `/.github/workflows`.
