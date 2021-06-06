# Comment ajouter une nouvelle classe à la base de données et pouvoir en stocker des objets hors ligne ?

## 1) Générer des types data adapters pour la nouvelle classe
Nous utilisons une base de données Hive. Cette dernière permet de stocker directement des objets d'une classe. Mais nous avons besoin de générer des adapters pour pouvoir les lire et les écrire dans la base de données
Suivez ce guide pour générer des adapters : 

https://docs.hivedb.dev/#/custom-objects/generate_adapter

Vous devriez également etendre votre classe avece `extends HiveObject` pour bénéficier des fonctions très pratiques `save()` et `delete()`.

Après avoir annoté votre classe n'oubliez pas de lancer la commande `flutter packages pub run build_runner build`. Si vous recevez une erreur
essayez avec `flutter packages pub run build_runner build --delete-conflicting-outputs`. 
Cela générera automatiquement les adapters.

## 2) Créer des dossiers qui conviennent
*Jetez un oeil à l'exemple dans `data/offline/example`.*

Vous devez maintenant créer un dossier dans `data` qui correspond à la classe que vous souhaitez stocker hors ligne par exemple `/maClasse`, puis ajoutez un fichier de la sorte : `maClasse.dart`. Organisez le dit fichier comme vous le souhaitez, mais il doit comporter une classe 
`MaClasseOffline` étendue de Offline. Et permettre de retourner facilement les objets de la classe avec une méthode comme `getAllMyClasse()` et les écrire avec une méthode comme `updateMyClasse()`. Plus ce sera simple, plus la suite le sera également. 

Par la suite choisissez la chose suivante :
- Mes données ne sont pas très complexes (simple mise en cache) : je n'envisage pas de modification du contenu persistant. Seulement le supprimer entièrement et le réécrire à chaque refresh : passez l'étape 3) et enregistrez votre data directement dans la box `offlineData` (qui est une Map de données). Elle contient généralement la donnée qui nécessite seulement une simple mise en cache et ne sera pas modifiée au cas par cas (modification d'un seul field par exemple).
- Mes données sont plus complexes: même si elles peuvent être stockées sous la forme d'une liste, j'envisage de modifier certaines données au cas par cas (par exemple modification d'un seul field d'un objet déjà dans la db). Il est préférable d'ouvrir une nouvelle box en suivant l'étape 3.

## 3) Modifier offline.dart

C'est l'étape la plus importante. Ce n'est pas si long mais toutes les étapes doivent être respectées. Vous devrez rajouter les choses suivantes (ils sont organisés dans l'ordre de leur apparition dans le fichier `offline.dart` de haut en bas): 

1) En haut de la classe Offline, rajoutez le nom de votre nouvelle box :
<br/>On rajoute : `static final String maClasseBoxName = "maClasse";`
<br/>C'est le nom sous lequel votre box sera enregistrée sur le disque
   
2) Ajoutez votre Box, si votre box contient une liste de données (ce qui est conseillé) :
<br/>On rajoute : `Box? maClasseBox;`
   
3) Dans la méthode `clearAll()` ajoutez la méthode pour supprimer votre box. Par exemple `await maClasseBox?.deleteFromDisk();`. 
   
4) Dans la méthode `init()` vous devez enregistrez l'adapter généré plus tôt dans le `try{} catch(e){}` en ajoutant la ligne suivante :
`Hive.registerAdapter(MaClasseAdapter());` 

Et c'est tout !
## 4) Utiliser les données hors ligne

Maintenant que tout est fait, on peut désormais accéder aux données hors ligne très facilement en faisant
`var offlineDataMaClasse = await MaClasseOffline(appSys.offline).getAllMyClasse()`
Même s'il est préférable de ne pas le mettre directement dans un controller mais l'intégrer directemement dans la collecte des données de votre API.





