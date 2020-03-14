import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/landGrades.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class gradesPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _gradesPageState();
  }
}
double average = 0.0;
//This boolean show a little badge if true
bool newGrades = false;
//The periode to show at start
String periodeToUse = "A002";
//Filter to use
String filter = "all";
//If true, show a carousel
bool firstStart = true;
Future disciplinesListFuture;

class _gradesPageState extends State<gradesPage> with TickerProviderStateMixin {
  AnimationController circleAnimation;
  Animation<double> movingCircle;
  Animation<double> animateWidth;

  void initState() {
    super.initState();

    initializeDateFormatting("fr_FR", null);

    //Test if it's the first start
    if (firstStart == true) {
      refreshLocalGradeList();
      firstStart = false;
    }
    //Get the actual periode (based on grades)
    getActualPeriode();
    circleAnimation =
        AnimationController(duration: Duration(milliseconds: 450), vsync: this);
  }

  Future<void> refreshLocalGradeList() async {
    setState(() {
      disciplinesListFuture = getNotesAndDisciplines();
    });
  }

  //Get the actual periode
  getActualPeriode() async {
    List<discipline> list = await getNotesAndDisciplines();

    periodeToUse = list
        .lastWhere((list) => list.gradesList.length > 0)
        .gradesList
        .last
        .codePeriode;
  }

