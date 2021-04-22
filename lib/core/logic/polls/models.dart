import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

part 'models.g.dart';

class PollChoice {
  //question name/title
  final String? choiceName;
  final String? id;
  final int? rank;
  PollChoice(this.choiceName, this.id, this.rank);
}

@HiveType(typeId: 5)
class PollInfo {
  //E.G : M. Delaruelle
  @HiveField(0)
  final String? author;
  @HiveField(1)
  final DateTime? start;
  @HiveField(2)
  final List<PollQuestion>? questions;
  @HiveField(3)
  bool? read;
  @HiveField(4)
  final String? title;
  @HiveField(5)
  final String? id;
  @HiveField(6)
  final List<Document>? documents;
  //Brut data
  @HiveField(7)
  final Map? data;
  final String? answers;
  final bool? isPoll;
  final bool? isInformation;
  final bool? anonymous;
  PollInfo(
      {this.author,
      this.start,
      this.questions,
      this.read,
      this.title,
      this.id,
      this.documents,
      this.data,
      this.answers,
      this.isPoll,
      this.isInformation,
      this.anonymous});
}

class PollQuestion {
  //question name/title
  final String? questionName;
  //question body
  final String? question;
  final String? id;
  final int? rank;
  final List<PollChoice>? choices;
  PollQuestion({this.choices, this.questionName, this.question, this.id, this.rank});
}
