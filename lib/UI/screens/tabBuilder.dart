import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/homeworkPage.dart';
import 'package:ynotes/UI/screens/gradesPage.dart';
import 'package:ynotes/UI/screens/spacePage.dart';
import 'package:ynotes/UI/screens/summaryPage.dart';
import 'package:ynotes/UI/components/quickMenu.dart';
import 'package:ynotes/apiManager.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/UI/screens/homeworkPage.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';
import '../../models.dart';
import '../../usefulMethods.dart';
import 'appsPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Build a bottom tabbar and tabs
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
  Animation<double> showTransparentLoginStatus;
  AnimationController showTransparentLoginStatusController;

  @override
  void initState() {
    super.initState();
    showTransparentLoginStatusController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showTransparentLoginStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: showTransparentLoginStatusController,
        curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));
    initPlatformState();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => QuickMenu(removeQuickMenu),
    );

    //Define a controller in order to control the scrolls
    tabController = TabController(vsync: this, length: 5, initialIndex: 1);
    quickMenuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(new CurvedAnimation(
        parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));
    tabController.addListener(_handleTabChange);

    tabController.animation
      ..addListener(() {
        if (!tabController.indexIsChanging) {
          setState(() {
            tabController.index = (tabController.animation.value)
                .round(); //_tabController.animation.value returns double
          });
        }
      });

    if (firstStart == true) {
      //Get grades before
      disciplinesListFuture = localApi.getGrades();
      //Get homework before
      homeworkListFuture = localApi.getNextHomework();
      firstStart = false;
    }
    //removeQuickMenu();
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
      //PAppbar
      child: DefaultTabController(
          length: 5,
          child: Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Theme.of(context).backgroundColor,
              bottomNavigationBar: Container(
                color: isQuickMenuShown ? Colors.black.withOpacity(0.5) : null,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30), topRight: Radius.circular(30))),
                  width: screenSize.size.width,
                  height: screenSize.size.height / 10 * 1,
                  child: ClipRRect(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: screenSize.size.height / 10 * 0.025,
                          right: screenSize.size.height / 10 * 0.025),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
                                          tabController.index = index;
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
                                                tabController.index = 0;
                                                actualIndex = 0;
                                              });
                                              tabController.animateTo(0);
                                              //removeQuickMenu();
                                            },
                                            onLongPress: () {},
                                            child: Tab(
                                              child: AnimatedContainer(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: screenSize.size.width / 5 * 0.15),
                                                duration: Duration(milliseconds: 170),
                                                width: (actualIndex == 0
                                                    ? MediaQuery.of(context).size.width / 5 * 1.5
                                                    : MediaQuery.of(context).size.width / 5 * 0.5),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      AnimatedBuilder(
                                                          animation: quickMenuButtonAnimation,
                                                          builder: (context, snapshot) {
                                                            return Transform.scale(
                                                              scale: quickMenuButtonAnimation.value,
                                                              child: Image(
                                                                image: AssetImage(
                                                                    'assets/images/space/4.0x/space.png'),
                                                                width: MediaQuery.of(context)
                                                                        .size
                                                                        .width /
                                                                    10 *
                                                                    0.7,
                                                              ),
                                                            );
                                                          }),
                                                      if (actualIndex == 0)
                                                        Flexible(
                                                          child: FittedBox(
                                                            child: Text("Space",
                                                                style: TextStyle(
                                                                    fontFamily: "Asap",
                                                                    color: isDarkModeEnabled
                                                                        ? Colors.white
                                                                        : Colors.black)),
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
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                tabController.index = 1;
                                                actualIndex = 1;
                                              });
                                            },
                                            child: AnimatedContainer(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: screenSize.size.width / 5 * 0.15),
                                              duration: Duration(milliseconds: 170),
                                              width: (actualIndex == 1
                                                  ? MediaQuery.of(context).size.width / 5 * 1.5
                                                  : MediaQuery.of(context).size.width / 5 * 0.5),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                                  fontFamily: "Asap",
                                                                  color: isDarkModeEnabled
                                                                      ? Colors.white
                                                                      : Colors.black)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
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
                                          position: BadgePosition.topRight(
                                              right: MediaQuery.of(context).size.width / 10 * 0.001,
                                              top: MediaQuery.of(context).size.height / 15 * 0.11),
                                          badgeColor: Colors.blue,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                tabController.index = 2;
                                                actualIndex = 2;
                                              });
                                            },
                                            child: Tab(
                                              child: AnimatedContainer(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: screenSize.size.width / 5 * 0.15),
                                                duration: Duration(milliseconds: 170),
                                                width: (actualIndex == 2
                                                    ? MediaQuery.of(context).size.width / 5 * 1.5
                                                    : MediaQuery.of(context).size.width / 5 * 0.5),
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.format_list_numbered,
                                                        color: isDarkModeEnabled
                                                            ? Colors.white
                                                            : Colors.black,
                                                      ),
                                                      if (actualIndex == 2)
                                                        Flexible(
                                                          child: FittedBox(
                                                            child: Text("Notes",
                                                                style: TextStyle(
                                                                    fontFamily: "Asap",
                                                                    color: isDarkModeEnabled
                                                                        ? Colors.white
                                                                        : Colors.black)),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Homework page
                                        AnimatedContainer(
                                          margin: EdgeInsets.symmetric(
                                              horizontal: screenSize.size.width / 5 * 0.15),
                                          duration: Duration(milliseconds: 170),
                                          width: (actualIndex == 3
                                              ? MediaQuery.of(context).size.width / 5 * 1.2
                                              : MediaQuery.of(context).size.width / 5 * 0.45),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                tabController.index = 3;
                                                actualIndex = 3;
                                              });
                                            },
                                            child: Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                                  fontFamily: "Asap",
                                                                  color: isDarkModeEnabled
                                                                      ? Colors.white
                                                                      : Colors.black)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        ///Apps page
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              tabController.index = 4;
                                              actualIndex = 4;
                                            });
                                          },
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 170),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: screenSize.size.width / 5 * 0.15),
                                            width: (actualIndex == 4
                                                ? MediaQuery.of(context).size.width / 5 * 1.5
                                                : MediaQuery.of(context).size.width / 5 * 0.5),
                                            child: Tab(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                                          child: Text("Applications",
                                                              style: TextStyle(
                                                                  fontFamily: "Asap",
                                                                  color: isDarkModeEnabled
                                                                      ? Colors.white
                                                                      : Colors.black)),
                                                        ),
                                                      ),
                                                  ],
                                                ),
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
              body: Container(
                child: Stack(
                  children: <Widget>[
                    /* Stack(fit: StackFit.expand, children: [
                      Positioned(
                        left: 0.0,
                        right: 0.0,
                        child: AnimatedContainer(
                          height: (isOffline || !localApi.loggedIn)
                              ? screenSize.size.height / 10 * 0.4
                              : 0,
                          curve: Interval(0.3, 1.0, curve: Curves.fastOutSlowIn),
                          duration: Duration(milliseconds: 800),
                          child: Container(
                            width: screenSize.size.width,
                            color: !isOffline
                                ? (!localApi.loggedIn) ? Colors.grey.shade300 : Colors.greenAccent
                                : Colors.deepOrange.shade200,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
                                      height: screenSize.size.height / 10 * 0.25,
                                      width: screenSize.size.height / 10 * 0.25,
                                      child: isOffline
                                          ? Icon(MdiIcons.networkStrengthOff)
                                          : CircularProgressIndicator(
                                              backgroundColor: Colors.grey)),
                                  Container(
                                      child: Text((!isOffline && localApi.loggedIn)
                                          ? 'Vous avez été reconnecté'
                                          : (localApi.loggedIn
                                              ? 'Vous êtes hors-ligne'
                                              : 'Connexion...'))),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]),*/

                    TabBarView(controller: tabController, children: [
                      SpacePage(),
                      SummaryPage(tabController: tabController),
                      SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(), child: GradesPage()),
                      SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(), child: HomeworkPage()),
                      AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.only(
                              top: isOffline ? screenSize.size.height / 10 * 0.4 : 0),
                          child: AppsPage(
                            rootcontext: this.context,
                          ))
                    ]),
                    if (isQuickMenuShown)
                      Positioned(
                        top: screenSize.size.height / 10 * 0.1,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          color: isQuickMenuShown
                              ? Colors.black.withOpacity(0.5)
                              : Colors.black.withOpacity(0),
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    //Transparent login panel
                    ChangeNotifierProvider.value(
                      value: tlogin,
                      child: Consumer<TransparentLogin>(builder: (context, model, child) {
                        if (model.actualState != loginStatus.loggedIn) {
                          showTransparentLoginStatusController.forward();
                        } else {
                          showTransparentLoginStatusController.reverse();
                        }
                        return AnimatedBuilder(
                            animation: showTransparentLoginStatus,
                            builder: (context, snapshot) {
                              return Transform.translate(
                                offset: Offset(
                                    0,
                                    -screenSize.size.height /
                                        10 *
                                        1.2 *
                                        showTransparentLoginStatus.value),
                                child: Opacity(
                                  opacity: 0.55,
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: screenSize.size.width / 5 * 0.15,
                                        right: screenSize.size.width / 5 * 0.15),
                                    height: screenSize.size.height / 10 * 0.55,
                                    decoration: BoxDecoration(
                                      color: case2(model.actualState, {
                                        loginStatus.loggedIn: Colors.green,
                                        loginStatus.loggedOff: Colors.grey,
                                        loginStatus.error: Colors.red.shade500,
                                        loginStatus.offline: Colors.orange,
                                      }),
                                      borderRadius: BorderRadius.all(Radius.circular(11)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        case2(
                                          model.actualState,
                                          {
                                            loginStatus.loggedOff: SpinKitThreeBounce(
                                              size: screenSize.size.width / 5 * 0.4,
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                            loginStatus.offline: Icon(
                                              MdiIcons.networkStrengthOff,
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                            loginStatus.error: Icon(
                                              MdiIcons.exclamation,
                                              color: Theme.of(context).primaryColorDark,
                                            ),
                                            loginStatus.loggedIn: Icon(
                                              MdiIcons.check,
                                              color: Theme.of(context).primaryColorDark,
                                            )
                                          },
                                          SpinKitThreeBounce(
                                            size: screenSize.size.width / 5 * 0.4,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                        ),
                                        FittedBox(
                                          child: Row(
                                            children: <Widget>[
                                              Text(
                                                model.details,
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: Theme.of(context).primaryColorDark),
                                              ),
                                              SizedBox(
                                                width: screenSize.size.width / 5 * 0.1,
                                              ),
                                              if(model.actualState==loginStatus.error)
                                              GestureDetector(
                                                onTap: () async{
                                                  await model.login();
                                                },
                                                child: Text(
                                                  "Réessayer",
                                                  style: TextStyle(
                                                      fontFamily: "Asap", color: Colors.blue.shade50),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }),
                    ),
                  ],
                ),
              ))),
    );
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
      var initializationSettings =
          new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onSelectNotification: BackgroundServices.onSelectNotification);

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
