import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/land.dart';
import 'package:shimmer/shimmer.dart';
import 'package:async/async.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:random_color/random_color.dart';

class gradesPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _gradesPageState();

  }
}

String periodeToUse = "A002";
bool firstStart = true;
Future gradeListFuture;

class _gradesPageState extends State<gradesPage> {
  PageController todoSettingsController;

  void initState() {
    super.initState();
    todoSettingsController = new PageController(initialPage: 0);
    initializeDateFormatting("fr_FR", null);
    if (firstStart == true) {
      getLocalGradesList();
      firstStart = false;
    }
  }

  getLocalGradesList() async {
    gradeListFuture = getNotesAndDisciplines();
  }

  Future<void> refreshLocalGradeList() async {
    setState(() {
      gradeListFuture = getNotesAndDisciplines();
    });
  }

  getActualPeriode() async {
    List<grade> list = await getNotesAndDisciplines();
    periodeToUse = list.last.codePeriode;
  }

  getDisciplinesForPeriod(List<discipline> list, periode) {
    List<discipline> toReturn = new List<discipline>();
    list.forEach((f) {
      if ("A00" + f.periode == periode) {
        toReturn.add(f);
      }
    });

    return toReturn;
  }

  getCorrespondingPeriod(String period) {
    switch (period) {
      case "A001":
        {
          return "Trimestre 1";
        }
        break;

      case "A002":
        {
          return "Trimestre 2";
        }
        break;

      case "A003":
        {
          return "Trimestre 3";
        }
        break;

      case "Trimestre 1":
        {
          return "A001";
        }
        break;

      case "Trimestre 2":
        {
          return "A002";
        }
        break;

      case "Trimestre 3":
        {
          return "A003";
        }
        break;

      default:
        {
          return "";
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
//Convert A001 to Periode 1 and reverse

    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(
          top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 3),
      height: screenSize.size.height / 10 * 8.8,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
              width: (screenSize.size.width / 5) * 1.5,
              decoration: ShapeDecoration(
                shape: StadiumBorder(),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: getCorrespondingPeriod(periodeToUse),
                      iconSize: 0.0,
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Asap",
                          color: Colors.black),
                      onChanged: (String newValue) {
                        setState(() {
                          periodeToUse = getCorrespondingPeriod(newValue);
                        });
                      },
                      items: <String>[
                        'Trimestre 1',
                        'Trimestre 2',
                        'Trimestre 3'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
              width: (screenSize.size.width / 5) * 1.5,
              child: FittedBox(
                child: RaisedButton(
                  color: Colors.white,
                  shape: StadiumBorder(),
                  onPressed: () {},
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.sort),
                      Text(
                        "Trier",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Asap",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        RefreshIndicator(
          onRefresh: refreshLocalGradeList,
          child: Container(
            width: screenSize.size.width / 5 * 4.5,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 7.5,
            margin: EdgeInsets.only(
                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 2.67,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2.67),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
                color: Color(0xff2C2C2C)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: FutureBuilder<void>(
                    future: gradeListFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: getDisciplinesForPeriod(
                                    disciplinesList, periodeToUse)
                                .length,
                            padding:
                                EdgeInsets.all(screenSize.size.width / 5 * 0.3),
                            itemBuilder: (BuildContext context, int index) {

                              return GradesGroup(
                                disciplinevar: getDisciplinesForPeriod(
                                    disciplinesList, periodeToUse)[index],
                                grades: snapshot.data,
                              );

                            });
                      } else {
                        return ListView.builder(
                            itemCount: 5,
                            padding:
                                EdgeInsets.all(screenSize.size.width / 5 * 0.3),
                            itemBuilder: (BuildContext context, int index) {
                              return GradesGroup();
                            });

                      }
                    })),
          ),
        ),
      ]),
    );
  }
}

class GradesGroup extends StatefulWidget {
  final discipline disciplinevar;

  final List<grade> grades;

  const GradesGroup({this.disciplinevar, this.grades});
  State<StatefulWidget> createState() {
    return _GradesGroupState();
  }
}
RandomColor _randomColor =  RandomColor();
class _GradesGroupState extends State<GradesGroup> {

