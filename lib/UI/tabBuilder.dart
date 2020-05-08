import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/agendaPage.dart';
import 'package:ynotes/UI/gradesPage.dart';
import 'package:ynotes/landGrades.dart';
import 'package:ynotes/UI/summaryPage.dart';
import 'package:ynotes/UI/settingsPage.dart';

import '../usefulMethods.dart';
import 'appsPage.dart';

class TabBuilder extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _TabBuilderState();
  }
}

int _currentIndex = 0;

class _TabBuilderState extends State<TabBuilder> with TickerProviderStateMixin {
  //This controller allow the app to toggle a function when there is a tab change
  TabController _tabController;
  //Boolean
  bool isChanging = false;
  int actualIndex = 1;
  @override
  void initState() {
    super.initState();

    //Define a controller in order to control the scrolls
    _tabController = TabController(vsync: this, length: 5, initialIndex: 1);
    _tabController.addListener(_handleTabChange);

    //Animation of the radius
  }

  //On tab change
  void _handleTabChange() {
    setState(() {
      actualIndex = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

    double extrasize = 0;
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      child: DefaultTabController(
          length: 5,
          child: Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              bottomNavigationBar: ClipRRect(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  width: screenSize.size.width,
                  height: screenSize.size.height / 10 * 1,
                  child: ClipRRect(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: screenSize.size.height / 10 * 0.025,
                          right: screenSize.size.height / 10 * 0.025),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30)),
                          color: Theme.of(context).primaryColor),
                      child: Container(
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(60),
                                )),
                              
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: TabBar(
                                      onTap: (index) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                      controller: _tabController,
                                      labelColor: Colors.white,
                                      labelPadding: EdgeInsets.all(0),
                                      unselectedLabelColor: Colors.white,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      isScrollable: true,
                                      indicatorPadding:
                                          EdgeInsets.only(bottom: 0),
                                      indicator: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color:
                                              Theme.of(context).indicatorColor),
                                      tabs: [
                                        //TODO : Start the space tab
                                        ///Space tab
                                        Tab(
                                          child: AnimatedContainer(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    screenSize.size.width /
                                                        5 *
                                                        0.15),
                                            duration:
                                                Duration(milliseconds: 170),
                                            width: (actualIndex == 0
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5 *
                                                    1.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5 *
                                                    0.5),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Image(
                                                    image: AssetImage(
                                                        'assets/images/space/4.0x/space.png'),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            10 *
                                                            0.7,
                                                  ),
                                                  if (actualIndex == 0)
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text("Space",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Asap",
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Summary page
                                        Tab(
                                          child: AnimatedContainer(
                                            margin: EdgeInsets.symmetric(
                                                horizontal:
                                                    screenSize.size.width /
                                                        5 *
                                                        0.15),
                                            duration:
                                                Duration(milliseconds: 170),
                                            width: (actualIndex == 1
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5 *
                                                    1.5
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    5 *
                                                    0.5),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.info,
                                                    color: isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  if (actualIndex == 1)
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text("Résumé",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Asap",
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Grades page
                                        Badge(
                                          animationType:
                                              BadgeAnimationType.scale,
                                          toAnimate: true,
                                          showBadge: newGrades,
                                          elevation: 0,
                                          
                                          position: BadgePosition.topRight(
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  10 *
                                                  0.001,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  15 *
                                                  0.11),
                                                  
                                          badgeColor: Colors.blue,
                                          
                                          child: Tab(
                                            child: AnimatedContainer(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      screenSize.size.width /
                                                          5 *
                                                          0.15),
                                              duration:
                                                  Duration(milliseconds: 170),
                                              width: (actualIndex == 2
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 *
                                                      1.5
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      5 *
                                                      0.5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons
                                                          .format_list_numbered,
                                                      color: isDarkModeEnabled
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                    if (actualIndex == 2)
                                                      Flexible(
                                                        child: FittedBox(
                                                          child: Text("Notes",
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      "Asap",
                                                                  color: isDarkModeEnabled
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Agenda page
                                        AnimatedContainer(
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.size.width /
                                                      5 *
                                                      0.15),
                                          duration: Duration(milliseconds: 170),
                                          width: (actualIndex == 3
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5 *
                                                  1.2
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5 *
                                                  0.45),
                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.viewAgenda,
                                                    color: isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  if (actualIndex == 3)
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text("Agenda",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Asap",
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Apps page
                                        AnimatedContainer(
                                          duration: Duration(milliseconds: 170),
                                          margin: EdgeInsets.symmetric(
                                              horizontal:
                                                  screenSize.size.width /
                                                      5 *
                                                      0.15),
                                          width: (actualIndex == 4
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5 *
                                                  1.5
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  5 *
                                                  0.5),
                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.apps,
                                                    color: isDarkModeEnabled
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                  if (actualIndex == 4)
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text(
                                                            "Applications",
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    "Asap",
                                                                color: isDarkModeEnabled
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              body: Stack(
                children: <Widget>[
                  NotificationListener(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollUpdateNotification) {
                        _onStartScroll(scrollNotification.metrics);
                      }
                      return true;
                    },
                    child: TabBarView(controller: _tabController, children: [
                      Icon(Icons.apps),
                      SummaryPage(),
                      GradesPage(),
                      AgendaPage(),
                      AppsPage()
                    ]),
                  ),
                  Positioned(
                      left: screenSize.size.width / 5 * 0.1,
                      top: screenSize.size.width / 5 * 0.05,
                      child: ClipOval(
                        child: Material(
                          color: Theme.of(context).primaryColorDark, // button color
                          child: InkWell(
                            splashColor: isDarkModeEnabled?Colors.white:Colors.black, // inkwell color
                            child: SizedBox(
                                width: screenSize.size.width / 5 * 0.55, height: screenSize.size.width / 5 * 0.55, child: Icon(Icons.settings, color: isDarkModeEnabled?Colors.white:Colors.black,)),
                            onTap: () {
                               Navigator.of(context).push(router(SettingsPage()));
                            },
                          ),
                        ),
                      )),
                ],
              ))),
    );
  }

//Function to start the animation of the tab during tab changing 
  _onStartScroll(ScrollMetrics metrics) {
    if (_tabController.indexIsChanging == false) {
      if (_tabController.offset > 0.8) {
        setState(() {
          actualIndex = _tabController.index + 1;
          _tabController.index = _tabController.index + 1;
        });
      }
      if (_tabController.offset < -0.8) {
        setState(() {
          actualIndex = _tabController.index - 1;
          _tabController.index = _tabController.index - 1;
        });
      }
    }
  }
}
