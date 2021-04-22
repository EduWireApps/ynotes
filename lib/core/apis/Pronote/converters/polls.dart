import 'package:intl/intl.dart';
import 'package:ynotes/core/apis/Pronote/PronoteAPI.dart';
import 'package:ynotes/core/apis/Pronote/convertersExporter.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/nullSafeMap.dart';

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
    rawQuestions?.forEach((questionData) {
      String? questionName = mapGet(questionData, ["L"]);
      String? question = mapGet(questionData, ["texte", "V"]);
      String? id = mapGet(questionData, ["N"]);
      int? rank = mapGet(questionData, ["N"]);
      List<PollChoice>? choices = pollChoices(client, mapGet(questionData, ["listeChoix", "V"]));
      pollQuestions
          .add(PollQuestion(questionName: questionName, question: question, id: id, rank: rank, choices: choices));
    });
    return pollQuestions;
  }

  static List<PollInfo> polls(PronoteClient client, Map pollsData) {
    List<Map>? listActus = pollsData['donneesSec']['donnees']['listeActualites']["V"];
    List<PollInfo> listInfosPolls = [];
    listActus?.forEach((poll) {
      String? author = mapGet(poll, ["elmauteur", "V", "L"]);
      DateTime? start = DateFormat("dd/MM/yyyy").parse(mapGet(poll, ["dateDebut", "V"]) ?? "");
      List<PollQuestion>? questions = pollQuestions(client, mapGet(poll, ["listeQuestions", "V"]));
      bool? read = mapGet(poll, ["lue"]);
      String? title = mapGet(poll, ["L"]);
      String? id = mapGet(poll, ["N"]);
      List<Document>? documents = PronoteDocumentConverter.documents(mapGet(poll, ["listePiecesJointes", "V"]));
      bool? isPoll = mapGet(poll, ["estSondage"]);
      bool? isInformation = mapGet(poll, ["estInformation"]);
      bool? anonymous = mapGet(poll, ["reponseAnonyme"]);
      String? answers = mapGet(poll, ["reponse", "V", "valeurReponse", "V"]);
      listInfosPolls.add(PollInfo(
          author: author,
          start: start,
          questions: questions,
          read: read,
          title: title,
          id: id,
          documents: documents,
          answers: answers,
          isPoll: isPoll,
          isInformation: isInformation,
          anonymous: anonymous));
    });
    return listInfosPolls;
  }
}
