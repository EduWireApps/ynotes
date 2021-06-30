import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/loggingUtils.dart';
import 'package:ynotes/ui/screens/cloud/cloudPage.dart';

//The basical function to change folder
Future<List<CloudItem>?> changeFolder(String path) async {
  ///I've chosen to not use their weird "Loaded function", user doesn't care about a little loading
  List paths = path.split("/");
  var finalPath = paths.sublist(2);

  var concatenate = StringBuffer();

  finalPath.forEach((item) {
    concatenate.write(r'\' + item);
  });
  var url = 'https://api.ecoledirecte.com/v3/cloud/W/$cloudUsedFolder.awp?verbe=get&idFolder=$concatenate';
  url = Uri.encodeFull(url);
  CustomLogger.log("ED", "Cloud url: $url");
  List<CloudItem> toReturn = [];

  Map<String, String> headers = {"Content-type": "text/plain"};
  String data = 'data={"token": "$token"}';

  var body = data;
  var response = await http.post(Uri.parse(url), headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
    if (req['code'] == 200) {
      List items = req["data"][0]["children"];

      items.forEach((element) {
        if (element["taille"] != 0) {
          toReturn.add(CloudItem(
              element["libelle"],
              element["type"].toString().toUpperCase(),
              element["proprietaire"] != null
                  ? element["proprietaire"]["prenom"] + " " + element["proprietaire"]["nom"]
                  : "",
              false,
              element["date"],
              id: element["id"]));
        }
      });
    } else {
      throw "Erreur durant la récupération des  éléments du cloud";
    }
  } else {
    throw "Erreur durant la récupération des éléments du cloud ${response.body}";
  }
  toReturn.sort((a, b) => a.date!.compareTo(b.date!));
  return toReturn;
}
