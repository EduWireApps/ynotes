# Comment ajouter une nouvelle classe à la base de données et pouvoir en stocker des objets hors ligne ?

## 1) Générer des types data adapters pour la nouvelle classe
Nous utilisons une base de données Hive. Cette dernière permet de stocker directement des objets d'une classe. Mais nous avons besoin de générer des adapters pour pouvoir les lire et les écrire dans la base de données
Suivez ce guide pour générer des adapters : 

https://docs.hivedb.dev/#/custom-objects/generate_adapter

Après avoir annoté votre classe n'oubliez pas de lancer la commande `flutter packages pub run build_runner build`. Si vous recevez une erreur
essayez avec `flutter packages pub run build_runner build --delete-conflicting-outputs`. 
Cela générera automatiquement les adapters.

## 2) Créer des dossiers qui conviennent
*Jetez un oeil à l'exemple dans `data/offline/example`.*

Vous devez maintenant créer un dossier dans `data` qui correspond à la classe que vous souhaitez stocker hors ligne par exemple `/maClasse`, puis ajoutez un fichier de la sorte : `maClasse.dart`. Organisez le dit fichier comme vous le souhaitez, mais il doit comporter une classe 
`MaClasseOffline` étendue de Offline. Et permettre de retourner facilement les objets de la classe avec une méthode comme `get()` et les écrire avec une méthode comme `update()`. Plus ce sera simple, plus la suite le sera également. Je vous conseille amplement d'enregistrer les éléments dans la box Hive `offlineData` ainsi aucune étape supplémentaire ne sera requise.


## 3) Modifier offline.dart

C'est l'étape la plus complexe. Ce n'est pas si long mais toutes les étapes doivent être respectées. Vous devrez rajouter les choses suivantes (ils sont organisés dans l'ordre de leur apparition dans le fichier `offline.dart` de haut en bas): 
1) En haut de la classe Offline, rajoutez un champ contenant les éléments de la classe de la manière dont ils sont exploités par l'application et seront stockés dans la base de données. 
<br/><br/>Par exemple si c'est une liste d'objets `MaClasse` rajoutez le champ `List<MaClasse>? maClasseData`. Cela permet de mettre dans le cache ces objets pour y accéder plus vite et éviter d'effectuer une requête vers la DB à chaque fois. Le `?` indique que la valeur peut être nulle. (Par exemple si votre objet est spécifique à une API et n'est pas forcément collecté)
   
2) Une instance de votre classe `MaClasseOffline` qui sera **forcément** initialisée au démarrage de l'application.
Vous devez la rajoutez sous le commentaire `//imports` de la manière suivante :
<br/>On rajoute : `late MaClasseOffline maClasse`
   
1) Dans la méthode `clearAll()` supprimez les données de votre classe mis en cache. Par exemple `maClasseData?.clear()`. 
   
2) Dans la méthode `init()` vous devez enregistrez l'adapter généré plus tôt dans le `try{} catch(e){}` en ajoutant la ligne suivante :
`Hive.registerAdapter(MaClasseAdapter());` 

5) On initialise l'instance `MaClasseOffline` de votre classe dans la méthode `initObjects()` :
<br/>On rajoute : `maClasse = MaClasseOffline(this.locked, this);`

1) Et finalement, on ajoute le nécessaire pour rafraichir les donnéees dans le cache dans la méthode `refreshData()`.
*<br/>En dessous du commentaire `//Get data and cast it`:*
<br/><br/>On crée un var temporaire : 
(en supposant qu'on ait utilisé la box Hive offlineBox et la clé "maClasse")
<br/><br/>On rajoute : `var offlineMaClasseData = await offlineBox?.get("maClasse");` 
<br/>Puis on l'ajoute à notre vrai cache :
*<br/>En dessout du commentaire `//ensure that fetched data isn't null and if not, add it to the final value`:*
<br/><br/>On rajoute : `if (offlineMaClasseData != null) {this.maClasseData = offlineMaClasseData.cast<MaClasse>();}`

## 5) (facultatif) Je souhaite utiliser ma propre Box Hive
Pour certaines données, il est préférable de stocker les données dans une autre box. Pour optimiser les performances par exemple, ou pour séparer les données afin de pouvoir les récupérer si une autre Box Hive était corrompue. Je vous conseille de regarder comment les Box sont instanciées dans le `offline.dart` avec les conseils suivants :
- Faites en sorte que votre box soit correctement supprimée dans la méthode `clearAll()`
- Dans le deuxième `try{}catch(e){}` de la méthode `init()` ouvrez votre box de cette manière : <br/><br/>`maClasseBox = await Hive.openBox("maclasse");`
## 4) Utiliser les données hors ligne

Maintenant que tout est fait, on peut désormais accéder aux données hors ligne très facilement en faisant
`var offlineMaClasse = await appSys.offline.maClasse.get()`
Même s'il est préférable de ne pas le mettre directement dans un controller mais l'intégrer directemement dans la collecte des données de votre API.