  openSortBox() {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xff2C2C2C),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              height: screenSize.size.height / 10 * 4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.size.width / 5 * 0.1,
                        right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(),
                    child: Material(
                      color: Color(0xff252B62),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {


                        },
                        child: Row(
                          children: <Widget>[
                            Image( image: AssetImage('assets/images/space/space.png'), width: screenSize.size.width / 5 * 0.8,),
                            Text(
                              "Mes spécialités", style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3,  fontWeight: FontWeight.w500, fontFamily: "Asap", color: Colors.white),)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.size.width / 5 * 0.1,
                        right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Material(
                      color: Color(0xff42735B),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "sciences";
                            Navigator.pop(context);
                          });

                        },
                        child:  Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.1 ),
                                child: Icon(MdiIcons.atomVariant, size: screenSize.size.width / 5 * 0.5, color: Colors.white,)),
                            Container(
                              margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.2 ),
                              child: Text(
                                "Sciences", style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500,fontFamily: "Asap", color: Colors.white),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.size.width / 5 * 0.1,
                        right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Material(
                      color: Color(0xff6C4273),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "littérature";
                            Navigator.pop(context);
                          });
                        },
                        child:  Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.1 ),
                                child: Icon(MdiIcons.bookOpenVariant, size: screenSize.size.width / 5 * 0.5, color: Colors.white,)),
                            Container(
                              margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.2 ),
                              child: Text(
                                "Littérature", style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500,fontFamily: "Asap", color: Colors.white),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.size.width / 5 * 0.1,
                        right: screenSize.size.width / 5 * 0.1),
                    height: screenSize.size.height / 10 * 0.8,
                    decoration: BoxDecoration(),
                    child: Material(
                      color: Colors.white10,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        onTap: () {
                          setState(() {
                            filter = "all";
                            Navigator.pop(context);
                          });

                        },
                        child: Row(
                          children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.1 ),
                                child: Icon(MdiIcons.borderNoneVariant, size: screenSize.size.width / 5 * 0.5, color: Colors.white,)),
                            Container(
                              margin: EdgeInsets.only(left:screenSize.size.width / 5 * 0.2 ),
                              child: Text(
                                "Aucun filtre", style: TextStyle(fontSize: screenSize.size.width / 5 * 0.3, fontWeight: FontWeight.w500,fontFamily: "Asap", color: Colors.white),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void setAverage(List<discipline> disciplineList)
  {
    average = 0;
    double counter = 0;
    disciplineList
        .where((i) =>
    "A00" +
        ((int.parse(i.periode) / 2) + 1)
            .toString() ==
        periodeToUse + ".0")
        .forEach((f) {
      f.gradesList.forEach((z) {
        if (z.letters != true) {
          average += double.tryParse(
              z.valeur.replaceAll(',', '.')) *
              20 /
              double.tryParse(
                  z.noteSur.replaceAll(',', '.')) *
              double.tryParse(
                  z.coef.replaceAll(',', '.'));
          counter += double.tryParse(
              z.coef.replaceAll(',', '.'));
        }
      });
    });

    average = average / counter;
  }
//If sort bool is true
  List<discipline> getDisciplinesForPeriod(List<discipline> list, periode, String sortBy) {
    List<discipline> toReturn = new List<discipline>();
    list.forEach((f) {

      switch (sortBy) {
        case "all":
          if ("A00" + (int.parse(f.periode) / 2 + 1).toString() == periode + ".0") {
        toReturn.add(f);
          }
      break;
        case "littérature":
          List<String> codeMatiere = ["FRANC", "HI-GE","AGL1", "ESP2"];

          if ("A00" + (int.parse(f.periode) / 2 + 1).toString() == periode + ".0"&&codeMatiere.any((test) {
            if (test==f.codeMatiere) {
              return true;
            } else {
              return false;
            }
          })) {
            toReturn.add(f);
          }
          break;
        case "sciences":
          List<String> codeMatiere = ["SVT", "MATHS","G-SCI", "PH-CH"];

          if ("A00" + (int.parse(f.periode) / 2 + 1).toString() == periode + ".0"&&codeMatiere.any((test) {
            if (test==f.codeMatiere) {
              return true;
            } else {
              return false;
            }
          })) {
            toReturn.add(f);
          }
          break;
      }


    });
    setAverage(toReturn);
    return toReturn;
  }

  //Convert period code to period name and reverse
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

  ///Grades box
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController controller = ScrollController();

    ///Button container
    return Container(
      margin: EdgeInsets.only(
          top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 3),
      height: screenSize.size.height / 10 * 8.8,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
          Widget>[
        Container(
          width: screenSize.size.width / 5 * 4.5,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              border: Border.all(width: 0.00000, color: Colors.transparent),
              color: Color(0xff2C2C2C)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                width: (screenSize.size.width / 5) * 1.8,
                decoration: ShapeDecoration(
                  shape: StadiumBorder(),
                  color: Color(0xff3b3b3b),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: Color(0xff3b3b3b),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: getCorrespondingPeriod(periodeToUse),
                          iconSize: 0.0,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Asap",
                              color: Colors.white),
                          onChanged: (String newValue) {
                            setState(() {
                              periodeToUse = getCorrespondingPeriod(newValue);
                            });
                          },
                          focusColor: Color(0xff2C2C2C),
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
                                style: TextStyle(
                                    fontSize: 18,
                                    fontFamily: "Asap",
                                    color: Colors.white),
                              ),
                            );
                          }).toList(),
                        ),
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
                    color: Color(0xff3b3b3b),
                    shape: StadiumBorder(),
                    onPressed: () {
                      openSortBox();
                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.sort, color: Colors.white),
                        SizedBox(
                          width: (screenSize.size.width / 5) * 0.1,
                        ),
                        Text(
                          "Trier",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Asap",
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        ///Grades container

        RefreshIndicator(
          onRefresh: refreshLocalGradeList,
          child: Container(
            width: screenSize.size.width / 5 * 4.5,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 5.5,
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
                border: Border.all(width: 0.000000, color: Colors.transparent),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 2.67,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2),
                  ),
                ],
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                    topRight: Radius.circular(0),
                    topLeft: Radius.circular(0)),
                color: Color(0xff2C2C2C)),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: FutureBuilder<void>(
                    future: disciplinesListFuture,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (getDisciplinesForPeriod(snapshot.data, periodeToUse,filter)
                            .any((test) {
                          if (test.gradesList.length > 0) {
                            return true;
                          } else {
                            return false;
                          }
                        })) {
                          return ListView.builder(
                              itemCount: getDisciplinesForPeriod(
                                      snapshot.data, periodeToUse,filter)
                                  .length,
                              padding: EdgeInsets.all(
                                  screenSize.size.width / 5 * 0.3),
                              itemBuilder: (BuildContext context, int index) {
                                return GradesGroup(
                                    disciplinevar: getDisciplinesForPeriod(
                                        snapshot.data, periodeToUse,filter)[index]);
                              });
                        } else {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(
                                  image: AssetImage('assets/images/book.png'),
                                  width: screenSize.size.width / 5 * 4),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal:
                                        screenSize.size.width / 5 * 0.5),
                                child: AutoSizeText(
                                    "Pas de données pour cette periode.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontFamily: "Asap",
                                      color: Colors.white,
                                    )),
                              )
                            ],
                          );
                        }
                      }
                      if (snapshot.hasError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Image(
                              image: AssetImage('assets/images/totor.png'),
                              width: screenSize.size.width / 5 * 3.5,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(
                                  horizontal: screenSize.size.width / 5 * 0.5),
                              child: AutoSizeText(
                                  "Hum... on dirait que tout ne s'est pas passé comme prévu.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Asap",
                                    color: Colors.white,
                                  )),
                            )
                          ],
                        );
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

        Container(
          width: screenSize.size.width / 5 * 4.5,
          height: (screenSize.size.height / 10 * 8.8) / 10 * 1.8,
          margin: EdgeInsets.only(
              top: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
          decoration: BoxDecoration(boxShadow: <BoxShadow>[
            BoxShadow(
              blurRadius: 2.67,
              color: Colors.black.withOpacity(0.2),
              offset: Offset(0, 2.67),
            ),
          ], borderRadius: BorderRadius.circular(20), color: Color(0xff2C2C2C)),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: FutureBuilder<void>(
                  future: disciplinesListFuture,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {

                    List<discipline> disciplineList;
                    discipline getLastDiscipline;
                    if (snapshot.hasData) {
                      if (snapshot.data != null) {
                        try {


                          getLastDiscipline = snapshot.data.lastWhere(
                              (disciplinesList) =>
                                  "A00" +
                                      (int.parse(disciplinesList.periode) / 2 +
                                              1)
                                          .toString() ==
                                  periodeToUse + ".0");
                          //print(getLastDiscipline.codeMatiere);
                        } catch (exception) {}

                        ///Animations for the averages section
                        movingCircle = Tween<double>(
                                begin: screenSize.size.width / 4,
                                end: screenSize.size.width / 6 * 0.015)
                            .animate(CurvedAnimation(
                                parent: circleAnimation,
                                curve: Interval(0.7, 1.0,
                                    curve: Curves.fastOutSlowIn)))
                              ..addListener(() {
                                // Empty setState because the updated value is already in the animation field
                                setState(() {});
                              });

                        animateWidth = Tween<double>(
                                begin: 0, end: screenSize.size.width / 5 * 4)
                            .animate(CurvedAnimation(
                                parent: circleAnimation,
                                curve: Interval(0.7, 1.0,
                                    curve: Curves.fastOutSlowIn)))
                              ..addListener(() {
                                /// Empty setState because the updated value is already in the animation field
                                setState(() {});
                              });

                        circleAnimation.forward();
                        //If everything is ok, show stuff
                        return Stack(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    1.15,
                                width: animateWidth.value,
                                decoration: BoxDecoration(
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      blurRadius: 2.67,
                                      color: Colors.black.withOpacity(0.2),
                                      offset: Offset(0, 2.67),
                                    ),
                                  ],
                                  color: Color(0xffA1A1A1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: FittedBox(
                                  child: Container(
                                    height:
                                        (screenSize.size.height / 10 * 8.8) /
                                            10 *
                                            1.15,
                                    child: Stack(

                                      children: <Widget>[

                                        Container(
                                          margin: EdgeInsets.only(
                                              left:
                                                  (screenSize.size.width / 5) *
                                                      0.9),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: <Widget>[
                                              if(filter=="all")
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Moyenne de la classe :",
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: Colors.black,
                                                          fontSize: (screenSize
                                                                      .size
                                                                      .width /
                                                                  5) *
                                                              0.18)),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: (screenSize.size
                                                                    .width /
                                                                5) *
                                                            0.1),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                        color:
                                                            Color(0xff2C2C2C)),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: (screenSize
                                                                    .size
                                                                    .width /
                                                                5) *
                                                            0.1,
                                                        vertical: (screenSize
                                                                    .size
                                                                    .width /
                                                                5) *
                                                            0.08),
                                                    child: Text(
                                                      (getLastDiscipline !=
                                                                  null &&
                                                              getLastDiscipline
                                                                      .moyenneGeneraleClasse !=
                                                                  null
                                                          ? getLastDiscipline
                                                              .moyenneGeneraleClasse
                                                          : "-"),
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: Colors.white,
                                                          fontSize: (screenSize
                                                                      .size
                                                                      .width /
                                                                  5) *
                                                              0.18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if(filter=="all")
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Meilleure moyenne:",
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: Colors.black,
                                                          fontSize: (screenSize
                                                              .size
                                                              .width /
                                                              5) *
                                                              0.18)),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: (screenSize.size
                                                            .width /
                                                            5) *
                                                            0.1),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                        color:
                                                        Color(0xff2C2C2C)),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: (screenSize
                                                            .size
                                                            .width /
                                                            5) *
                                                            0.1,
                                                        vertical: (screenSize
                                                            .size
                                                            .width /
                                                            5) *
                                                            0.08),
                                                    child: Text(
                                                      (getLastDiscipline !=
                                                          null &&
                                                          getLastDiscipline
                                                              .moyenneGeneralClasseMax !=
                                                              null
                                                          ? getLastDiscipline
                                                          .moyenneGeneralClasseMax
                                                          : "-"),
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: Colors.white,
                                                          fontSize: (screenSize
                                                              .size
                                                              .width /
                                                              5) *
                                                              0.18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              if(filter!="all")
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: <Widget>[
                                                  Text("Moyenne du filtre ",
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          color: Colors.black,
                                                          fontSize: (screenSize
                                                                      .size
                                                                      .width /
                                                                  5) *
                                                              0.2)),
                                                  Text(filter,
                                                      style: TextStyle(
                                                          fontFamily: "Asap",
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                          fontSize: (screenSize
                                                              .size
                                                              .width /
                                                              5) *
                                                              0.2)),


                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //Circle with the moyenneGenerale
                            Positioned(
                              left: movingCircle.value,
                              top: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.2,
                              child: Tooltip(
                                message:
                                    "Moyenne calculée par YNotes en temps réel avec les données actuelles.",
                                preferBelow: false,
                                verticalOffset:
                                    -(screenSize.size.height / 10 * 1.1),
                                decoration: BoxDecoration(color: Colors.black),
                                child: Container(
                                  width: screenSize.size.width / 5 * 1.5,
                                  height: (screenSize.size.height / 10 * 8.8) /
                                      10 *
                                      1.4,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: <BoxShadow>[
                                        BoxShadow(
                                          blurRadius: 2.67,
                                          color: Colors.black.withOpacity(0.2),
                                          offset: Offset(0, 2.67),
                                        ),
                                      ],
                                      color: (filter=="all"?Colors.white:Colors.green)

                                  ),
                                  child: Center(
                                    child: Text(
                                      (average.toString() != null &&
                                              !average.isNaN
                                          ? average.toStringAsFixed(2)
                                          : "-"),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: "Asap",
                                          fontSize:
                                              (screenSize.size.width / 5) *
                                                  0.4),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }

                      return Container();
                    }

                    //To do if it can't get the data
                    if (snapshot.hasError) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            color: Colors.white,
                            size: screenSize.size.width / 8,
                          ),
                        ],
                      );
                    } else {
                      return SpinKitWave(
                        color: Colors.white,
                        size: 50.0,
                      );
                    }
                  })),
        ),
      ]),
    );
  }

  @override
  void dispose() {
    circleAnimation.dispose();

    super.dispose();
  }
}

