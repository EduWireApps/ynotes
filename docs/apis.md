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

A venir

## Ajouter un service scolaire

A venir