  Color colorGroup = _randomColor.randomColor(
      colorBrightness: ColorBrightness.light,
      colorSaturation: ColorSaturation.lowSaturation
  );
  ScrollController controller = ScrollController();
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    //BLOCK BUILDER
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: screenSize.size.width / 5 * 3,
      //height: (screenSize.size.height / 10 * 8.8) /10 * 1.3,
      child: Stack(
        children: <Widget>[
          //Label
          Align(
            alignment: Alignment.topLeft,
            child: Container(
              width: screenSize.size.width / 5 * 1.8,
              height: (screenSize.size.height / 10 * 8.8) / 10 * 0.5,
              decoration: BoxDecoration(
                color: darken(colorGroup),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
              ),
              child: Center(
                child: Stack(children: <Widget>[
                  if (widget.disciplinevar != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        widget.disciplinevar.nomDiscipline,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontFamily: "Asap", fontWeight: FontWeight.bold),
                      ),
                    ),
                  if (widget.disciplinevar == null)
                    Shimmer.fromColors(
                        baseColor: Color(0xff5D6469),
                        highlightColor: Color(0xff8D9499),
                        child: Container(
                          width: screenSize.size.width / 5 * 1,
                          height:
                              (screenSize.size.height / 10 * 8.8) / 10 * 0.3,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              color: colorGroup),
                        )),
                ]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
                margin: EdgeInsets.only(
                    top: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
                width: screenSize.size.width / 5 * 4,
                decoration: BoxDecoration(
                  color: colorGroup,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          Container(
                              margin: EdgeInsets.only(top: 5),
                              child: Text(
                                "Ecrit",
                                style: TextStyle(fontFamily: "Asap"),
                              )),
                      marksColumn(0),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          Divider(thickness: 2),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          Text("Oral", style: TextStyle(fontFamily: "Asap")),
                      if (widget.disciplinevar != null)
                        if (widget.disciplinevar.codeSousMatiere.length > 0)
                          marksColumn(1),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }

  List<grade> getNotesForDiscipline(
      int sousMatiereIndex, String chosenPeriode) {
    List<grade> toReturn = List();

    if (widget.grades != null) {
      widget.grades.forEach((element) {
        if (element.codeMatiere == widget.disciplinevar.codeMatiere) {
          if (element.codePeriode == periodeToUse) {
            if (widget.disciplinevar.codeSousMatiere.length > 1) {
              if (element.codeSousMatiere ==
                  widget.disciplinevar.codeSousMatiere[sousMatiereIndex]) {
                toReturn.add(element);
              }
            } else {
              toReturn.add(element);
            }
          }
        }
      });
      return toReturn;
    } else {
      return null;
    }
  }

  //MARKS COLUMN
  marksColumn(int sousMatiereIndex) {
bool canShow=false;
    List<grade> localList =
    getNotesForDiscipline(sousMatiereIndex, periodeToUse);
    if(localList==null)
      {
        canShow=false;
      }
    else {
      if(localList.length>2)
      canShow=true;
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
        child: ListView.builder(
            itemCount: (localList != null ? localList.length : 1),
            controller: controller,

            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.size.width / 5 * 0.2,
                vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.15),
            itemBuilder: (BuildContext context, int index) {

                  //controller.animateTo(localList.length * screenSize.size.width / 5 * 1.2, duration: new Duration(milliseconds: 1), curve: Curves.ease);


              return Container(
                margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                child: Material(
                  color: darken(colorGroup),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    splashColor: colorGroup,
                    onTap: () {
                      gradesModalBottomSheet(
                          context, localList[index], widget.disciplinevar);
                    },
                    child: Stack(
                      children: <Widget>[
                        if (localList != null)
                          //Grade box
                          Container(
                            width: screenSize.size.width / 5 * 1.2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                //Grades
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical:
                                          (screenSize.size.height / 10 * 8.8) /
                                              10 *
                                              0.05),
                                  child: AutoSizeText.rich(
                                    //MARK
                                    TextSpan(
                                      text: localList[index].valeur,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          fontWeight: FontWeight.bold,
                                          fontSize: (screenSize.size.height /
                                                  10 *
                                                  8.8) /
                                              10 *
                                              0.3),
                                      children: <TextSpan>[
                                        if (localList[index].noteSur != "20")

                                          //MARK ON
                                          TextSpan(
                                              text: '/' +
                                                  localList[index].noteSur,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      (screenSize.size.height /
                                                              10 *
                                                              8.8) /
                                                          10 *
                                                          0.2)),
                                      ],
                                    ),
                                  ),
                                ),
                                if (localList[index].coef != "1")
                                  Container(
                                      margin: EdgeInsets.only(
                                          left:
                                              screenSize.size.width / 5 * 0.05),
                                      width: screenSize.size.width / 5 * 0.2,
                                      height: screenSize.size.width / 5 * 0.2,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50)),
                                        color: Colors.white,
                                      ),
                                      child: FittedBox(
                                          child: AutoSizeText(
                                        localList[index].coef,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: darken(colorGroup),
                                            fontWeight: FontWeight.bold),
                                      ))),
                              ],
                            ),
                          ),
                        if (getNotesForDiscipline(
                                sousMatiereIndex, periodeToUse) ==
                            null)
                          Shimmer.fromColors(
                              baseColor: Color(0xff5D6469),
                              highlightColor: Color(0xff8D9499),
                              child: Container(
                                width: screenSize.size.width / 5 * 3.5,
                                height: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    0.8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: colorGroup,
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  void gradesModalBottomSheet(context, grade grade, discipline discipline) {
    MediaQueryData screenSize = MediaQuery.of(context);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return new Container(
              height: (screenSize.size.height / 3),
              padding: EdgeInsets.all(0),
              child: new Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(0),
                      height: (screenSize.size.height / 3) / 2.5,
                      width: (screenSize.size.width / 5) * 1.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(25),
                            topLeft: Radius.circular(25)),
                        border: Border.all(width: 0),
                        color: Color(0xff2C2C2C),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            grade.valeur,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Asap",
                                fontWeight: FontWeight.w600,
                                fontSize: (screenSize.size.width / 5) * 0.3),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: (screenSize.size.width / 5) * 0.4),
                            child: Divider(
                                thickness: (screenSize.size.height / 3) / 75,
                                color: Colors.white),
                          ),
                          Text(
                            grade.noteSur,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Asap",
                                fontWeight: FontWeight.w600,
                                fontSize: (screenSize.size.width / 5) * 0.3),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: (screenSize.size.width / 5) * 0.5,
                      ),
                      height: (screenSize.size.height / 3) / 2.5,
                      width: (screenSize.size.width / 5) * 3.5,
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: <Widget>[
                            Material(
                              color: colorGroup,
                              borderRadius: BorderRadius.circular(15),
                              child: InkWell(
                                radius: 45,
                                onTap: () {
                                  Navigator.pop(context);
                                  disciplineModalBottomSheet(context, discipline);

                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  child: Text(discipline.nomDiscipline,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          fontSize: 15,
                                          fontWeight: FontWeight.w100)),
                                ),
                              ),
                            ),
                            Container(
                              width: (screenSize.size.width / 5) * 3,

                              child: AutoSizeText(

                                grade.devoir,
                                minFontSize: 18,

                                style: TextStyle(
                                    fontFamily: "Asap",
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: (screenSize.size.height / 3) / 1.5,
                      margin: EdgeInsets.only(top:(screenSize.size.height / 3) / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Moyenne de la classe :",  style: TextStyle(fontFamily: "Asap")),
                              Container(
                                margin: EdgeInsets.only(
                                    left: (screenSize.size.width / 5) * 0.2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xff2C2C2C)),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        (screenSize.size.width / 5) * 0.2,
                                    vertical:
                                        (screenSize.size.width / 5) * 0.1),
                                child: Text(grade.moyenneClasse, style: TextStyle(fontFamily: "Asap", color: Colors.white),),
                              )
                            ],
                          ),
                          SizedBox(height: (screenSize.size.height / 3) / 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Type de devoir :",  style: TextStyle(fontFamily: "Asap")),
                              Container(
                                margin: EdgeInsets.only(
                                    left: (screenSize.size.width / 5) * 0.2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xff2C2C2C)),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                    (screenSize.size.width / 5) * 0.2,
                                    vertical:
                                    (screenSize.size.width / 5) * 0.1),
                                child: Text(grade.typeDevoir, style: TextStyle(fontFamily: "Asap", color: Colors.white),),
                              )
                            ],
                          ),
                          SizedBox(height: (screenSize.size.height / 3) / 25,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Date du devoir :",  style: TextStyle(fontFamily: "Asap")),
                              Container(
                                margin: EdgeInsets.only(
                                    left: (screenSize.size.width / 5) * 0.2),
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                    color: Color(0xff2C2C2C)),
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                    (screenSize.size.width / 5) * 0.2,
                                    vertical:
                                    (screenSize.size.width / 5) * 0.1),
                                child: Text(  DateFormat("dd MMMM yyyy", "fr_FR").format(DateTime.parse(grade.date)) , style: TextStyle(fontFamily: "Asap", color: Colors.white),),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        }
        );

  }

  void disciplineModalBottomSheet(context, discipline discipline) {
    MediaQueryData screenSize = MediaQuery.of(context);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return new Container(
              height: (screenSize.size.height / 3),
              padding: EdgeInsets.all(0),
              child: new Stack(
                children: <Widget>[

                  Align(
                    alignment: Alignment.topCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top: (screenSize.size.height / 3)/20),
                          padding: EdgeInsets.symmetric(vertical:( screenSize.size.width / 5) * 0.05
                          ),
                          height: (screenSize.size.height / 3) / 5,

                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                              color: colorGroup
                            ),
                            padding: EdgeInsets.all(5),
                            child: Text(discipline.nomDiscipline,
                                style: TextStyle(
                                    fontFamily: "Asap",
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,),
                          ),
                        ),
                        Container(height: (screenSize.size.height / 3) / 5,padding: EdgeInsets.only(bottom: (screenSize.size.height / 3) / 10),child: IconButton( onPressed: (){
                          Navigator.pop(context);
                        },icon: Icon(Icons.color_lens, color: Colors.black, size: (screenSize.size.height / 3)/7,),))
                      ],
                    ),
                  ),
                ],
              ));
        }
    );

  }
}

Color darken(Color color, [double amount = .3]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}
