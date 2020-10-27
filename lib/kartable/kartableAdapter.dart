import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

//Getting the related lessons in the dictionnary from the string content

Future<List<Map>> gettingRelatedLessons(String content) async {
  try {
    print("Getting Kartable related lessons");
    //Getting the json from the dictionnary
    Map jsonMap;
    try {
      jsonMap = json.decode(await rootBundle.loadString('assets/lessons.json'));
    } catch (e) {
      print(e);
    }
  
    List lessons = jsonMap["dictionnary"];
    List<Map> maps = List();
//testing each lesson
    lessons.forEach((lesson) {
      List keywords = lesson["keywords"];
      if (keywords.any(
          (e) => content.toLowerCase().contains(e.toString().toLowerCase()))) {
        maps.add({
          "discipline": lesson["discipline"],
          "theme": lesson["theme"],
          "chapter": lesson["chapter"],
          "keywords": lesson["keywords"],
          "url": lesson["url"]
        });
//Delete duplicates

      }
    });
    maps = maps.toSet().toList();
    return maps;
  } catch (e) {
    print("Kartable adapter error :" + e);
    return null;
  }
}
