import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:html/parser.dart' show parse;

//https://institutsaintpierresaintpaul28.la-vie-scolaire.fr/vsn.main/dossierRecapEleve/afficheDetailNotes

class LvsDisciplineConverter {
  static get_disciplines(html) {
    List<Discipline> disciplines = [];
    parse(html).querySelectorAll("tr.odd, tr.even").forEach((element) {
      var grades =
          get_grades(element.querySelector("td.tdReleveRight")!.innerHtml);
      var title = element.querySelector("td.tdReleveLeft");
      var name = title!.querySelector('strong')!.innerHtml;
      var teacher =
          (title.innerHtml.substring(title.innerHtml.lastIndexOf('>') + 1))
              .replaceAll('  ', '');
      var average = element.querySelector("td.tdReleveMoy")!.innerHtml;
      disciplines.add(Discipline(
          // classGeneralAverage: '', one day...
          average: average,
          teachers: [teacher],
          disciplineName: name,
          periodName: 'periodeName',
          classNumber: 'classNumber',
          gradesList: grades,
          subdisciplineCodes: [],
          subdisciplineNames: []));
    });
    return disciplines;
  }

  static get_grades(html) {
    List<Grade> grades = [];
    html.split("</span>").forEach((grade) {
      if (grade.replaceAll(' ', '').toString().length > 1) {
        var name = grade.split(' :')[0];
        if (grade.substring(0, 3) == ' - ') {
          name = grade
              .split(' :')[0]
              .substring(0, grade.split(' :')[0].length - 13);
        }
        var value = grade.substring(grade.lastIndexOf('">') + ('">').length);

        grades.add(Grade(
            value: value.substring(0, value.indexOf('/')),
            testName: name,
            letters: true,
            weight: '',
            scale: value.substring(value.indexOf('/') + 1),
            min: '15',
            max: '20',
            classAverage: '20',
            date: new DateTime(2021),
            notSignificant: false,
            entryDate: new DateTime(2021),
            countAsZero: false));
      }
    });
    return grades;
  }

  static getPeriods(html) {
    List<String?> urls = [];
    html = parse(html);
    html
        .querySelector("ul.periodes")!
        .querySelectorAll('li.periode')
        .forEach((period) {
      var url = period.querySelector('a')!.attributes['href'].toString();
      urls.add(url);
    });
    return urls;
  }
}
