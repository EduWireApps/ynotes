# yNotes
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->
<img src="https://github.com/ModernChocolate/ynotes/blob/master/screenshots/brandLarge.png" width="800">

yNotes est un gestionnaire de notes, d'emploi du temps et de devoirs qui vous permet d'accéder à toutes vos informations scolaires dans une interface moderne et intuitive. L'application actuelle est basée sur les APIs des sites **École Directe** et **Pronote**. Je travaille actuellement dur pour adapter l'application à d'autres "applications scolaires". 

Téléchargez dès maintenant yNotes sur le [Google Play Store](https://play.google.com/store/apps/details?id=fr.ynotes) !

yNotes est un projet ouvert et collaboratif ! N'hésitez pas à soumettre une pull request ou me contacter directement pour aider au projet **(discord : JsonLines
#0721)**.

__yNotes n'est **pas un client officiel** et utilise directement les APIs d'applications scolaires. Vos identifiants sont chiffrés et stockés sur votre appareil, mais nous ne nous portons pas responsables en cas de sanction de l'application scolaire. De plus, les fonctionnalités proposées par yNotes peuvent varier à tout moment, par décision externe ou interne.__

J'ai décidé de créer yNotes en constatant que les demandes des utilisateurs des applications scolaires n'étaient pas écoutées, et que les applications mobiles de vie scolaire étaient basiques, à l'interface peu élaborée. Bien que la propriété intellectuelle m'empêche de diffuser yNotes à grande ampleur, j'espère que les éditeurs des applications scolaires entendront un jour nos réclamations !

## Fonctionnalités 
Les fonctionnalités de yNotes s'étendent chaque jour pour permettre d'être le plus efficace dans son travail, et l'interface est régulièrement revue pour être la plus intuitive possible.
#### Fonctionnalités mises en place


- Accès au notes : Affichage des notes et des données liées, partage des notes (en cours), tri des notes
- Accès aux devoirs : Accès aux prochains devoirs, affichage des pièces jointes liées (en cours)
- Coloration des matières personnalisable
- Mode nuit
- Application hors ligne, nul besoin d'Internet pour accéder à ses notes 
- Accès aux applications supplémentaires : mail et cloud (disponible sur École Directe)
- Ajout aux favoris de devoirs. (fonctionnalité d'épinglage)
- ~~Mise en place d'un "Quick menu" (menu rapide) pour accéder rapidement aux documents téléchargés~~ (supprimé car non intuitif)
#### Fonctionnalités à venir

- Fonctionnalités supplémentaires dans l'affichage des devoirs, partage et recherche rapide par mot-clé (partenariat avec applications scolaires ?)
- Visualisation de l'emploi du temps et organisation de la vie d'étudiant
- yNotes web
- ~~Ajout de la foncionnalité envoyer des mails au Quick menu,~~ ~~devoirs favoris~~
~~- Multicomptes~~ (abandonné)

## Compatibilité (apps scolaires)
yNotes se veut multi compatible et ainsi permettre un portage vers n'importe quelle application scolaire à l'aide d'une API. Cette implémentation n'est pas encore faite et demande du travail, mais sera faite le plus rapidement possible pour permettre à n'importe qui de créer son parser vers une application scolaire. Peut-être même de rendre l'application internationale ?
*Note du **01/08** la connexion via Pronote est quasiment effective en connexion directe (?login=true à la fin de l'adresse ou sans ENT). L'intégration des ENT va bientôt commencer.*

## Fonctionnalité générale Space
Space, pour espace de l'étudiant, est un algorithme qui permettrait à l'étudiant d'aménager sa vie en fonction de son emploi du temps tout en suggérant un plan de travail.

#### Est-ce que Space existe ?

Soyons clair, Space n'est absolument pas implémenté, mais compte l'être le plus rapidement possible car il constitue une pièce maîtresse du projet yNotes.

#### Mode de fonctionnement

Space se baserait sur l'emploi du temps de l'utilisateur, importé grâce aux APIs des applications scolaires. Puis ce dernier pourra ajouter manuellement les évènements, cours extrascolaires, activités auxquelles l'utilisateur participe régulièrement ou non. yNotes suggérera des idées d'organisation de rendez-vous, et évaluera le risque d'un rendez-vous non obligatoire si ce dernier se situe avant un contrôle important.
#### Les contraintes

Sans devenir un laboratoire, Space devra se baser sur un algorithme intelligent, sans se montrer trop intrusif, ni collecter de données. En effet ces dernières ne doivent êtres stockées que localement, et ne peuvent être sujettes à des traitements extérieurs a l'application.

## Comment utiliser l'application
L'application est développée avec le framework Flutter, et donc développée en Dart.

### Depuis les releases officielles
Si vous êtes utilisateur et souhaitez télécharger l'application sur votre smartphone, vous pouvez :
#### Android :
- Télécharger la dernière release (.apk) [ici](https://github.com/ModernChocolate/ynotes/releases)
- Vous rendre sur le site de yNotes pour vous inscrire à la newsletter et être informé des dernières nouveautés et recevoir votre application
- Tester la dernière bêta pour tester les fonctionnalités en avant première ici
- Compiler vous même votre application
#### IOS :
- Étant donné que les frais d'inscriptions obligatoires pour devenir Apple Developer sont hors budgets, vous ne pourrez pas trouver l'application sur l'App Store. Vous pouvez donc compiler l'application à l'étape suivante si vous possédez un Mac.


### Compilation 

La compilation permet de créer une application interprétable par un appareil donné, dans notre cas votre smartphone à partir d'un code source.

Il est conseillé de procéder à l'installation guidée indiquée par [la documentation officielle de Flutter](https://flutter.dev/docs/get-started/install).

Notez que pour compiler l'application pour iOS, il vous faut absolument un ordinateur Mac.

Téléchargez une version officielle du code source de l'application depuis cette page, si vous êtes utilisateur, préférez la branche stable, sinon vous pouvez essayer de compiler une version bêta de yNotes. 

Ouvrez le dossier du code source dans votre éditeur favori (VSCode, Android Studio, XCode). 

Assurez vous que votre téléphone est connecté à votre ordinateur si vous souhaitez directement compiler l'application sur ce dernier et vérifiez les conditions suivantes.

Suivez les étapes de compilation de la documentation officielle :
* [Compiler pour Android](https://flutter.dev/docs/deployment/android)
* [Compiler pour iOS](https://flutter.dev/docs/deployment/ios)
*Vous devez disposer d'un compte Apple Developer gratuit (ou payant) pour installer l'application sur un appareil iOS*

## Documentation 
La documentation spécifique au développement vous permettant de modifier les layouts selon vos goûts, ajouter vos fonctionnalités, votre touche.

Le fichier principal (exécuté en premier) est `/lib/main.dart`

### Front-end
Tout le code peut être organisé dans des fichiers .dart, l'UI comme le backend, mais les layouts sont situés dans `/lib/UI`
décomposés par écrans (screens) et par composants (components).

### Back-end
Le traitement des données est maintenant effectué dans des parsers distincts situés dans `/lib/parsers`
Ces fichiers contiennent des classes étendues de la classe API disponible dans le fichier `/lib/APIManager.dart` qui contient également toutes les classes importantes de l'application. L'ajout de fonctionnalités spécifiques nécessite une modification de l'APIManager ce qui est fortement déconseillé. Ainsi la fonction `app()` permet l'ajout de fonctionnalités spéficiques en toute liberté.

### Ressources
Les ressources sont dans `/assets`
On y distingue les animations, (utilisant le moteur de rendu *Flare*, qui diffèrent des animations dans `/lib/UI/animations` qui sont des animations utilisant le langage Dart) ainsi que les images et les gifs animés.

### Mentions spéciales
* Merci aux développeurs et bêta testeurs qui ont aidé à participer au projet en me suggérant des fonctionnalités et en montrant des bugs que je n'aurai sûrement jamais remarqués
* L'API Pronote est un portage de [pronotepy](https://github.com/bain3/pronotepy), développée par [bain](https://github.com/bain3) que je remercie énormément pour ses explications et sa disponibilité :)

## Contributeurs ✨

Je tiens à remercier chaque autre personne ne figurant pas dans cette section pour avoir testé yNotes, collaboré d'une manière ou d'une autre pour la création de l'application et m'avoir donné des idées pour l'améliorer.
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="http://taokann.one"><img src="https://avatars1.githubusercontent.com/u/38343089?v=4?s=100" width="100px;" alt=""/><br /><sub><b>taokann.one</b></sub></a><br /><a href="https://github.com/ModernChocolate/ynotes/issues?q=author%3Ataokann" title="Bug reports">🐛</a> <a href="#ideas-taokann" title="Ideas, Planning, & Feedback">🤔</a> <a href="#userTesting-taokann" title="User Testing">📓</a></td>
    <td align="center"><a href="https://florian-lefebvre.dev"><img src="https://avatars1.githubusercontent.com/u/69633530?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Florian LEFEBVRE</b></sub></a><br /><a href="https://github.com/ModernChocolate/ynotes/issues?q=author%3Aflorian-lefebvre" title="Bug reports">🐛</a> <a href="#ideas-florian-lefebvre" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="http://bain.cz"><img src="https://avatars0.githubusercontent.com/u/31798786?v=4?s=100" width="100px;" alt=""/><br /><sub><b>bain3</b></sub></a><br /><a href="#ideas-bain3" title="Ideas, Planning, & Feedback">🤔</a> <a href="#plugin-bain3" title="Plugin/utility libraries">🔌</a></td>
    <td align="center"><a href="https://github.com/ShiyukiNeko"><img src="https://avatars3.githubusercontent.com/u/47981502?v=4?s=100" width="100px;" alt=""/><br /><sub><b>ShiyukiNeko</b></sub></a><br /><a href="#ideas-ShiyukiNeko" title="Ideas, Planning, & Feedback">🤔</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
