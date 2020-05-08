import 'dart:convert';
import 'dart:io';



import 'package:shared_preferences/shared_preferences.dart';

import 'package:tinycolor/tinycolor.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/landGrades.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
bool isDarkModeEnabled = false; 

class AppStateNotifier extends ChangeNotifier {
  
  bool isDarkMode =  false;
  
  void updateTheme(bool isDarkMode) {
 
    this.isDarkMode = isDarkMode;
    isDarkModeEnabled = isDarkMode; 

    notifyListeners();
  }
  

}
download(id, type, nomfichier) async
{
  try {
await testToken();
 var url =
      'https://api.ecoledirecte.com/v3/Eleves/$id/cahierdetexte.awp?verbe=get&';

  Map<String, String> headers = {"Content-type": "application/x-www-form-urlencoded"}; 


Map<String, dynamic> body = {'leTypeDeFichier': type, 'fichierId': id, 'token': token};

  var response =
      await http.post(url, headers: headers, body: body).catchError((e) {
    throw ("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou réessayez plus tard.");
  });

  if (response.statusCode == 200) {
   Directory downloadsDirectory = await getExternalStorageDirectory();
String path =downloadsDirectory.path;
print(path);
var fileSave = new File('$path/test.txt');


        fileSave.writeAsBytes(response.bodyBytes).catchError((onError){
          print(onError);
        });
        print(fileSave.path);
      }
     
   else {
      throw "Erreur durant la récupération des devoirs";
    }
 }
 catch (e)
 {
   print(e);
 }
}
Route router(Widget widget) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(1.0, 0.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
///Color theme switcher, actually 0 for darkmode and 1 for lightmode
int colorTheme = 0;
String actualUser;
Color GetColorFor(String element)
{
  if (colorTheme==0)
  {
switch (element)
{
  case "menuForeground":
  {

  }
  break;
   case "generalBackground":
  {
return Color(0xff141414);
  }
  break;
  

}
if (colorTheme==1)
{
switch (element)
{
  case "menuForeground":
  {

  }
  break;
   case "generalBackground":
  {
return Color(0xff141414);
  }
  break;
  

}
}
}
}

 ThemeData darkTheme= ThemeData(
  backgroundColor: Color(0xff1F1E1E),
  primaryColor: Color(0xff2C2C2C),
  //In reality that is primary ColorLighter
  primaryColorDark: Color(0xff404040) ,
 indicatorColor: Color(0xff404040),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black
  )

  );
   ThemeData lightTheme = ThemeData(
  backgroundColor: Colors.white,
  primaryColor: Color(0xffF3F3F3),
  primaryColorDark: Color(0xffDCDCDC),
  indicatorColor: Color(0xffDCDCDC),
  tabBarTheme: TabBarTheme(
    labelColor: Colors.black
  )
  );
Future<bool> getSetting(String setting) async
{
  final prefs = await SharedPreferences.getInstance();
  bool value = prefs.getBool(setting);
  if (value==null)
    {
      setSetting(setting, false);
      value = false;
    }
  return value;

}
setSetting(String setting, bool value) async
{
  final prefs = await SharedPreferences.getInstance();
  prefs.setBool(setting, value);

}
///Make the selected color darker
Color darken(
  Color color, {double forceAmount}
) {
 double amount = 0.05;
  var ColorTest = TinyColor(color);
  //Test if the color is not too light
  if(forceAmount==null)
  {
   
  if (ColorTest.isLight()) {
    amount = 0.2;
  }
  //Test if the color is something like yellow
  if (ColorTest.getLuminance() > 0.5) {
    amount = 0.2;
  }
if (ColorTest.getLuminance() < 0.5) {
    amount = 0.18;
  }

  }
   else {
amount = forceAmount;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}
