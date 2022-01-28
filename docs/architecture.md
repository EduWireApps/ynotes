# Architecture

> Il est recommandé de lire le code source pour comprendre le fonctionnement de l'application pour chaque section.
>
> Par exemple, le contenu du fichier `/app/src/router.dart` n'est pas détaillée de façon exhaustive et il est nécessaire de l'analyser pour en comprendre les possibilités.

En tant qu'application Flutter, yNotes a donc une structure "classique" mais ce qui nous intéresse ici est l'architecture au sein du dossier `/lib`, vértiable emplacement du développement de l'application. Elle s'organise de la façon suivante :

- `/app`: Contient des fichiers de configuration globale tels que le routeur ou bien le widget `App`, parent de l'arbre des widgets
- `/core`: Contient le code qui n'a rien à voir avec l'ui et est lui même divisé en plusieurs catégories
- `/ui`: Contient les widgets (interface). A noter qu'une partie conséquente de l'interface est développée au sein du package `ynotes_packages` ([Github](https://github.com/EduWireApps/ynotes-packages))
- `/packages`: Contient des modules autres, des utilitaires ou des APIs (indépendantes de l'application) par exemple
- `/experiments`: Contient des tests qui n'ont pas vocation à être utilisé dans l'application mais seulement pendant le développement.
- `logs_stacklist.dart`: Fichier qui liste les erreurs soulevés via le `Logger` ([Voir plus bas](#debugging))
- `main.dart`: Point d'entrée de l'application. Lors de son exécution, la fonction `main` est exécutée

## `/app`

Les fichiers expliqués ci-dessous se trouvent dans `/src`.

### `app.dart`

Ce fichier contient le widget parent de tout l'arbre de widgets. C'est ici que tous les widgets de configuration globale sont appelés (`YApp` par exemple).

### `config.dart`

Ce fichier contient les différents variables de configuration globale de l'application. Ne peut pas être hérité et s'appelle de façon statique: `AppConfig.<method/attribute>`.

### `migrations.dart`

D'une version à une autre, certaines implémentations changent et nécessitent des migrations de données. C'est tout le but de la fonction `migration`, qui appelle une fonction privée par changement de version (ex: `_fromV12ToV13`). Il est important d'utiliser `KVS` (Voir [`/core`](#core)) pour sauvegarder le statut des migrations et ne pas les effectuer à chaque lancement de l'application, menant à des pertes de données pour les utilisateurs.

### `router.dart`

Ce fichier contient toutes les classes nécessaires au routage de yNotes. Il utilise le Navigator 2.0 de Flutter avec des routes nommées et suppporte les pages gardées. Pour changer de page dans l'application, il faut donc utiliser:

```dart
Navigator.pushNamed(context, "route-name", arguments)
```

Lors de l'ajout de route, il est recommandé de les ajouter dans un fichier dédié dans une liste, et d'ensuite les référencer dans le router.

**EXEMPLE**

Dans le module `/ui/screens/example`, je crée un fichier `routes.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/screens/example/example.dart';

const List<AppRoute> exampleRoutes = [
  AppRoute(path: "/example", widget: ExamplePage(), icon: Icons.example, title: "Example")
  // ...
];

```

Il faut ensuite aller dans `/app/src/router.dart` et ajouter la liste de routes nouvellement créée:

```diff
class AppRouter {
    // ...

    /// The routes for the whole application.
    static final List<AppRoute> routes = [
    // IMPORTANT: routes are duplicated because of [initialRoute].
    // When starting with a `/`, it creates 2 routes: `/` and `/loading`, leading to errors
    const AppRoute(path: "loading", widget: LoadingPage(), show: false),
    const AppRoute(path: "/loading", widget: LoadingPage(), show: false),
    const AppRoute(path: "/terms", widget: TermsPage(), show: false),
    ...loginRoutes,
    ...introRoutes,
    ...settingsRoutes,
    ...homeRoutes,
    ...gradesRoutes,
+   ...exampleRoutes
  ];
}
```

### `school_api.dart`

Pour accéder à l'API du service scolaire sélectionner, il faut utiliser la variable `schoolApi` stockée dans ce fichier. Il contient également la liste des APIS disponibles ainsi qu'une fonction permettant de changer l'API sélectionnée.

## `/core`

Ce dossier contient le code qui n'a pas de lien avec l'interface. Il est divisé en plusieurs catégories:

- **api:** Contient le code en relation avec les apis des services scolaires. [En savoir plus](apis.md)
- **controllers:** Contient des classes globales et/ou spécifiques à un service scolaire (Ex: Pronote)
- **services:**
- **utilities:** Contient des classes utilitaires.

Lors de leur utilisation, il faut utiliser le fichier qui exporte les différents fichiers plutôt que le fichier lui-même.

Exemple:

```dart
import 'package:ynotes/core/utilities.dart';
```
au lieu de

```dart
import 'package:ynotes/core/src/utilities/kvs.dart';
```

offline

extensions

## `/ui`

TBD

## `/packages`

TBD

## `/experiments`

TBD

## `logs_stacklist.dart`

TBD

## `main.dart`

TBD
