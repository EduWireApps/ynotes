import 'package:hive/hive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';

part 'models.g.dart';

@HiveType(typeId: 13)
class PollChoice {
  //question name/title
  @HiveField(0)
  final String? choiceName;
  @HiveField(1)
  final String? id;
  @HiveField(2)
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
  @HiveField(8)
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
  @HiveField(10)
  final bool? isPoll;
  @HiveField(11)
  final bool? isInformation;
  @HiveField(12)
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
      this.isPoll,
      this.isInformation,
      this.anonymous});
}

@HiveType(typeId: 12)
class PollQuestion {
  //question name/title
  @HiveField(1)
  final String? questionName;
  //question body
  @HiveField(2)
  final String? question;
  @HiveField(3)
  final String? id;
  @HiveField(4)
  final int? rank;
  @HiveField(5)
  final List<PollChoice>? choices;
  @HiveField(6)
  final String? answers;
  @HiveField(7)
  final String? answerID;
  PollQuestion({
    this.choices,
    this.questionName,
    this.question,
    this.id,
    this.rank,
    this.answers,
    this.answerID,
  });
}
