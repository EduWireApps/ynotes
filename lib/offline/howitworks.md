Les données stockées dans yNotes sont de plus en plus nombreuses et il est nécessaire d'organiser leur stockage pour facilement ajouter des types de données. 

La technologie utilisée pour le stockage est la base de données <u>HiveDB</u> elle permet le stockage de données sous leur forme initiale et il n'y a ainsi pas de conversion à effectuer par la suite. Ainsi un objet d'une classe A est stockée dans une '"box"' HiveDB sous la forme d'un objet de classe A. 

Cependant il est nécessaire de s'assurer que les données retournées sont bien dans le format escompté et que la mise à jour des données ainsi que sa gestion soit la plus simple possible. En sachant qu'il existe plusieurs cas de stockages :

* Le stockage de données sous forme de liste, facile à exploiter, car on retourne toute la liste
* Le stockage de données sous forme de map, pour faciliter l'obtention d'un seul objet

Puis la mise à jour des données peut se faire de plusieurs manières différentes :

* Mise à jour des données par suppression totale des anciennes puis par ajout des nouvelles (valable pour les listes)
* Mise à jour des données par mise à jour des anciennes données en évitant les doublons (valable pour les maps)

Voici donc le pattern de configuration mis en place :

```class OfflineConfig {
class OfflineConfig {
  final String name;
  final Type type;
  final Type wrappingType;
  final Type storedType;
  final List<dynamic> adapters;
  final bool keepOldData;
  final dynamic getter;
}
```

* **name** : Le nom de la donnée à stocker, il est nécessaire pour son obtention et sa mise à jour
* **type**: Le type de donnée à stocker
* **wrappingType**: La forme sous laquelle la donnée est renvoyée, sous forme de Liste, de Map ou sous sa forme initiale : par exemple un unique booléen.
* **storedType**: La forme sous laquelle la donnée est stockée, sous forme de Liste, de Map ou sous sa forme initiale : par exemple un unique booléen.
* **adapters**: Des fonctions de configuration pour HiveDB, elles sont obligatoires lorsque la classe à renvoyer n'est pas adaptée par défaut
* **keepOldData**: Détermine si les anciennes données sont mises à jour ou supprimées
* **getter**: Cela peut être un identifiant unique ou n'importe quoi pour obtenir les données