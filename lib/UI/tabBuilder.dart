import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/dialogs.dart';
import 'package:ynotes/UI/homeworkPage.dart';
import 'package:ynotes/UI/gradesPage.dart';
import 'package:ynotes/UI/spacePage.dart';
import 'package:ynotes/UI/summaryPage.dart';
import 'package:ynotes/UI/settingsPage.dart';
import 'package:ynotes/UI/quickMenu.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/UI/homeworkPage.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../usefulMethods.dart';
import 'appsPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TabBuilder extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _TabBuilderState();
  }

  TabBuilder({Key key}) : super(key: key);
}

int _currentIndex = 0;
bool isQuickMenuShown = false;

class _TabBuilderState extends State<TabBuilder> with TickerProviderStateMixin {
  //This controller allow the app to toggle a function when there is a tab change
  TabController tabController;
  //Boolean
  bool isChanging = false;
  int actualIndex = 1;

  API apiecoledirecte = APIEcoleDirecte();
  bool firstStart = true;
  AnimationController quickMenuAnimationController;
  Animation<double> quickMenuButtonAnimation;
  StreamSubscription tabBarconnexion;

  bool isOffline = false;
  OverlayState overlayState;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => QuickMenu(removeQuickMenu),
    );

    //Define a controller in order to control the scrolls
    tabController = TabController(vsync: this, length: 5, initialIndex: 1);
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
    tabController.addListener(_handleTabChange);
    if (firstStart == true) {
      //Get grades before
      disciplinesListFuture = localApi.getGrades();
      //Get homework before
      homeworkListFuture = localApi.getNextHomework();
      firstStart = false;
    }
    removeQuickMenu();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    tabBarconnexion = connectionStatus.connectionChange.listen(connectionChanged);
    isOffline = !connectionStatus.hasConnection;
  }

  void removeQuickMenu() {
    if (isQuickMenuShown) {
      if (isQuickMenuShown) {
        _overlayEntry.remove();
      }
      setState(() {
        isQuickMenuShown = false;
      });
    }
  }

  void connectionChanged(dynamic hasConnection) {
    print("connected");
    setState(() {
      isOffline = !hasConnection;
    });
  }

  //On tab change
  void _handleTabChange() {
    if (tabController.index != 2) {
      initialIndexGradesOffset = 0;
    }
    setState(() {
      actualIndex = tabController.index;
    });
  }

  @override
  void dispose() {
    tabController.dispose();
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
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).backgroundColor,
              bottomNavigationBar: Container(
                color: isQuickMenuShown ? Colors.black.withOpacity(0.5) : null,
                child: Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                  width: screenSize.size.width,
                  height: screenSize.size.height / 10 * 1,
                  child: ClipRRect(
                    child: Container(
                      padding: EdgeInsets.only(left: screenSize.size.height / 10 * 0.025, right: screenSize.size.height / 10 * 0.025),
                      decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), color: Theme.of(context).primaryColor),
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
                                      controller: tabController,
                                      labelColor: Colors.white,
                                      labelPadding: EdgeInsets.all(0),
                                      unselectedLabelColor: Colors.white,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      isScrollable: true,
                                      indicatorPadding: EdgeInsets.only(bottom: 0),
                                      indicator: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          color: Theme.of(context).indicatorColor),
                                      tabs: [
                                        //TODO : Start the space tab
                                        ///Space tab
                                        Tab(
                                          child: GestureDetector(
                                            onLongPressEnd: (_) {},
                                            onTap: () {
                                              setState(() {
                                                _currentIndex = 0;
                                              });
                                              tabController.animateTo(0);
                                              removeQuickMenu();
                                            },
                                            onVerticalDragStart: (details) {
                                              quickMenuAnimationController.forward().then((value) {
                                                quickMenuAnimationController.reverse();
                                              });

                                              setState(() {
                                                isQuickMenuShown = false;
                                              });
                                              overlayState = Overlay.of(context);

                                              if (!isQuickMenuShown) {
                                                isQuickMenuShown = true;
                                                setState(() {
                                                  WidgetsBinding.instance.addPostFrameCallback((_) => overlayState.insert(_overlayEntry));
                                                });
                                              }
                                            },
                                            onLongPress: () {},
                                            child: Tab(
                                              child: AnimatedContainer(
                                                margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                                duration: Duration(milliseconds: 170),
                                                width: (actualIndex == 0 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      AnimatedBuilder(
                                                          animation: quickMenuButtonAnimation,
                                                          builder: (context, snapshot) {
                                                            return Transform.scale(
                                                              scale: quickMenuButtonAnimation.value,
                                                              child: Image(
                                                                image: AssetImage('assets/images/space/4.0x/space.png'),
                                                                width: MediaQuery.of(context).size.width / 10 * 0.7,
                                                              ),
                                                            );
                                                          }),
                                                      if (actualIndex == 0)
                                                        Flexible(
                                                          child: FittedBox(
                                                            child: Text("Space", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Summary page
                                        Tab(
                                          child: AnimatedContainer(
                                            margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                            duration: Duration(milliseconds: 170),
                                            width: (actualIndex == 1 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.info,
                                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                  ),
                                                  if (actualIndex == 1)
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text("Résumé", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Grades page
                                        Badge(
                                          animationType: BadgeAnimationType.scale,
                                          toAnimate: true,
                                          showBadge: newGrades,
                                          elevation: 0,
                                          position: BadgePosition.topRight(right: MediaQuery.of(context).size.width / 10 * 0.001, top: MediaQuery.of(context).size.height / 15 * 0.11),
                                          badgeColor: Colors.blue,
                                          child: Tab(
                                            child: AnimatedContainer(
                                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                              duration: Duration(milliseconds: 170),
                                              width: (actualIndex == 2 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.format_list_numbered,
                                                      color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                    ),
                                                    if (actualIndex == 2)
                                                      Flexible(
                                                        child: FittedBox(
                                                          child: Text("Notes", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Homework page
                                        AnimatedContainer(
                                          margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                          duration: Duration(milliseconds: 170),
                                          width: (actualIndex == 3 ? MediaQuery.of(context).size.width / 5 * 1.2 : MediaQuery.of(context).size.width / 5 * 0.45),
                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    MdiIcons.viewAgenda,
                                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                  ),
                                                  if (actualIndex == 3)
                                                    Flexible(
                                                      child: FittedBox(
                                                        child: Text("Devoirs", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
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
                                          margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                          width: (actualIndex == 4 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[
                                                  Icon(
                                                    Icons.apps,
                                                    color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                  ),
                                                  if (actualIndex == 4)
                                                    Flexible(
                                                      child: FittedBox(
                                                        fit: BoxFit.fitWidth,
                                                        child: Text("Applications", style: TextStyle(fontFamily: "Asap", color: isDarkModeEnabled ? Colors.white : Colors.black)),
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
              body: GestureDetector(
                onTap: () {
                  removeQuickMenu();
                },
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      Stack(fit: StackFit.expand, children: [
                        Positioned(
                          left: 0.0,
                          right: 0.0,
                          child: AnimatedContainer(
                            height: isOffline ? screenSize.size.height / 10 * 0.4 : 0,
                            curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn),
                            duration: Duration(milliseconds: 800),
                            child: Container(
                              color: !isOffline ? Colors.greenAccent : Colors.deepOrange,
                              child: Center(
                                child: Text("${!isOffline ? 'Vous avez été reconnecté' : 'Vous êtes hors-ligne'}"),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            _onStartScroll(scrollNotification.metrics);
                          }
                          return true;
                        },
                        child: TabBarView(controller: tabController, children: [
                          SpacePage(),
                          SummaryPage(tabController: tabController),
                          SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: GradesPage()),
                          SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: HomeworkPage()),
                          AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              margin: EdgeInsets.only(top: isOffline ? screenSize.size.height / 10 * 0.4 : 0),
                              child: AppsPage(
                                rootcontext: this.context,
                              ))
                        ]),
                      ),
                      if (isQuickMenuShown)
                        AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          color: isQuickMenuShown ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                    ],
                  ),
                ),
              ))),
    );
  }

//Function to start the animation of the tab during tab changing
  _onStartScroll(ScrollMetrics metrics) {
    if (tabController.indexIsChanging == false) {
      if (tabController.offset > 0.8) {
        setState(() {
          actualIndex = tabController.index + 1;
          tabController.index = tabController.index + 1;
        });
      }
      if (tabController.offset < -0.8) {
        setState(() {
          actualIndex = tabController.index - 1;
          tabController.index = tabController.index - 1;
        });
      }
    }
  }

  Future<void> initPlatformState() async {
    bool saveBattery = await getSetting("batterySaver");
    // Configure BackgroundFetch.
    BackgroundFetch.configure(
        BackgroundFetchConfig(
          minimumFetchInterval: 15,
          forceAlarmManager: false,
          stopOnTerminate: false,
          startOnBoot: true,
          enableHeadless: true,
          requiresBatteryNotLow: false,
          requiresCharging: false,
          requiresStorageNotLow: false,
          requiresDeviceIdle: false,
          requiredNetworkType: NetworkType.NONE,
        ), (String taskId) async {
      // This is the fetch-event callback.

      print("Started the background task");

      var initializationSettingsAndroid = new AndroidInitializationSettings('newgradeicon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: BackgroundServices.onSelectNotification);

//Ensure that grades notification are enabled and battery saver disabled
      if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
        if (await mainTestNewGrades()) {
          BackgroundServices.showNotificationNewGrade();
        } else {
          print("Nothing updated");
        }
        BackgroundFetch.finish(taskId);
      } else {
        print("New grade notification disabled");
      }
      if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
        if (await mainTestNewMails()) {
          BackgroundServices.showNotificationNewMail();
        } else {
          print("Nothing updated");
        }
        BackgroundFetch.finish(taskId);
      } else {
        print("New mail notification disabled");
      }
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
}
