import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:battery_optimization/battery_optimization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/logic/app_config/controller.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';

class Page1 extends StatefulWidget {
  final double? offset;
  final int? idx;
  Page1({Key? key, this.offset, this.idx}) : super(key: key);
  _Page1State createState() => _Page1State();
}

//Create states of each page
class Page2 extends StatefulWidget {
  final double? offset;
  final int? idx;
  Page2({Key? key, this.offset, this.idx}) : super(key: key);
  _Page2State createState() => _Page2State();
}

class Page3 extends StatefulWidget {
  final double? offset;
  final int? idx;
  Page3({Key? key, this.offset, this.idx}) : super(key: key);

  _Page3State createState() => _Page3State();
}

class Page4 extends StatefulWidget {
  final double? offset;
  final int? idx;
  Page4({Key? key, this.offset, this.idx}) : super(key: key);

  _Page4State createState() => _Page4State();
}

class PageInfo {
  //Widget Used
  Widget? widget;
  //BG used
  Color? backgroundColor;
  PageInfo({this.widget, this.backgroundColor});
}

//PAGE1 STATE
class Carousel extends StatefulWidget {
  Carousel({Key? key}) : super(key: key);
  _CarouselState createState() => _CarouselState();
}

//PAGE2 STATE
class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: <Widget>[
          Transform.translate(
            offset: Offset(-widget.offset! * 400 - 75 + 75 * widget.offset!, -135 + 135 * widget.offset!),
            child: Align(
                alignment: Alignment.center,
                child: Transform.rotate(
                  angle: -0.4 + widget.offset! * 0.4,
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
                offset: Offset(-widget.offset! * 200, 0),
                child: SizedBox(
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(
                        TextSpan(
                          text: "Bienvenue dans",
                          children: <TextSpan>[
                            TextSpan(text: ' yNotes !', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
          ),
          Transform.translate(
            offset: Offset(-widget.offset! * 60, 0),
            child: Stack(
              children: <Widget>[
                Transform.rotate(
                  origin: Offset(
                    -(MediaQuery.of(context).size.width / 5),
                    (MediaQuery.of(context).size.width / 4),
                  ),
                  angle: 0.1 - (widget.offset! / 10),
                  child: Transform.translate(
                    offset: Offset(15, -50 + (widget.offset! * 50)),
                    child: Stack(
                      children: <Widget>[
                        Align(
                            alignment: Alignment.center,
                            child: buildGradesBox(
                              Color(0xFFD5B872),
                            )),
                      ],
                    ),
                  ),
                ),
                Transform.rotate(
                  origin: Offset(
                    -(MediaQuery.of(context).size.width / 5),
                    (MediaQuery.of(context).size.width / 4),
                  ),
                  angle: 0.4 - (widget.offset! / 2.5),
                  child: Stack(
                    children: <Widget>[
                      Align(
                          alignment: Alignment.center,
                          child: buildGradesBox(
                            Color(0xFFC9463C),
                          )),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(-widget.offset! * 300 + 125, 50),
                  child: Align(
                      alignment: Alignment.center,
                      child: Transform.rotate(
                        angle: 0.6 - (widget.offset! / 1.6),
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
                  angle: -0.2 + (widget.offset! * 0.2),
                  child: Stack(
                    children: <Widget>[
                      Align(alignment: Alignment.center, child: buildGradesBox(Color(0xFF1CA68A))),
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
                offset: Offset(-widget.offset! * 200, 0),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(
                        TextSpan(
                          text: "Car les",
                          children: <TextSpan>[
                            TextSpan(text: ' outils ', style: TextStyle(fontWeight: FontWeight.bold)),
                            TextSpan(text: ' sont aussi importants que le'),
                            TextSpan(text: ' travail...', style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
          )
        ],
      ),
    );
  }

  Widget buildGradesBox(Color color) {
    return Container(
      width: 190,
      height: 190,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(35),
        ),
      ),
      child: Container(
        margin: EdgeInsets.all(15),
        width: 120,
        height: 120,
        decoration: ShapeDecoration(
          color: Color(0xFF3F3F3F),
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(MediaQuery.of(context).size.width),
          ),
        ),
        child: Container(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("18",
                style: TextStyle(fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 46)),
            Container(
              width: 70,
              height: 5,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            ),
            Text("20",
                style: TextStyle(fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 46)),
          ],
        )),
      ),
    );
  }
}

class _Page2State extends State<Page2> {
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
                  offset: Offset(200 - (widget.offset! - 1) * 20, 57),
                  child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/calendar.png'))),
                ),
                Transform.translate(
                  offset: Offset(70 - (widget.offset! - 1) * 20, -157),
                  child: Container(
                      height: 120,
                      width: 120,
                      child: FittedBox(
                          fit: BoxFit.fill, child: Image.asset('assets/images/pageItems/carousel/shelves/clock.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - (widget.offset! - 1) * 400, -90),
                  child: Container(
                      height: 170,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/shelve1.png'))),
                ),
                Transform.translate(
                  offset: Offset(0 - (widget.offset! - 1) * 300, 90),
                  child: Container(
                      height: 90,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset('assets/images/pageItems/carousel/shelves/shelve2.png'))),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height / 15,
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
                offset: Offset(-(widget.offset! - 1) * 200, 0),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(
                        TextSpan(
                          text: "...emmenez l'école",
                          children: <TextSpan>[
                            TextSpan(text: ' dans votre poche ! ', style: TextStyle(fontWeight: FontWeight.bold)),
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

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    double opacityvalue = 1;

    return Stack(
      children: <Widget>[
        Positioned(
          left: MediaQuery.of(context).size.width / 8 - (widget.offset! - 2) * 250,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 6 - (widget.offset! - 2),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width / 8 + (widget.offset! - 2) * 70,
          top: MediaQuery.of(context).size.height / 5,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 1.2 - (widget.offset! - 2) * 1.2,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 3.5 - (widget.offset! - 2) * 310,
          top: MediaQuery.of(context).size.height / 2.3,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 4 - (widget.offset! - 2) * 1.4,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 12 - (widget.offset! - 2) * 280,
          top: MediaQuery.of(context).size.height / 4,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 2 - (widget.offset! - 2) * 1.5,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ),
              )),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height / 15,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Transform.translate(
              offset: Offset(-(widget.offset! - 2) * 200, 0),
              child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "...sans oublier de gérer votre",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' espace !', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0, color: Colors.white)))),
        ),
      ],
    );
  }
}

class _Page4State extends State<Page4> {
  bool isIgnoringBatteryOptimization = false;
  bool? specialtiesAvailable = false;
  Future? carouselDisciplineListFuture;
  String? localClasse;
  List<String> chosenSpecialties = [];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (buildContext, model, child) {
        return Container(
          height: screenSize.size.height,
          color: Theme.of(context).backgroundColor,
          child: CupertinoScrollbar(
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
                          color: ThemeUtils.textColor()),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.1,
                    ),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.2,
                    ),
                    ListTile(
                        title: Text(
                          "Choix de spécialités",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.height / 10 * 0.28),
                        ),
                        leading: Icon(MdiIcons.formatListBulleted, color: ThemeUtils.textColor()),
                        onTap: () {
                          CustomDialogs.showSpecialtiesChoice(context);
                        }),
                    Divider(
                      color: ThemeUtils.textColor().withOpacity(0.4),
                    ),
                    ListTile(
                        title: Text(
                          "Compte à administrer",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.height / 10 * 0.28),
                        ),
                        leading: Icon(MdiIcons.account, color: ThemeUtils.textColor()),
                        subtitle: appSys.account!.isParentMainAccount
                            ? Text(
                                (appSys.currentSchoolAccount?.name) ?? "(non choisi)",
                                style: TextStyle(
                                    fontFamily: "Asap",
                                    color: ThemeUtils.textColor().withOpacity(0.4),
                                    fontSize: screenSize.size.height / 10 * 0.28),
                              )
                            : null,
                        onTap: () async {
                          if (appSys.account != null && appSys.account!.managableAccounts != null) {
                            List? choices = await CustomDialogs.showMultipleChoicesDialog(
                                context,
                                appSys.account!.managableAccounts!.map((e) => e.name).toList(),
                                (appSys.currentSchoolAccount != null)
                                    ? [appSys.account!.managableAccounts!.indexOf(appSys.currentSchoolAccount!)]
                                    : [],
                                singleChoice: true);
                            if (choices != null) {
                              appSys.currentSchoolAccount = appSys.account!.managableAccounts![choices.first];
                            }
                          }
                        }),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.1,
                    ),
                    Text(
                      "De quel côté de la force êtes-vous ?",
                      style: TextStyle(
                        fontFamily: "Asap",
                        fontSize: screenSize.size.height / 10 * 0.3,
                        fontWeight: FontWeight.w500,
                        color: ThemeUtils.textColor(),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SwitchListTile(
                      value: ThemeUtils.isThemeDark,
                      title: Text("Mode nuit",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.height / 10 * 0.28)),
                      onChanged: (value) async {
                        await model.updateTheme(value ? "sombre" : "clair");
                      },
                      secondary: Icon(
                        Icons.lightbulb_outline,
                        color: ThemeUtils.textColor(),
                      ),
                    ),
                    if (Platform.isAndroid || Platform.isIOS)
                      SizedBox(
                        height: screenSize.size.height / 10 * 0.1,
                      ),
                    if (Platform.isAndroid || Platform.isIOS)
                      Text(
                        "Notifications",
                        style: TextStyle(
                            fontFamily: "Asap",
                            fontSize: screenSize.size.height / 10 * 0.3,
                            fontWeight: FontWeight.w500,
                            color: ThemeUtils.textColor()),
                        textAlign: TextAlign.center,
                      ),
                    if (Platform.isAndroid || Platform.isIOS)
                      SwitchListTile(
                          value: model.settings.user.global.notificationNewGrade,
                          title: Text(
                            "Notification de nouvelle note",
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor(),
                                fontSize: screenSize.size.height / 10 * 0.28),
                          ),
                          secondary: Transform.rotate(
                            angle: -25,
                            child: Icon(
                              MdiIcons.bellRing,
                              color: ThemeUtils.textColor(),
                            ),
                          ),
                          onChanged: (value) async {
                            if (value == false ||
                                (!kIsWeb && (Platform.isIOS && await Permission.notification.request().isGranted) ||
                                    (await Permission.ignoreBatteryOptimizations.isGranted))) {
                              model.settings.user.global.notificationNewGrade = value;
                            } else {
                              if (await (CustomDialogs.showAuthorizationsDialog(
                                      context,
                                      "la configuration d'optimisation de batterie",
                                      "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.")) ??
                                  false) {
                                if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
                                  model.settings.user.global.notificationNewGrade = value;
                                }
                              }
                            }
                          }),
                    if (Platform.isAndroid || Platform.isIOS)
                      Divider(
                        color: ThemeUtils.textColor().withOpacity(0.4),
                      ),
                    if (Platform.isAndroid || Platform.isIOS)
                      SwitchListTile(
                        value: model.settings.user.global.notificationNewMail,
                        title: Text(
                          "Notification de nouveau mail",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(),
                              fontSize: screenSize.size.height / 10 * 0.28),
                        ),
                        onChanged: (value) async {
                          if (value == false ||
                              (!kIsWeb && (Platform.isIOS && await Permission.notification.request().isGranted) ||
                                  (await Permission.ignoreBatteryOptimizations.isGranted))) {
                            model.settings.user.global.notificationNewMail = value;
                          } else {
                            if (await (CustomDialogs.showAuthorizationsDialog(
                                    context,
                                    "la configuration d'optimisation de batterie",
                                    "Pouvoir s'exécuter en arrière plan sans être automatiquement arrêté par Android.")) ??
                                false) {
                              if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
                                model.settings.user.global.notificationNewMail = value;
                              }
                            }
                          }
                        },
                        secondary: Transform.rotate(
                          angle: -25,
                          child: Icon(
                            MdiIcons.bellRing,
                            color: ThemeUtils.textColor(),
                          ),
                        ),
                      ),
                    SizedBox(
                      height: screenSize.size.height / 10 * 0.1,
                    ),
                    CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, () async {
                      createStorage("agreedTermsAndConfiguredApp", "true");
                      Navigator.pushReplacementNamed(context, "/summary");
                    }, label: "Allons-y !", textColor: ThemeUtils.textColor(), backgroundColor: Color(0xff5DADE2))
                    /*RaisedButton(
                      color: Color(0xff5DADE2),
                      shape: StadiumBorder(),
                      onPressed: () async {
                        var classe = await specialtiesSelectionAvailable();
                        if (classe[0] && chosenSpecialties.length == (classe[1] == "Première" ? 3 : 2)) {
                          CreateStorage("agreedTermsAndConfiguredApp", "true");
                          final prefs = await (SharedPreferences.getInstance());
                          prefs.setStringList("listSpecialties", chosenSpecialties);
                          Navigator.pushReplacementNamed(context, "/summary");
                        } else if (!classe[0]) {
                          CreateStorage("agreedTermsAndConfiguredApp", "true");
                          final prefs = await (SharedPreferences.getInstance());
                          prefs.setStringList("listSpecialties", chosenSpecialties);
                          Navigator.pushReplacementNamed(context, "/summary");
                        } else {
                          CustomDialogs.showAnyDialog(context, "Vous devez renseigner toutes vos spécialités.");
                        }
                      },
                      child: const Text('Allons-y !', style: TextStyle(fontSize: 20, fontFamily: "Asap")),
                    ),*/
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  void getAuth() async {
    if (!(Platform.isAndroid || Platform.isIOS)) return;
    if ((await BatteryOptimization.isIgnoringBatteryOptimizations()) ?? false) {
      setState(() {
        isIgnoringBatteryOptimization = true;
      });
    } else {
      setState(() {
        isIgnoringBatteryOptimization = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    getAuth();
  }

  void refreshCarouselDLFuture() {
    setState(() {
      carouselDisciplineListFuture = appSys.api!.getGrades();
    });
  }
}

class _CarouselState extends State<Carousel> {
  late List<PageInfo> _pageInfoList;

  PageController? _pageController;

  double? _pageOffset;
  int? _pageIndex;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: _pageOffset!.toInt() == 3 ? Theme.of(context).backgroundColor : _getBGColor(),
      body: //Disable back button
          SafeArea(
        child: WillPopScope(
          onWillPop: () async {
            Future.value(false);
            return false;
          },
          child: Column(
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: screenSize.size.height / 10 * 8.5,
                      child: PageView.builder(
                          controller: _pageController,
                          itemCount: _pageInfoList.length,
                          itemBuilder: (context, idx) {
                            return Container(
                                height: MediaQuery.of(context).size.height, child: Center(child: _setOffset(idx)));
                          }),
                    ),
                    Container(
                      width: screenSize.size.width,
                      height: screenSize.size.height / 10 * 0.5,
                      child: Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.centerRight,
                            child: Visibility(
                              visible: _pageController!.hasClients ? (_pageIndex != 3) : true,
                              child: Container(
                                margin: EdgeInsets.only(
                                    right: screenSize.size.width / 5 * 0.1, top: screenSize.size.height / 10 * 0.08),
                                // ignore: deprecated_member_use
                                child: OutlineButton(
                                  color: Colors.transparent,
                                  highlightColor: Colors.black,
                                  focusColor: Colors.black,
                                  borderSide: BorderSide(color: Colors.indigo),
                                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  highlightedBorderColor: Colors.black,
                                  onPressed: () async {
                                    _pageController!
                                        .animateToPage(3, duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                                  },
                                  child: AutoSizeText(
                                    "Passer",
                                    style: TextStyle(
                                        fontFamily: "Asap",
                                        fontSize: screenSize.size.width / 5 * 0.3,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.indigo),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SmoothPageIndicator(
                              controller: _pageController!, // PageController
                              count: 4,
                              effect: WormEffect(), // your preferred effect
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

//set a list of basic infos (colors)
  void initState() {
    super.initState();

    _pageOffset = 0.0;

    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController!.page;

          _pageIndex = _pageController!.page!.round();
        });
      });
    _list(_pageOffset, 0);
  }

  _getBGColor() {
    if (_pageOffset!.toInt() + 1 < _pageInfoList.length) {
      //Current background color
      Color? current = _pageInfoList[_pageOffset!.toInt()].backgroundColor;
      Color? next = _pageInfoList[_pageOffset!.toInt() + 1].backgroundColor;
      if (_pageOffset!.toInt() == 2) {
        next = ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white;
      }
      if (_pageOffset!.toInt() == 3) {
        current = ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white;
      }
      return Color.lerp(current, next, _pageOffset! - _pageOffset!.toInt());
    } else {
      return _pageInfoList.last.backgroundColor;
    }
  }

  _list(offset, idx) {
    return _pageInfoList = [
      PageInfo(
        widget: Page1(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFECFCFF),
      ),
      PageInfo(
        widget: Page2(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFE5AE6C),
      ),
      PageInfo(
        widget: Page3(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFF252B62),
      ),
      PageInfo(
          widget: Page4(
            offset: offset,
            idx: idx,
          ),
          backgroundColor: ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white),
    ];
  }

  _setOffset(idx) {
    _list(_pageOffset, idx);
    return _pageInfoList[idx].widget;
  }
}
