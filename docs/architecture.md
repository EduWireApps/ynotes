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

Ce dossier contient le code qui n'a pas de lien avec l'interface. Il est divisé en plusieurs catégories.

### `api`

Contient le code en relation avec les apis des services scolaires. [En savoir plus](apis.md)

### `controllers`

Contient des classes globales et/ou spécifiques à un service scolaire (Ex: Pronote).

N'a pas de grande utilité pour le moment mais l'architecture est déjà prête pour une éventuelle utilisation.

### `services`

Contient des classes globales qui possède une fonction essentielle au sein de yNotes.

Ainsi, voici les services actuellement disponibles :

- `background`: Permet de gérer les tâches en arrière plan **(En cours de développement)**
- `notification`: Permet de gérer les notifications **(En cours de développement)**
- `platform`: Permet d'interagir avec des fonctionnalités spécifiques à une plateforme (OS). Par exemple, ouvrir les paramètres sur Android **(Non implémenté)**
- `settings`: Permet de gérer les paramètres de l'application. Le système permet la migration automatique des données lors de changement de la structure des paramètres. Si le type change par exemple, la valeur est réinitialisée
- `system`: Permet de gérer les fonctions système de l'application telles que l'initialisation ou bien la demande d'autorisations.

### `utilities`

Contient des classes utilitaires diverses. Il est recommandé d'aller explorer le code pour voir les fonctions disponibles.

---

> Lors de leur utilisation, il faut utiliser le fichier qui exporte les différents fichiers plutôt que le fichier lui-même.
>
> Exemple:
>
> ```dart
> import 'package:ynotes/core/utilities.dart';
> ```
>
> au lieu de
>
> ```dart
> import 'package:ynotes/core/src/utilities/kvs.dart';
> ```

### `offline`

Gère les relations avec la base de donnée hors ligne. Ce système est basé sur [Isar](https://isar.dev/), c'est pourquoi l'ouverture d'autres instances de la base de données nécessite comme paramètres `schema` la variable contenu dans cette classe `Offline.schemas`. (Voir système de logs)

L'accès multi isolate est géré, les données ne sont donc pas corrompues en cas de modifications simultanées.

### `extensions`

Contient des extensions de classes Dart, par exemple `String.capitalize()`.

## `/ui`

Contient 4 catégories :

### `animations`

Le nom est plutôt transparent et le dossier plutôt vide XD.

### `components`

Contient des composants utilisés à plusieurs reprises dans l'application. Explorez le code pour voir les composants disponibles.

### `screens`

Contient les différentes page de l'application. La structure reflète la façon dont s'agence les pages, et notamment pour appeler les routes avec `Navigator.pushNamed(context, <NOM DE LA ROUTE>)`.

Un dossier `/screens/ma_page` se constitue de la façon suivante :

- `ma_page.dart`: Contient le code de la page
- `routes.dart`: Contient les routes de la page et des sous-pages
- `/widgets`: Contient des composants locaux dont la mise à disposition à l'échelle de l'application n'aurait pas de sens
- `/widgets/widget.dart`: Exporte les widgets pour réduire les importations de fichiers
- `/sub_pages`: Contient les sous-pages de la page
- `/sub_pages/ma_sous_route.dart`: Une sous-page
- `/content`: Peut contenir le contenu (en terme de textes) de l'ensemble des pages et sous-pages. Facultatif.

### `themes`

Contient les thèmes de l'application. Basé sur `ynotes_packages`.

## `/packages`

Contient des packages qui peuvent fonctionner de façon indépendante de yNotes. Ce dossier est à vocation temporaire et ce sera à terme déplacé dans un (ou plusieurs) repository.

## `/experiments`

Contient des fichiers temporaires qui ne seront pas exécutés avec l'application (à des fins de développement donc).

## `logs_stacklist.dart`

Lors de l'exécution de `/errors_stack_trace.py`, les erreurs détectées par le script sont stockées dans ce fichier sous forme de `Map`.

## `main.dart`

Contient le point d'entrée de l'application. La fonction `void main()` est exécutée par Dart lors du lancement de l'application.
