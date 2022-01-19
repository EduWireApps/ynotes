part of pronote_client;

Map errorMessages = {
  22: '[ERROR 22] The object was from a previous session. Please read the "Long Term Usage" section in README on github.',
  10: '[ERROR 10] Session has expired and pronotepy was not able to reinitialise the connection.'
};
bool isOldAPIUsed = false;

Uint8List int32BigEndianBytes(int value) => Uint8List(4)..buffer.asByteData().setInt32(0, value, Endian.big);

//Remove some random security in challenge
prepareTabs(var tabsList) {
  List output = [];
  if (tabsList.runtimeType != List) {
    return [tabsList];
  }
  tabsList.forEach((item) {
    if (item.runtimeType == Map) {
      item = item.values();
    }
    output.add(item);
  });
  return output;
}

removeAlea(String text) {
  List sansalea = [];
  int i = 0;
  for (var rune in text.runes) {
    var character = String.fromCharCode(rune);
    if (i % 2 == 0) {
      sansalea.add(character);
    }
    i++;
  }

  return sansalea.join("");
}

class PronoteUtils {
  gradeTranslate(String value) {
    List gradeTranslate = [
      'Absent',
      'Dispensé',
      'Non noté',
      'Inapte',
      'Non rendu',
      'Absent zéro',
      'Non rendu zéro',
      'Félicitations'
    ];
    if (value.contains("|")) {
      return gradeTranslate[int.parse(value[1]) - 1];
    } else {
      return value;
    }
  }

  shouldCountAsZero(String grade) {
    if (grade == "Absent zéro" || grade == "Non rendu zéro") {
      return true;
    } else {
      return false;
    }
  }
}