class GradesGroup extends StatefulWidget {
  final discipline disciplinevar;
  const GradesGroup({this.disciplinevar});

  State<StatefulWidget> createState() {
    return _GradesGroupState();
  }
}

class _GradesGroupState extends State<GradesGroup> {

  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Colors.blueAccent;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = widget.disciplinevar.color;
      }
    }
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
            child: Material(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              color: darken(colorGroup),
              child: InkWell(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                onTap: () {
                  if (widget.disciplinevar != null) {
                    disciplineModalBottomSheet(context, widget.disciplinevar);
                  }
                },
                child: Container(
                  width: screenSize.size.width / 5 * 1.8,
                  height: (screenSize.size.height / 10 * 8.8) / 10 * 0.5,
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
                                fontFamily: "Asap",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (widget.disciplinevar == null)
                        Shimmer.fromColors(
                            baseColor: Color(0xff5D6469),
                            highlightColor: Color(0xff8D9499),
                            child: Container(
                              width: screenSize.size.width / 5 * 1,
                              height: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.3,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: colorGroup),
                            )),
                    ]),
                  ),
                ),
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

  List<grade> getGradesForDiscipline(
      int sousMatiereIndex, String chosenPeriode) {
    List<grade> toReturn = List();

    if (widget.disciplinevar != null) {
      widget.disciplinevar.gradesList.forEach((element) {
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
      });
      return toReturn;
    } else {
      return null;
    }
  }

  //MARKS COLUMN
  marksColumn(int sousMatiereIndex) {
    bool canShow = false;
    List<grade> localList =
        getGradesForDiscipline(sousMatiereIndex, periodeToUse);
    if (localList == null) {
      canShow = false;
    } else {
      if (localList.length > 2) canShow = true;
    }

    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Colors.blueAccent;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = widget.disciplinevar.color;
      }
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    ScrollController marksColumnController = ScrollController();
    return Container(
        height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
        child: ListView.builder(
            itemCount: (localList != null ? localList.length : 1),
            controller: marksColumnController,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(
                horizontal: screenSize.size.width / 5 * 0.2,
                vertical: (screenSize.size.height / 10 * 8.8) / 10 * 0.15),
            itemBuilder: (BuildContext context, int index) {
              DateTime now = DateTime.now();
              String formattedDate = DateFormat('yyyy-MM-dd').format(now);
              if (localList != null) {
                marksColumnController.animateTo(
                    localList.length * screenSize.size.width / 5 * 1.2,
                    duration: new Duration(microseconds: 5),
                    curve: Curves.ease);
                if (

                localList[index].dateSaisie == formattedDate) {
                  newGrades = true;
                }

              }

              return Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(
                        left: screenSize.size.width / 5 * 0.1,
                        right: screenSize.size.width / 5 * 0.1),
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
                                          vertical: (screenSize.size.height /
                                                  10 *
                                                  8.8) /
                                              10 *
                                              0.05),
                                      child: AutoSizeText.rich(
                                        //MARK
                                        TextSpan(
                                          text: localList[index].valeur,
                                          style: TextStyle(
                                              fontFamily: "Asap",
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  (screenSize.size.height /
                                                          10 *
                                                          8.8) /
                                                      10 *
                                                      0.3),
                                          children: <TextSpan>[
                                            if (localList[index].noteSur !=
                                                "20")

                                              //MARK ON
                                              TextSpan(
                                                  text: '/' +
                                                      localList[index].noteSur,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: (screenSize
                                                                  .size.height /
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
                                              left: screenSize.size.width /
                                                  5 *
                                                  0.05),
                                          width:
                                              screenSize.size.width / 5 * 0.2,
                                          height:
                                              screenSize.size.width / 5 * 0.2,
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
                            if (getGradesForDiscipline(
                                    sousMatiereIndex, periodeToUse) ==
                                null)
                              Shimmer.fromColors(
                                  baseColor: Color(0xff5D6469),
                                  highlightColor: Color(0xff8D9499),
                                  child: Container(
                                    width: screenSize.size.width / 5 * 3.5,
                                    height:
                                        (screenSize.size.height / 10 * 8.8) /
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
                  ),
                  if (localList != null)
                    if (localList[index].dateSaisie == formattedDate)
                      Positioned(
                        left: screenSize.size.width / 5 * 1.18,
                        bottom: screenSize.size.height / 15 * 0.4,
                        child: Badge(
                          animationType: BadgeAnimationType.scale,
                          toAnimate: true,
                          elevation: 0,
                          position: BadgePosition.topRight(),
                          badgeColor: Colors.blue,
                        ),
                      ),
                ],
              );
            })

    );
  }

  void gradesModalBottomSheet(context, grade grade, discipline discipline) {
    MediaQueryData screenSize = MediaQuery.of(context);
    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Colors.blueAccent;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = widget.disciplinevar.color;
      }
    }
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
                                  disciplineModalBottomSheet(
                                      context, discipline);
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
                      margin: EdgeInsets.only(
                          top: (screenSize.size.height / 3) / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Moyenne de la classe :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  (grade.moyenneClasse != ""
                                      ? grade.moyenneClasse
                                      : "-"),
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Type de devoir :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  grade.typeDevoir,
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Date du devoir :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  DateFormat("dd MMMM yyyy", "fr_FR")
                                      .format(DateTime.parse(grade.date)),
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  ///Bottom windows with some infos on the discipline and the possibility to change the discipline color
  void disciplineModalBottomSheet(context, discipline discipline) {
    Color colorGroup;
    if (widget.disciplinevar == null) {
      colorGroup = Colors.blueAccent;
    } else {
      if (widget.disciplinevar.color != null) {
        colorGroup = widget.disciplinevar.color;
      }
    }
    MediaQueryData screenSize = MediaQuery.of(context);
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        backgroundColor: Colors.white,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: (screenSize.size.height / 3.5),
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
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              color: colorGroup),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            discipline.nomDiscipline,
                            style: TextStyle(
                                fontFamily: "Asap",
                                fontSize: 17,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Container(
                            height: (screenSize.size.height / 3) / 6,
                            width: (screenSize.size.height / 3) / 6,
                            padding: EdgeInsets.all(5),
                            child: Material(
                                borderRadius: BorderRadius.circular(80),
                                color: Colors.grey.withOpacity(0.5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(80),
                                  radius: 25,
                                  onTap: () {
                                    Navigator.pop(context);
                                    colorPicker(context, discipline);
                                  },
                                  splashColor: Colors.grey,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    child: Icon(
                                      Icons.color_lens,
                                      color: Colors.black26,
                                    ),
                                  ),
                                )))
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: (screenSize.size.height / 3) / 1.5,
                      margin: EdgeInsets.only(
                          top: (screenSize.size.height / 3) / 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Votre moyenne :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  discipline.moyenne,
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Moyenne de la classe :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  discipline.moyenneClasse,
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Meilleure moyenne :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  discipline.moyenneMax,
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: (screenSize.size.height / 3) / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text("Moyenne de la classe :",
                                  style: TextStyle(fontFamily: "Asap")),
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
                                child: Text(
                                  discipline.moyenneClasse,
                                  style: TextStyle(
                                      fontFamily: "Asap", color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
        });
  }

  colorPicker(context, discipline discipline) async {
    Color pickerColor = discipline.color;

    void changeColor(Color color) {
      setState(() {
        pickerColor = color;
      });
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    MediaQueryData screenSize = MediaQuery.of(context);
    showDialog(
      context: context,
      child: AlertDialog(
        backgroundColor: Color(0xff2C2C2C),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        title: Container(
          width: screenSize.size.width / 20,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: pickerColor),
          child: Text(
            discipline.nomDiscipline,
            style: TextStyle(
                fontFamily: "Asap", fontSize: 17, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
        content: Container(
          //padding: EdgeInsets.all(screenSize.size.height/100),

          child: SingleChildScrollView(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: BlockPicker(


                pickerColor: pickerColor,
                onColorChanged: changeColor,
                availableColors: [
                  Colors.white70,
                  Color(0xfffb6b1d),
                  Color(0xffe83b3b),
                  Color(0xff831c5d),
                  Color(0xffc32454),
                  Color(0xfff04f78),
                  Color(0xfff68181),
                  Color(0xfffca790),
                  Color(0xffe3c896),
                  Color(0xffab947a),
                  Color(0xff966c6c),
                  Color(0xff625565),
                  Color(0xff3e3546),
                  Color(0xff0b5e65),
                  Color(0xff0b8a8f),
                  Color(0xff1ebc73),
                  Color(0xff91db69),
                  Color(0xfffbff86),
                  Color(0xfffbb954),
                  Color(0xffcd683d),
                  Color(0xff9e4539),
                  Color(0xff7a3045),
                  Color(0xff6b3e75),
                  Color(0xff905ea9),
                  Color(0xffa884f3),
                  Color(0xffeaaded),
                  Color(0xff8fd3ff),
                  Color(0xff4d9be6),
                  Color(0xff4d65b4),
                  Color(0xff484a77),
                  Color(0xff30e1b9),
                  Color(0xff8ff8e2),
                  Color(0xff8ac6d1),
                ],
              ),
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text("Annuler", style: TextStyle( fontFamily: "Asap"),),
            onPressed: () {
              setState(() {
                String test = pickerColor.toString();
                String finalColor =
                    "#" + test.toString().substring(10, test.length - 1);

                prefs.setString(discipline.codeMatiere, finalColor);
                discipline.setcolor = pickerColor;
              });

              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text(
              "J'ai choisi",
              style: TextStyle(color: Colors.green, fontFamily: "Asap"),
            ),
            onPressed: () {
              setState(() {
                String test = pickerColor.toString();
                String finalColor =
                    "#" + test.toString().substring(10, test.length - 1);

                prefs.setString(discipline.codeMatiere, finalColor);
                discipline.setcolor = pickerColor;

                disciplinesListFuture = getNotesAndDisciplines();
              });

              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}

///Make the selected color darker
Color darken(
  Color color,
) {
  double amount = 0.05;
  var ColorTest = TinyColor(color);
  //Test if the color is not too light
  if (ColorTest.isLight()) {
    amount = 0.06;
  }
  //Test if the color is something like yellow
  if (ColorTest.getLuminance() > 0.8) {
    amount = 0.31;
  }
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}
