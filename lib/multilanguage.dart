import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// FEEL FREE TO LOAD THIS CLASS WITH YOUR CURRENT JSOM FILES
/// REMEMBER YOU SHOULD LOAD IT FIRST IN YOUR PUBSPEC.YAML
class Languages {
  static const String fr = 'locale/i18n_fr.json';

}

/// THE NAME OF CURRENT JSON FILE INSIDE THE APP CACHE
String _langKey = 'lang';

/// THE NAME OF THE CLASS WHICH MANAGES THE MULTI-LANGUAGE PACKAGE
class MultiLanguage {
  Map<String, dynamic> phrases;
  MultiLanguage(this.phrases);

  /// SET THE LANGUAGE METHOD
  /// USES PATH FROM [LANGUAGES] TO GET THE FILE
  /// USES CONTEXT TO GET THE FULL PATH
  static setLanguage(
      {@required String path, @required BuildContext context}) async {
    /// GETS THE SHARE PREFERENCES INSTANCE
    final prefs = await SharedPreferences.getInstance();

    /// VALIDATES IF THE PATH EXIST INSIDE THE PHONE
    if (prefs.getString(_langKey) != null) path = prefs.getString(_langKey);

    /// GETS THE FILE PATH
    var file = await DefaultAssetBundle.of(context).loadString(path);

    /// SETS THE FILE INSIDE THE PHONE
    prefs.setString(_langKey, path);

    /// LOADS THE JSON FILE INSIDE THE MULTILANG
    multilang = MultiLanguage(jsonDecode(file));
  }

  /// GET METHOD RETURNS THE STRING FROM THE JSON FILE CREATED
  String get(String key) {
    /// IF STRING DON'T EXIST JUST RETURNS THE NAME OF THE STRING YOU WANTED TO SEARCH
    return phrases != null ? phrases[key] : key;
  }
}

/// INITIALIZE THE MULTILANG - YOU WILL BE USING THIS AROUND YOUR APPLICATION
MultiLanguage multilang = MultiLanguage(null);

/// SHORTCUT FOR THE GETTER TEXT
Function(String key) get txt => multilang.get;

/// SHORTCUT FOR THE GETTER UPPERCASE TEXT
Function(String key) get uptxt =>
    (String key) => multilang.get(key).toUpperCase();
