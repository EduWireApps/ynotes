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

class Workspace {
  //E.G "test.txt"
  final String? title;
  final String? id;
  final String? author;
  final bool? isMemberOf;
  final List<WorkspacePostIt>? postIts;
  Workspace({
    this.title,
    this.id,
    this.author,
    this.postIts,
    this.isMemberOf,
  });
}

class WorkspacePostIt {
  final String? author;
  final String? type;
  final String? content;
  WorkspacePostIt({this.author, this.type, this.content});
}
