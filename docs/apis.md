# APIS

La gestion des APIS (c'est-à-dire des différents services scolaires) est assez complexe et nécessite une section dédiée.

A venir

Diagrammes

## Fonctionnement

### Architecture modulaire

Une API fonctionne de façon modulaire. En effet, un service scolaire A peut disposer de modules X et Y tandis qu'un service B ne disposera que du module X. (Par module on entend un ensemble de fonctionnalités gérées par le service, par exemples les notes).

L'API a donc une structure modulaire pour permettre de gérer la disponibilité des modules à l'échelle du service, mais aussi de l'utilisateur. En effet, certains modules ne sont disponibles qu'en fonction du choix de l'emplacement. Il est donc possible de définir ces disponibilités de façon dynamique (normalement lors de l'authentification).

Un module dispose d'une interface faites de _getters_ et de méthodes. Les éventuelles variables muables sont privées et des getters sont utilisés pour les récupérer. Par exemple :

```dart
bool _status = false;
bool get status => _status;
```

Toute méthode peut être écrasé pour des besoins spécifiques à un service, même s'il est préférable que ce ne soit pas le cas. Par exemple, un calcul de moyenne pourrait être différent pour un service X et dans ce cas, il est possible de changer la méthode de calcul spécifiquement pour ce service sans modifier celle des autres et en gardant la même interface (paramètres et retour).

### Disponibilité des modules

Il existe donc une classe abstraite `SchoolApi` que toute API doit hériter (plus de détails dans une prochaine section).

Chaque module est dit disponible selon 2 critères :

- est-ce que le module a été implémenté pour le service (`ModulesSupport`)
- est-ce que l'utilisateur dispose du module (`ModulesAvailability`)

Ainsi, certaines pages ne sont accessibles que si le module est implémenté et que l'utilisateur dispose du module.

### Données hors ligne

Par défaut, les données retournées par un module sont stockées en hors ligne. Cela permet à l'utilisateur d'avoir directement accès à ses données sans devoir attendre qu'une requête http soit effectuée.

Chaque module possède une méthode `fetch` qui permet de récupérer les données en ligne. Le comportement de chaque module n'est cependant pas le même: certains écrasent les données, d'autres mettent à jour, cela dépend.

Chaque module possède également une méthode `reset` pour supprimer les données stockées au besoin.

## Ajouter un module

> Pour faciliter la compréhension, le module utilisé dans cet exemple aura pour nom `Cantine` et le modèle `Repas`.

Voici un aperçu des étapes :

1. Ajouter les fichiers du module dans `/lib/core/src/api/school_api/src/modules/cantine/`
2. Créer les classes
3. Ajouter le module dans `SchoolApiModules`
4. Créer les modèles si nécessaire dans `/lib/core/src/api/school_api_models/src/repas.dart`
5. Exécuter `build_runner`
6. Ajouter une entrée à `ModulesSupport` et `ModulesAvailability`
7. Ajouter le nouveau module à **tous** les services

> **IMPORTANT**
>
> Avant l'ajout d'un module, entrez en contact avec les développeurs (Discord de préférence), il serait dommage que l'ajout du module soit refusé faute de convenir à la vision des maintainers.

### 1. Création du module

Un module est composé de 2 fichiers :

- `module.dart`: le module en lui-même, c'est-à-dire une classe qui hérite de `Module`
- `repository.dart` (Optionnel): si le module nécessite de récupérer/interagir avec les données de plusieurs façons, ajouter ce fichier est nécessaire

Pour notre exemple, nous allons créer un module `Cantine` qui peut récupérer la liste de tous les repas de l'élève et qui peut également ajouter un repas. Nous aurons donc besoin de 2 fichiers.

Commençons par créer le repository. Créons un fichier `/lib/core/src/api/school_api/src/modules/cantine/repository.dart` :

```dart
part of school_api;

abstract class CantineRepository extends Repository {
  CantineRepository(SchoolApi api) : super(api);

  Future<Response<bool>> add(Meal meal);
}
```

Lors de l'implémentation du repository dans un service, 2 méthodes seront disponibles: `fetch` et `add`.

Il faut maintenant ajouter le fichier dans `/lib/core/src/api/school_api/school_api.dart` :

```diff
// DOCUMENTS MODULE
part 'src/modules/documents/module.dart';
part 'src/modules/documents/repository.dart';

+ // CANTINE MODULE
+ part 'src/modules/cantine/repository.dart';

```

## Ajouter un service scolaire

A venir
