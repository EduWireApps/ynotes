import 'package:auto_size_text/auto_size_text.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ynotes/UI/dialogs.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import 'package:ynotes/usefulMethods.dart';

class SlidingCarousel extends StatefulWidget {
  SlidingCarousel({Key key}) : super(key: key);
  _SlidingCarouselState createState() => _SlidingCarouselState();
}

//Create states of each page
class page1 extends StatefulWidget {
  final double offset;
  final int idx;
  page1({Key key, this.offset, this.idx}) : super(key: key);
  _page1State createState() => _page1State();
}

class page2 extends StatefulWidget {
  final double offset;
  final int idx;
  page2({Key key, this.offset, this.idx}) : super(key: key);
  _page2State createState() => _page2State();
}

class page3 extends StatefulWidget {
  final double offset;
  final int idx;
  page3({Key key, this.offset, this.idx}) : super(key: key);

  _page3State createState() => _page3State();
}

class page4 extends StatefulWidget {
  final double offset;
  final int idx;
  page4({Key key, this.offset, this.idx}) : super(key: key);

  _page4State createState() => _page4State();
}

//PAGE1 STATE
class _page1State extends State<page1> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(-(widget.offset) * 400 - 75 + 75 * widget.offset,
              -135 + 135 * widget.offset),
          child: Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.4 + widget.offset * 0.4,
                child: Icon(
                  Icons.star,
                  color: Color(0xFFE7D928),
                  size: 150.0,
                ),
              )),
        ),
        Positioned(
          top: 20,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Transform.translate(
              offset: Offset(-(widget.offset) * 200, 0),
              child: SizedBox(
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "Bienvenue dans",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' yNotes !',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
        ),
        Transform.translate(
          offset: Offset(-(widget.offset) * 60, 0),
          child: Stack(
            children: <Widget>[
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: 0.1 - (widget.offset / 10),
                child: Transform.translate(
                  offset: Offset(15, -50 + (widget.offset * 50)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: ShapeDecoration(
                            color: Color(0xFFD5B872),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.width / 2.5,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3F3F3F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(70),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 22, top: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/marks/3.0x/mark.png')),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: 0.4 - (widget.offset / 2.5),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: ShapeDecoration(
                          color: Color(0xFFC9463C),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 2.5,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3F3F3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(70),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(left: 22, top: 10),
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                child: Image(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/marks/3.0x/mark.png')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(-(widget.offset) * 300 + 125, 50),
                child: Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: 0.6 - (widget.offset / 1.6),
                      child: Icon(
                        Icons.book,
                        color: Color(0xFF606060),
                        size: 110.0,
                      ),
                    )),
              ),
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: -0.2 + (widget.offset * 0.2),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: ShapeDecoration(
                          color: Color(0xFF1CA68A),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 2.5,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3F3F3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(70),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(left: 22, top: 10),
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                child: Image(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/marks/3.0x/mark.png')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).size.height / 15,
          height: 90,
          child: Transform.translate(
              offset: Offset(-(widget.offset) * 200, 0),
              child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "Car les",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' outils ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' sont aussi importants que le'),
                          TextSpan(
                              text: ' travail...',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
        )
      ],
    );
  }
}

//PAGE2 STATE
class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(200 - (widget.offset - 1) * 20, 57),
                  child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/calendar.png'))),
                ),
                Transform.translate(
                  offset: Offset(70 - (widget.offset - 1) * 20, -157),
                  child: Container(
                      height: 120,
                      width: 120,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child:
                              Image.asset('assets/images/shelves/clock.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - (widget.offset - 1) * 400, -90),
                  child: Container(
                      height: 170,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/shelve1.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - (widget.offset - 1) * 300, 90),
                  child: Container(
                      height: 90,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/shelve2.png'))),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 15,
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
                offset: Offset(-(widget.offset - 1) * 200, 0),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(
                        TextSpan(
                          text: "...emmenez l'école",
                          children: <TextSpan>[
                            TextSpan(
                                text: ' dans votre poche ! ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
          )
        ],
      ),
    );
  }
}

class _page3State extends State<page3> {
  @override
  Widget build(BuildContext context) {
    double opacityvalue = 1;

    return Stack(
      children: <Widget>[
        Positioned(
          left:
              MediaQuery.of(context).size.width / 8 - (widget.offset - 2) * 250,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 6 - (widget.offset - 2),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          right:
              MediaQuery.of(context).size.width / 8 + (widget.offset - 2) * 70,
          top: MediaQuery.of(context).size.height / 5,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 1.2 - (widget.offset - 2) * 1.2,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 3.5 -
              (widget.offset - 2) * 310,
          top: MediaQuery.of(context).size.height / 2.3,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 4 - (widget.offset - 2) * 1.4,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 12 -
              (widget.offset - 2) * 280,
          top: MediaQuery.of(context).size.height / 4,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 2 - (widget.offset - 2) * 1.5,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ),
              )),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 5,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Transform.translate(
              offset: Offset(-(widget.offset - 2) * 200, 0),
              child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "...sans oublier de gérer votre",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' espace !',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Asap",
                          fontSize: 30.0,
                          color: Colors.white)))),
        ),
      ],
    );
  }
}

