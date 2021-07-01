Nous avons simplifié au maximum l'usage des settings dans l'application. Ainsi, le développeur possède une garantie de :
- Rapidité de l'intégration : en suivant les règles suivantes, il peut facilement accéder aux paramètres stockés dans les SharedPreferences avec une autocompletion du champ qu'il recherche. Et surtout sans devoir effectuer une requête vers les SharedPreferences qui retournerait un Future.
- Solidité de l'intégration : grâce au typage et à la null safety, le développeur peut s'assurer que ses champs seront correctement parsés et décider de valeurs par défaut. 

## Rapide vue d'ensemble 
Nous stockons les données dans les SharedPreferences : c'est une interface fournie par les constructeurs qui permet de stocker de manière **non sécurisée** des paramètres dans l'appareil. Ces derniers relèvent des données persistantes du type préférence utilisateur, premier ouverture, thème et ne sont pas sécurisées. Si vous souhaitez enregistrer des champs de manière sécurisée, utilisez le **SecureStorage**.

Afin d'éviter de faire des requêtes tout le temps, nous stockons les préférences dans une variable disponible dans **appSys**, une variable accessible partout et définie dans **globals.dart**.

Cette variable est de la classe `FormSettings`, cette classe contient une fonction `toJson()` car on ne peut pas stocker directement d'objets dans les SharedPreferences. On enregistre alors **une String au format JSON** qu'on **parse ensuite en un objet `FormSettings`**. 

## Démarrage rapide
***Vous n'aurez pas à toucher au fichier `settingsUtils.dart`, ne le faites pas à moins de savoir ce que vous faites.***

Pour intégrer un nouveau champ suivez les instructions suivantes :
- 1) Rendez vous dans le fichier `model.dart` de ce fichier. Cette dernière contient différentes classes qui contiennent chacune des paramètres. La classe Parent est `FormSettings` et contient des objets des classes `SystemSettings` et `UserSettings`.
  - `SystemSettings` contient tous les paramètres que l'utilisateur n'est **pas** amené à modifier volontairement (du moins consciemment). Comme le choix d'API, le compte connecté ou s'il a ouvert tel ou tel dialogue, si c'est sa première ouverture.
  - `UserSettings` représente comme vous l'avez compris les choix de l'utilisateur ces paramètres lui sont souvent présentés avec des boutons interrupteurs.
- 2) En lisant 1) choisissez la bonne classe. 
  - Si c'est un `SystemSettings` ajoutez seulement un nouveau champ à la classe correspondante. **Vous devez :** 
    - Définir ce champ comme **non final** 
    - L'ajouter comme **required** dans le constructeur en tant que champ **optionnel** (mais finalement non puisque requis, c'est juste pratique pour le définir.)
    - L'ajouter dans le factory constructor `fromJson` pour pouvoir le lire depuis le JSON  
    - L'ajouter dans la fonction `toJson` pour pouvoir l'encoder en JSON
  - Si c'est un `UserSettings` vous devrez probablement créer une nouvelle classe de la forme `(Page / Service)Settings` puis suivre les mêmes instructions que pour un objet de la classe `SystemSettings`. Puis :
    - Ajoutez votre nouvelle classe à la classe parente `FormSettings` en tant que nouveau champ. Suivez l'exemple des autres champs déjà présents.
- 3) Pour l'utiliser dans votre code :
  - Pour **lire un paramètre** : 
  <br>Appelez simplement `appSys.settings.votreTypeDeParametre.votreParametre` n'importe où dans votre code.
  - Pour **écrire un paramètre** :
  <br>Modifiez votre paramètre de cette manière : <br>```appSys.settings.votreTypeDeParametre.votreParametre = nouvelleValeur;```
  <br>Puis sauvegardez-le : <br>`appSys.saveSettings();`. <br><br>C'est fait !

