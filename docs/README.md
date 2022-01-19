# Documentation yNotes

Vous trouverez dans ce dossier toute la documentation nécessaire à la compréhension et la contribution de l'application.

## Sommaire et organisation

Ce fichier permet d'avoir une vue d'ensemble de yNotes sans pour autant rentrer dans les détails. Chaque section sera détaillée dans un dossier/fichier dédié. Pour naviguer dans le présent fichier, voici ci-dessous le sommaire:

- WIP
- WIP

## Technologies

yNotes est une application cross-platform réalisée à l'aide du framework [Flutter](https://flutter.dev) basé sur le langage [Dart](https://dart.dev).

## Architecture

En tant qu'application Flutter, yNotes a donc une structure "classique" mais ce qui nous intéresse ici est l'architecture au sein du dossier `/lib`, vértiable emplacement du développement de l'application. Elle s'organise de la façon suivante :

- `/app`: Contient des fichiers de configuration globale tels que le routeur ou bien le widget `App`, parent de l'arbre des widgets
- `/core`: Contient le code qui n'a rien à voir avec l'ui et est lui même divisé en plusieurs catégories ([Voir](architecture.md))
- `/ui`: Contient les widgets (interface). A noter qu'une partie conséquente de l'interface est développée au sein du package `ynotes_packages` ([Github](https://github.com/EduWireApps/ynotes-packages))
- `/packages`: Contient des modules autres, des utilitaires ou des apis (indépendantes de l'application) par exemple
- `/experiments`: Contient des tests qui n'ont pas vocation à être utilisé dans l'application mais seulement pendant le développement.
- `genereated_plugin_registrant.dart`: Fichier généré lors du développement de l'application, il est inutile d'y toucher. Même s'il contient des erreurs, elles n'empêchent pas l'exécution du code car ce fichier est seulement utilisé pour le web (ce qui n'est pas une cible de déploiement de yNotes)
- `logs_stacklist.dart`: Fichier qui liste les erreurs soulevés via le `Logger` ([Voir plus bas](#debugging))
- `main.dart`: Point d'entrée de l'application. Lors de son exécution, la fonction `main` est exécutée

## Apis

WIP

- classe abstraite
- classes extended
- apis dispos
- tuto -> voir le fichier

## Déploiement

WIP

- Github actions
- Fastlane

## Debugging

WIP

- VSC
- flutter logs
- script python pour les erreurs

## Setup et développement

WIP

- Versions, env
- commandes

## Planification des mises à jour

WIP

- 1 mineure = 1 fonctionnalité stable (data + ui)