


class CloudItem {
  //E.G "test.txt"
  final String? title;
  //E.G "FILE"
  final String type;
  //E.G "Donald Trump"
  final String? author;
  //E.G true
  final bool isMainFolder;
  //E.G true
  final bool? isMemberOf;

  final String? id;
  final String? date;

  CloudItem(this.title, this.type, this.author, this.isMainFolder, this.date, {this.isMemberOf, this.id});
}
