import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/apis/pronote/converters_exporter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';

class PronotePollsConverter {
  static List<PollChoice>? pollChoices(PronoteClient client, List<Map>? choicesData) {
    List<PollChoice> pollChoices = [];
    choicesData?.forEach((choiceData) {
      String? choiceName = choiceData["L"];
      String? id = choiceData["N"];
      int? rank = choiceData["rang"];
      pollChoices.add(PollChoice(choiceName, id, rank));
    });
    return pollChoices;
  }

  ///Parse a poll question (or answer)
  static List<PollQuestion>? pollQuestions(PronoteClient client, List<Map>? pollsQuestionsData) {
    List<Map>? rawQuestions = pollsQuestionsData;
    List<PollQuestion> pollQuestions = [];
    for (var questionData in (rawQuestions ?? [])) {
      String? questionName = questionData["L"];
      String? question = questionData["texte"]["V"];
      String? id = questionData["N"];
      int? rank = questionData["rang"];
      String? answerID = questionData["reponse"]["V"]["N"];
      String? answer = questionData["reponse"]["V"]["valeurReponse"]["V"];
      List<PollChoice>? choices = pollChoices(client, questionData["listeChoix"]["V"].cast<Map>());
      pollQuestions.add(PollQuestion(
          questionName: questionName,
          question: question,
          id: id,
          rank: rank,
          choices: choices,
          answers: answer,
          answerID: answerID));
    }
    return pollQuestions;
  }

  static List<PollInfo> polls(PronoteClient client, Map pollsData) {
    List<Map>? listActus = pollsData['donneesSec']['donnees']['listeActualites']["V"].cast<Map>();
    List<PollInfo> listInfosPolls = [];
    listActus?.forEach((poll) {
      String? author = poll["elmauteur"]["V"]["L"];
      DateTime? start = DateFormat("dd/MM/yyyy").parse(poll["dateDebut"]["V"] ?? "");

      List<PollQuestion>? questions = pollQuestions(client, poll["listeQuestions"]["V"].cast<Map>());
      bool? read = poll["lue"];
      String? title = poll["L"];
      String? id = poll["N"].toString();

      List<Document>? documents = PronoteDocumentConverter.documents(poll["listePiecesJointes"]["V"]);
      bool? isPoll = poll["estSondage"];
      bool? isInformation = poll["estInformation"];
      bool? anonymous = poll["reponseAnonyme"];
      listInfosPolls.add(PollInfo(
          author: author,
          start: start,
          questions: questions,
          read: read,
          title: title,
          id: id,
          documents: documents,
          isPoll: isPoll,
          isInformation: isInformation,
          anonymous: anonymous));
    });
    return listInfosPolls;
  }
}
