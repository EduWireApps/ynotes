import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:alice/alice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:quiver/collection.dart';
import 'package:flutter/material.dart';
import 'package:stack/stack.dart' as sta;
import 'package:ynotes/UI/screens/apps/cloud.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/offline.dart';
import 'package:ynotes/apiManager.dart';
import 'package:dio/dio.dart' as dio2;

//The basical function to change folder
changeFolder(String path) async {
  print(path);
///I've chosen to not use their shitty "Loaded function", user doesn't care about a little loading
  List paths = path.split("/");
  var finalPath= paths.sublist(2);


 var concatenate = StringBuffer();

  finalPath.forEach((item){
    concatenate.write(r'\'+item);
  });
  var url ='https://api.ecoledirecte.com/v3/cloud/W/${cloudUsedFolder}.awp?verbe=get&idFolder=${concatenate}';
  url= Uri.encodeFull(url);
  print(url);
 List<CloudItem> toReturn = List();
 
    Map<String, String> headers = {"Content-type": "text/plain"};
    String data = 'data={"token": "$token"}';

    var body = data;
    var response =
        await http.post(url, headers: headers, body: body).catchError((e) {
      throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
    });

    if (response.statusCode == 200) {
     

      Map<String, dynamic> req = json.decode(utf8.decode(response.bodyBytes));
      if (req['code'] == 200) {
        List items = req["data"][0]["children"];

        items.forEach((element) {
       if(element["taille"]!=0)
       {

       
          toReturn.add(CloudItem(
              element["libelle"],
              element["type"].toString().toUpperCase(),
              element["proprietaire"] != null
                  ? element["proprietaire"]["prenom"]+" "+element["proprietaire"]["nom"]
                  : "",
              false,
              element["date"],
              id: element["id"],
              isLoaded: element["isLoaded"]));
       }
        });
        
      } else {
        throw "Erreur durant la récupération des  éléments du cloud";
      }
    } else {
      throw "Erreur durant la récupération des éléments du cloud ${response.body}";
    }
    toReturn.sort((a, b) => a.date.compareTo(b.date));
    return toReturn;
  }

 

