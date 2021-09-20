import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/pronote/pronote_api.dart';
import 'package:ynotes/core/apis/pronote/converters_exporter.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/null_safe_map_getter.dart';

class PronotePollsConverter {
  static List<PollChoice>? pollChoices(PronoteClient client, List<Map>? choicesData) {
    List<PollChoice> pollChoices = [];
    choicesData?.forEach((choiceData) {
      String? choiceName = mapGet(choiceData, ["L"]);
      String? id = mapGet(choiceData, ["N"]);
      int? rank = mapGet(choiceData, ["rang"]);
      pollChoices.add(PollChoice(choiceName, id, rank));
    });
    return pollChoices;
  }

  ///Parse a poll question (or answer)
  static List<PollQuestion>? pollQuestions(PronoteClient client, List<Map>? pollsQuestionsData) {
    List<Map>? rawQuestions = pollsQuestionsData;
    List<PollQuestion> pollQuestions = [];
    for (var questionData in (rawQuestions ?? [])) {
      String? questionName = mapGet(questionData, ["L"]);
      String? question = mapGet(questionData, ["texte", "V"]);
      String? id = mapGet(questionData, ["N"]);
      int? rank = mapGet(questionData, ["rang"]);
      String? answerID = mapGet(questionData, ["reponse", "V", "N"]);
      String? answer = mapGet(questionData, ["reponse", "V", "valeurReponse", "V"]);
      List<PollChoice>? choices = pollChoices(client, mapGet(questionData, ["listeChoix", "V"]).cast<Map>());
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
      String? author = mapGet(poll, ["elmauteur", "V", "L"]);
      DateTime? start = DateFormat("dd/MM/yyyy").parse(mapGet(poll, ["dateDebut", "V"]) ?? "");

      List<PollQuestion>? questions = pollQuestions(client, mapGet(poll, ["listeQuestions", "V"]).cast<Map>());
      bool? read = mapGet(poll, ["lue"]);
      String? title = mapGet(poll, ["L"]);
      String? id = mapGet(poll, ["N"]).toString();

      List<Document>? documents = PronoteDocumentConverter.documents(mapGet(poll, ["listePiecesJointes", "V"]));
      bool? isPoll = mapGet(poll, ["estSondage"]);
      bool? isInformation = mapGet(poll, ["estInformation"]);
      bool? anonymous = mapGet(poll, ["reponseAnonyme"]);
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
