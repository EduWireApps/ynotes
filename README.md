# yNotes
yNotes est un gestionnaire de notes, d'emploi du temps et de devoirs qui vous permet de voir toutes ces informations scolaires dans une interface moderne et intuitive. L'application actuelle est basée sur les APIs du site **EcoleDirecte**. Je travaille actuellement dur pour adapter l'application à d'autres "applications d'accès aux devoirs". 
## Fonctionnalités 
Les fonctionnalités de yNotes s'étendent chaque jour pour permettre d'être le plus efficace dans son travail, et l'interface est régulièrement revue pour être la plus intuitive possible

#### Fonctionnalités mises en place
- Accès au notes : Affichage des notes et des données liées, partage des notes (en cours), tri des notes
- Accès aux devoirs : Accès aux prochains devoirs, affichage des pièces jointes liées (en cours)
- Coloration des matières personnalisable
- Mode nuit

#### Fonctionnalités à venir
- Application hors ligne, nulle besoin d'Internet pour accéder à ses notes 
- Fonctionnalités supplémentaires dans l'affichage des devoirs, ajout aux favoris, partage et recherche rapide par mot clé (partenariat avec applications scolaires ?)
- Visualisation de l'emploi du temps et organisation de la vie d'étudiant
- Mise en place d'un "Quick menu" pour accéder rapidement aux documents téléchargés, envoyer des mails, devoirs favoris
- Accès aux applications supplémentaires : mail et cloud
- Multicomptes

## Compatibilité (apps scolaires)
yNotes se veut multi compatible et ainsi permettre un portage vers n'importe quelle application scolaire à l'aide d'une API. Cette implémentation n'est pas encore faite et demande du travail, mais sera faite le plus rapidement possible pour permettre à n'importe qui de créer son parser vers une application scolaire. Peut-être même de rendre l'application internationale ?


## Fonctionnalité générale Space
Space, pour espace de l'étudiant, est un algorithme qui permettrait à l'étudiant d'aménager sa vie en fonction de son emploi du temps tout en suggérant un plan de travail.

#### Est-ce que Space existe ?

Soyons clair, Space n'est absolument pas implémenté, mais compte l'être le plus rapidement possible car il constitue une pièce maîtresse du projet yNotes.

#### Mode de fonctionnement

Space se baserait sur l'emploi du temps de l'utilisateur, importé grâce aux APIs des applications scolaires. Puis ce dernier pourra ajouter manuellement les évènements, cours extrascolaires, activités auquel il assiste régulièrement ou non. yNotes suggérera des idées d'organisation de rendez-vous, le risque d'un rendez-vous non obligatoire si ce dernier se situe avant un contrôle important.
#### Les contraintes

Sans devenir un laboratoire, Space devra se baser sur un algorithme intelligent, sans se montrer trop intrusif, ni collecter de données. En effet ces dernières ne doivent êtres stockées que localement, et ne peuvent être sujettes à des traitements extérieurs a l'application.

## Comment utiliser l'application
L'application est développée avec le framework Flutter, et donc développée en dart.

### Depuis les releases officielles
Si vous êtes utilisateur et souhaitez télécharger l'application sur votre smartphone, vous pouvez :
#### Android :
- Télécharger la dernière release (.apk) ici
- Vous rendre sur le site de yNotes pour vous inscrire à la newsletter et être informé des dernières nouveautés et recevoir votre application
- Tester la dernière bêta pour tester les fonctionnalités en avant première ici
- Compiler vous même votre application
#### IOS :
- Étant donné que les frais d'inscriptions obligatoires pour devenir Apple Developper sont hors budgets, vous ne pourrez pas trouver l'application sur un marché alternatif. Vous pouvez donc compiler l'application à l'étape suivante si vous possédez un Mac.


### Compilation 

La compilation permet de créer une application interprétable par un appareil donné, dans notre cas votre smartphone à partir d'un code source.

Il est conseillé de procéder à l'installation guidée indiquée par la documentation officielle de Flutter.

Notez que pour compiler l'application pour iOS, il vous faut absolument un ordinateur Mac.

Téléchargez une version officielle du code source de l'application depuis cette page, si vous êtes utilisateur, préférez la branche stable, sinon vous pouvez essayer de compiler une version bêta de yNotes. 

- La dernière version stable

Ouvrez le dossier du code source dans votre éditeur favori. 

Assurez vous que votre téléphone est connecté à votre ordinateur si vous souhaitez directement compiler l'application sur ce dernier et vérifiez les conditions suivantes.

Suivez les étapes de compilation de la documentation officielle.

## Documentation 
La documentation spécifique au développement vous permettant de modifier les layouts selon vos goûts, ajouter vos fonctionnalités, votre touche.

Le fichier principal (exécuté en premier) est `/lib/main.dart`

### Front-end
Tout le code peut être organisé dans des fichiers .dart, l'UI comme le backend, mais les layouts sont situés dans `/lib/UI`
décomposés par "pages".

### Back-end
Le traitement des données comme les devoirs ou les notes se fait dans les fichiers du dossier `/lib` précédés par land (pour atterrissage), ici `landHomework.dart` et `landGrades.dart` sont hardcodés pour uniquement permettre une utilisation d'Ecole Directe mais se veulent remplacés par une API universelle. Les parsers seront placés dans `/lib/parsers/(service scolaire EX : EcoleDirecte).dart`

### Ressources
Les ressources sont dans `/assets`
On y distingue les animations, (utilisant le moteur de rendu *Flare*, qui diffèrent des animations dans `/lib/UI/animations` qui sont des animations utilisant le langage Dart) ainsi que les images.