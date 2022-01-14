import 'dart:math';

class AnonymizerUtils {
  static const defaultFilter = {
    "token": "YToken.dart",
    "prenom": "Harry",
    "nom": "Potter",
    "identifiant": "harry.thebeast",
    "nomEtablissement": "Poudlard",
    "rneEtablissement": "0000",
    "sexe": "NB",
    "email": "harry.potter@gmail.com",
    "photo": "https://picsum.photos/200/300",
    "uid": "000"
  };
  static String generateRandomString(int len) {
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random _rnd = Random();
    return String.fromCharCodes(Iterable.generate(len, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  static keyValueReplacer(String data, String key, String valueReplaced) {
    final newString = data.replaceAllMapped(RegExp(r'"' + key + r'":\r?"[a-zA-Z0-9_,.-\s]*"'), (match) {
      return r'"' + key + r'":"' + valueReplaced + r'"';
    });

    return newString;
  }

  static severalValues(String data, Map dic) {
    dic = dic..addAll(defaultFilter);
    dic.forEach((key, value) {
      data = keyValueReplacer(data, key, value);
    });
    return data;
  }
}
