# Fonctionnement des APIs
yNotes autorise le fonctionnement avec n'importe quel système scolaire. Voici le fonctionnement général des APIs

## Fichier `(système scolaire).dart` (à la racine)
Ce fichier contient un extends de la classe API définie dans `model.dart`, il permet préférablement de se référer aux fonctions définies dans le fichier `(système scolaire)Methods.dart` contenu dans le **Dossier d'API du système scolaire** décrit juste après.  
## Dossiers d'API de systèmes scolaires
Chaque API est intégrée directement dans des sous dossiers à apis. Ces dossiers ont par convention le nom du système scolaire. La structure suivante est préférable : 
### **Dossier `/converters`**
Ce dossier contient des fichiers .dart nommés par convention `(type de donnée).dart` contenant des classes dont le nom est par convention `(système scolaire)(nom du type de donnée)Converter`, ces classes doivent contenir des fonctions statiques renvoyant de manière synchrone ou non des données scolaires.

### **Fichier  `convertersExporter.dart`**
Ce fichier permet d'importer tous les converters du dossier `/converters` sans devoir importer chaque fichier de converter. Ainsi, on importe ce fichier au lieu d'importer chaque fichier de converter un par un. 

Il contient des exports de ces fichers 

<ins>Exemple de contenu de `convertersExporter.dart`:</ins> 
```dart
export 'package:ynotes/core/apis/MonApi/converters/monObjet.dart';
```
<ins>Comment importer `convertersExporter.dart`:</ins> 
```dart
import 'package:ynotes/core/apis/MonApi/convertersExporter.dart';
```
### **Fichier `(système scolaire)Methods.dart`**
Ce fichier est adaptable à votre guise et permet d'alléger le contenu du fichier `(système scolaire).dart`

