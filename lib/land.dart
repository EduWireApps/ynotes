import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
final storage = new FlutterSecureStorage();
//Create a secure storage
void CreateStorage(String key, String data) async
{
  await storage.write(key: key, value: data);
}

class connexionRequest {
  final int code;
  final String token;
  final String message;
  final String name;

  connexionRequest({this.code, this.token, this.message, this.name});

  factory connexionRequest.fromJson(Map<String, dynamic> json) {
    return connexionRequest(
      code: json['code'],
      token: json['token'],
      message: json['message'],
      name: json['prenom'],
    );
  }
}


Future<String> connectionStatus(username, password) async {
  final prefs = await SharedPreferences.getInstance();
  if(username==null)
    {
      username="";
    }
  if(password==null)
  {
    password="";
  }

  var url ='https://api.ecoledirecte.com/v3/login.awp';
  Map<String, String> headers = {"Content-type": "texet/plain"};
  String data = 'data={"identifiant": "$username", "motdepasse": "$password"}';
  //encode Map to JSON
  var body = data;
  var response = await http.post(url, headers: headers,
      body: body
  ).catchError((e) {
    throw("Impossible de se connecter. Essayez de vérifier votre connexion à Internet ou reessayez plus tard.");

   });

  if (response.statusCode == 200) {

    Map<String, dynamic> req = jsonDecode(response.body);

    if(req['code']==200)
      {
        //Put the value of the name in a variable
        String name = req['data']['accounts'][0]['prenom'];
        //Create secure storage for credentials
        CreateStorage("password", password);
        CreateStorage("username", username);
        //Ensure that the user will not see the carousel anymore
        prefs.setBool('firstUse', false);
        return "Bienvenue ${name[0].toUpperCase()}${name.substring(1).toLowerCase()} !";

     }
    //Return an error
    else {
        String message = req['message'];
        throw "Oups ! Une erreur a eu lieu :\n$message";
    }

  }
  else {
   throw "Erreur";

   // print(req["code"]);
  }
}
