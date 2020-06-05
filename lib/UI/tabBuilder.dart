import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/homeworkPage.dart';
import 'package:ynotes/UI/gradesPage.dart';
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
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class TabBuilder extends StatefulWidget {
  static final tabBarKey = new GlobalKey<_TabBuilderState>();
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
  
  API api = APIManager();
  API apiecoledirecte = APIEcoleDirecte();
  bool firstStart = true;
  AnimationController quickMenuAnimationController;

  OverlayState overlayState;
  OverlayEntry _overlayEntry;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => QuickMenu(removeQuickMenu),
    );
    quickMenuAnimationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    //Define a controller in order to control the scrolls
    tabController = TabController(
        vsync: this,
        length: 5,
        initialIndex: (haveToReopenOnGradePage) ? 2 : 1);
    
    tabController.addListener(_handleTabChange);
    if (firstStart == true) {
      //Get grades before
      disciplinesListFuture = api.getGrades();
      //Get homework before
      homeworkListFuture = api.getNextHomework();
      firstStart = false;
    }
    removeQuickMenu();
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

  //On tab change
  void _handleTabChange() {

    if(tabController.index!=2)
    {
      
       initialIndexGradesOffset=0;
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
              backgroundColor: Theme.of(context).backgroundColor,
              bottomNavigationBar: Container(
                color: isQuickMenuShown ? Colors.black.withOpacity(0.5) : null,
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
                                      controller: tabController,
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
                                          child: GestureDetector(
                                            onLongPressEnd: (_) {},
                                            onTap: () {
                                              actualIndex = tabController.index;
                                              setState(() {
                                                tabController.index = 0;
                                              });

                                              removeQuickMenu();
                                            },
                                            onLongPress: () {
                                              setState(() {
                                                isQuickMenuShown = false;
                                              });
                                              overlayState =
                                                  Overlay.of(context);

                                              if (!isQuickMenuShown) {
                                                isQuickMenuShown = true;
                                                setState(() {
                                                  WidgetsBinding.instance
                                                      .addPostFrameCallback((_) =>
                                                          overlayState.insert(
                                                              _overlayEntry));
                                                });
                                              }
                                            },
                                            child: Tab(
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
                                                        width: MediaQuery.of(
                                                                    context)
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

                                        ///Homework page
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
                                                        child: Text("Devoirs",
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
              body: GestureDetector(
                onTap: () {
                  removeQuickMenu();
                },
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      NotificationListener(
                        onNotification: (scrollNotification) {
                          if (scrollNotification is ScrollUpdateNotification) {
                            _onStartScroll(scrollNotification.metrics);
                          }
                          return true;
                        },
                        child: TabBarView(
                            key: TabBuilder.tabBarKey,
                            controller: tabController,
                            children: [
                              Icon(Icons.apps),
                              SummaryPage(tabController: tabController),
                              GradesPage(),
                              HomeworkPage(),
                              AppsPage()
                            ]),
                      ),
                      if (isQuickMenuShown)
                        AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          color: isQuickMenuShown
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black.withOpacity(0),
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

  Future<bool> testForNewGrades() async {
    return await api.testNewGrades();
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

      var initializationSettingsAndroid =
          new AndroidInitializationSettings('newgradeicon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(
          initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: BackgroundServices.onSelectNotification);
      if (await testForNewGrades()) {
        BackgroundServices.showNotification();
        disciplinesListFuture = api.getGrades();
      } else {
        print("Nothing updated");
      }
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }
}