API api = APIManager();

class _page4State extends State<page4> {
  bool specialtiesAvailable = false;
  Future carouselDisciplineListFuture;
   String localClasse;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSpecialitiesChoiceAvailability();
    carouselDisciplineListFuture = api.getGrades();
  }

  void refreshCarouselDLFuture() async {
    setState(() {
      carouselDisciplineListFuture = api.getGrades();
    });
  }

  void getSpecialitiesChoiceAvailability() async {
    var list = await specialtiesSelectionAvailable();
    setState(() {
      localClasse= list[1];
      specialtiesAvailable= list[0];
    });
  }

  List<String> chosenSpecialties = List();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    double opacityvalue = 0;
    if (widget.offset - 1 > 0 && widget.offset - 1 < 1) {
      opacityvalue = widget.offset - 1;
    } else {
      opacityvalue = 0;
    }
    return Container(
      height: screenSize.size.height,
      color: Theme.of(context).backgroundColor,
      child: SingleChildScrollView(
        child: Container(
          height: screenSize.size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Paramètrons votre application",
                style: TextStyle(
                    fontFamily: "Asap",
                    fontSize: screenSize.size.height / 10 * 0.35,
                    color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),
              //Only available for EcoleDirecte
              if (specialtiesAvailable)
                Text(
                  "Sélectionnez vos spécialités :",
                  style: TextStyle(
                      fontFamily: "Asap",
                      fontSize: screenSize.size.height / 10 * 0.27,
                      color: isDarkModeEnabled ? Colors.white : Colors.black),
                  textAlign: TextAlign.center,
                ),
              if (specialtiesAvailable)
                Container(
                  height: screenSize.size.height / 10 * 3,
                  width: screenSize.size.width / 5 * 4.8,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      color: Theme.of(context).primaryColor),
                  child: FutureBuilder<List<discipline>>(
                      future: carouselDisciplineListFuture,
                      builder: (BuildContext context, snapshot) {
                        List disciplines = List();
                        if (snapshot.hasData) {
                          snapshot.data
                              .where((element) => element.periode == "0")
                              .forEach((element) {
                            disciplines.add(element.nomDiscipline);
                          });
                          return ListView.builder(
                            itemCount: disciplines.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenSize.size.height / 10 * 0.2,
                                ),
                                child: Row(
                                  children: <Widget>[
                                    CircularCheckBox(
                                      inactiveColor: isDarkModeEnabled
                                          ? Colors.white
                                          : Colors.black,
                                      onChanged: (value) {
                                        if (chosenSpecialties
                                            .contains(disciplines[index])) {
                                          setState(() {
                                            chosenSpecialties.removeWhere(
                                                (element) =>
                                                    element ==
                                                    disciplines[index]);
                                          });
                                        } else {
                                          if (chosenSpecialties.length < (localClasse == "Première"? 3 : 2)) {
                                            setState(() {
                                              chosenSpecialties
                                                  .add(disciplines[index]);
                                            });
                                          }
                                        }
                                      },
                                      value: chosenSpecialties
                                          .contains(disciplines[index]),
                                    ),
                                    Text(
                                      disciplines[index],
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          color: isDarkModeEnabled
                                              ? Colors.white
                                              : Colors.black),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Une erreur a eu lieu",
                                  style: TextStyle(
                                      fontFamily: "Asap",
                                      color: isDarkModeEnabled
                                          ? Colors.white
                                          : Colors.black),
                                ),
                                FlatButton(
                                  onPressed: () {
                                    //Reload list
                                    refreshCarouselDLFuture();
                                  },
                                  child: Text("Recharger",
                                      style: TextStyle(
                                        fontFamily: "Asap",
                                        color: isDarkModeEnabled
                                            ? Colors.white
                                            : Colors.black,
                                      )),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .primaryColorDark)),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return SpinKitChasingDots(
                            color: Theme.of(context).primaryColorDark,
                          );
                        }
                      }),
                ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.2,
              ),

              Text(
                "De quel côté de la force êtes vous ?",
                style: TextStyle(
                  fontFamily: "Asap",
                  fontSize: screenSize.size.height / 10 * 0.27,
                  color: isDarkModeEnabled ? Colors.white : Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              Divider(
                color: isDarkModeEnabled ? Colors.white : Colors.black,
              ),
              FutureBuilder(
                  future: getSetting("nightmode"),
                  initialData: false,
                  builder: (context, snapshot) {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text("Mode nuit",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: screenSize.size.height / 10 * 0.3)),
                      onChanged: (value) {
                        setState(() {
                          Provider.of<AppStateNotifier>(context, listen: false)
                              .updateTheme(value);
                          setSetting("nightmode", value);
                        });
                      },
                      secondary: Icon(
                        Icons.lightbulb_outline,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                    );
                  }),

              Divider(
                color: isDarkModeEnabled ? Colors.white : Colors.black,
              ),
              Text(
                "Notifications",
                style: TextStyle(
                    fontFamily: "Asap",
                    fontSize: screenSize.size.height / 10 * 0.27,
                    color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.center,
              ),
              Divider(),
              FutureBuilder(
                  future: getSetting("notificationNewGrade"),
                  initialData: false,
                  builder: (context, snapshot) {
                    return SwitchListTile(
                        value: snapshot.data,
                        title: Text(
                          "Notification de nouvelle note",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: isDarkModeEnabled
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: screenSize.size.height / 10 * 0.3),
                        ),
                        secondary: Icon(
                          MdiIcons.newBox,
                          color:
                              isDarkModeEnabled ? Colors.white : Colors.black,
                        ),
                        onChanged: (value) {
                          setState(() {
                            setSetting("notificationNewGrade", value);
                          });
                        });
                  }),
                  Divider(),
              FutureBuilder(
                  future: getSetting("notificationNewMail"),
                  initialData: false,
                  builder: (context, snapshot) {
                    return SwitchListTile(
                      value: snapshot.data,
                      title: Text(
                        "Notification de nouveau mail",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color:
                                isDarkModeEnabled ? Colors.white : Colors.black,
                            fontSize: screenSize.size.height / 10 * 0.3),
                      ),
                     
                      onChanged: (value) {
                              setState(() {
                                setSetting("notificationNewMail", value);
                              });
                            },
                      secondary: Icon(
                        MdiIcons.newBox,
                        color: isDarkModeEnabled ? Colors.white : Colors.black,
                      ),
                    );
                  }),
              Divider(
                color: isDarkModeEnabled ? Colors.white : Colors.black,
              ),
              RaisedButton(
                color: Color(0xff5DADE2),
                shape: StadiumBorder(),
                onPressed: () async {
                  var classe = await specialtiesSelectionAvailable();
                  if (classe[0] &&
                      chosenSpecialties.length ==
                          (classe[1] == "Première" ? 3 : 2)) {
                    CreateStorage("agreedTermsAndConfiguredApp", "true");
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setStringList("listSpecialties", chosenSpecialties);
                    Navigator.of(context).pushReplacement(router(homePage()));
                  }
                  else if(!classe[0]) {
                      CreateStorage("agreedTermsAndConfiguredApp", "true");
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setStringList("listSpecialties", chosenSpecialties);
                    Navigator.of(context).pushReplacement(router(homePage()));
                  }
                  else {
                    CustomDialogs.showAnyDialog(context, "Vous devez renseigner toutes vos spécialités.");
                  }
                  
                },
                child: const Text('Allons-y !',
                    style: TextStyle(fontSize: 20, fontFamily: "Asap")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PageInfo {
  //Widget Used
  Widget widget;
  //BG used
  Color backgroundColor;
  PageInfo({this.widget, this.backgroundColor});
}

class _SlidingCarouselState extends State<SlidingCarousel> {
  List<PageInfo> _pageInfoList;

  PageController _pageController;
  double _pageOffset;
  int _currentPageId;

  void initState() {
    super.initState();
    _pageOffset = 0.0;

    _currentPageId = 0;

    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page;
        });
      });
    _list(_pageOffset, 0);
  }

//set a list of basic infos (colors)
  _list(offset, idx) {
    return _pageInfoList = [
      PageInfo(
        widget: page1(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFECFCFF),
      ),
      PageInfo(
        widget: page2(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFE5AE6C),
      ),
      PageInfo(
        widget: page3(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFF252B62),
      ),
      PageInfo(
          widget: page4(
            offset: offset,
            idx: idx,
          ),
          backgroundColor: Colors.white),
    ];
  }

  _setOffset(idx) {
    _list(_pageOffset, idx);
    return _pageInfoList[idx].widget;
  }

  _getBGColor() {
    if (_pageOffset.toInt() + 1 < _pageInfoList.length) {
      //Current background color
      Color current = _pageInfoList[_pageOffset.toInt()].backgroundColor;
      Color next = _pageInfoList[_pageOffset.toInt() + 1].backgroundColor;
      return Color.lerp(current, next, _pageOffset - _pageOffset.toInt());
    } else {
      return _pageInfoList.last.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBGColor(),
      body: //Disable back button
          WillPopScope(
        onWillPop: () async {
          Future.value(false);
          return false;
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pageInfoList.length,
                  itemBuilder: (context, idx) {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: _setOffset(idx)));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
