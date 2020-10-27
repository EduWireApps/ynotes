import 'dart:async';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/UI/components/quickMenu.dart';
import 'package:ynotes/UI/screens/gradesPage.dart';
import 'package:ynotes/UI/screens/homeworkPage.dart';
import 'package:ynotes/UI/screens/summaryPage.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/parsers/EcoleDirecte.dart';

import '../../models.dart';
import '../../usefulMethods.dart';
import 'agendaPage.dart';
import 'appsPage.dart';
import 'drawerBuilderWidgets/drawer.dart';

///Build a bottom tabbar and tabs
class DrawerBuilder extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _DrawerBuilderState();
  }

  DrawerBuilder({Key key}) : super(key: key);
}

int _currentIndex = 0;
bool isQuickMenuShown = false;
// this will control the button clicks and tab changing
PageController drawerPageViewController;

class _DrawerBuilderState extends State<DrawerBuilder> with TickerProviderStateMixin {
  //Boolean
  bool isChanging = false;

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
  final Duration drawerAnimationDuration = Duration(milliseconds: 150);
  AnimationController bodyController;
  Animation<double> bodyScaleAnimation;
  Animation<Offset> bodyOffsetAnimation;
  Animation<Offset> buttonOffsetAnimation;
  Animation<double> buttonScaleAnimation;
  Animation<double> fadeAnimation;
  bool isDrawerCollapsed = true;
  int actualPage = 0;

  ///Apps
  ///`relatedApi` should be set to null if both APIs can use it
  List<Map> entries = [
    {
      "menuName": "Agenda",
      "icon": MdiIcons.calendar,
    },
    {
      "menuName": "Résumé",
      "icon": MdiIcons.home,
    },
    {
      "menuName": "Notes",
      "icon": MdiIcons.trophy,
    },
    {
      "menuName": "Devoirs",
      "icon": MdiIcons.calendarCheck,
    },
    {"menuName": "Cloud", "icon": MdiIcons.cloud, "relatedApi": 0},
    {"menuName": "Messagerie", "icon": MdiIcons.mail, "relatedApi": 0},
    {"menuName": "Fichiers", "icon": MdiIcons.file, "relatedApi": 0}
  ];
  @override
  void initState() {
    super.initState();

    // this creates the controller
    drawerPageViewController = PageController(initialPage: 1);
    bodyController = AnimationController(vsync: this, duration: drawerAnimationDuration);

    showTransparentLoginStatusController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showTransparentLoginStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(parent: showTransparentLoginStatusController, curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));
    initPlatformState();

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => QuickMenu(removeQuickMenu),
    );

    //Define a controller in order to control  quick menu animation
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));

    if (firstStart == true) {
      firstStart = false;
    }
    //removeQuickMenu();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    tabBarconnexion = connectionStatus.connectionChange.listen(connectionChanged);
    isOffline = !connectionStatus.hasConnection;
    drawerPageViewController.addListener(() => _onPageViewUpdate);
  }

  _onPageViewUpdate(int change) {
    setState(() {
      actualPage = change;
    });
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

  @override
  void dispose() {
    super.dispose();
  }

  bool wiredashShown = false;
  callbackOnShake(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    //status bar info
    SystemChrome.setSystemUIOverlayStyle(isDarkModeEnabled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    bodyScaleAnimation = Tween<double>(begin: 1, end: 0.7).animate(new CurvedAnimation(parent: bodyController, curve: Curves.fastOutSlowIn));
    bodyOffsetAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.45, 0)).animate(new CurvedAnimation(parent: bodyController, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut));
    buttonOffsetAnimation = Tween<Offset>(begin: Offset(-2, 0), end: Offset(0, 0)).animate(new CurvedAnimation(parent: bodyController, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut));
    buttonScaleAnimation = Tween<double>(begin: 5.5, end: 1).animate(new CurvedAnimation(parent: bodyController, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut));
    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(new CurvedAnimation(parent: bodyController, curve: Curves.fastOutSlowIn, reverseCurve: Curves.easeOut));

    double extrasize = 0;
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      //PAppbar
      child: Scaffold(
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          backgroundColor: darken(Theme.of(context).backgroundColor, forceAmount: 0.05),
          body: AnimatedBuilder(
              animation: fadeAnimation,
              builder: (context, snapshot) {
                return Stack(
                  children: <Widget>[
                    CustomDrawer(buttonOffsetAnimation, buttonScaleAnimation, drawerPageViewController.hasClients ? drawerPageViewController.page.round() : null),
                    SlideTransition(
                      position: bodyOffsetAnimation,
                      child: ScaleTransition(
                        scale: bodyScaleAnimation,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          decoration: BoxDecoration(color: Theme.of(context).backgroundColor, borderRadius: BorderRadius.circular(isDrawerCollapsed ? 0 : 25)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25 * fadeAnimation.value),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Scaffold(
                                  backgroundColor: Theme.of(context).backgroundColor,
                                  appBar: PreferredSize(
                                    preferredSize: Size.fromHeight(screenSize.size.height / 10 * 0.7),
                                    child: AppBar(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        title: Text(entries[actualPage]["menuName"]),
                                        leading: FlatButton(
                                          color: Colors.transparent,
                                          child: Icon(MdiIcons.menu, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                          onPressed: () {
                                            print(screenSize.size.height);
                                            if (!isDrawerCollapsed) {
                                              bodyController.reverse();
                                            } else {
                                              bodyController.forward();
                                            }
                                            setState(() {
                                              isDrawerCollapsed = !isDrawerCollapsed;
                                            });
                                          },
                                        )),
                                  ),
                                  body: PageView(physics: BouncingScrollPhysics(), controller: drawerPageViewController, onPageChanged: _onPageViewUpdate, children: [
                                    AgendaPage(),
                                    SummaryPage(switchPage: _switchPage),
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
                                IgnorePointer(
                                  ignoring: isDrawerCollapsed,
                                  child: FadeTransition(
                                    opacity: fadeAnimation,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (!isDrawerCollapsed) {
                                          bodyController.reverse();
                                        }
                                        setState(() {
                                          isDrawerCollapsed = true;
                                        });
                                      },
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                          sigmaX: 0.2 * fadeAnimation.value,
                                          sigmaY: 0.2 * fadeAnimation.value,
                                        ),
                                        child: Container(
                                          color: Colors.black.withOpacity(0.15 * fadeAnimation.value),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    if (isQuickMenuShown)
                      Positioned(
                        top: screenSize.size.height / 10 * 0.1,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 800),
                          color: isQuickMenuShown ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0),
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
                                offset: Offset(0, -screenSize.size.height / 10 * 1.2 * showTransparentLoginStatus.value),
                                child: Opacity(
                                  opacity: 0.55,
                                  child: Container(
                                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.15, right: screenSize.size.width / 5 * 0.15),
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
                                                style: TextStyle(fontFamily: "Asap", color: Theme.of(context).primaryColorDark),
                                              ),
                                              SizedBox(
                                                width: screenSize.size.width / 5 * 0.1,
                                              ),
                                              if (model.actualState == loginStatus.error)
                                                GestureDetector(
                                                  onTap: () async {
                                                    await model.login();
                                                  },
                                                  child: Text(
                                                    "Réessayer",
                                                    style: TextStyle(fontFamily: "Asap", color: Colors.blue.shade50),
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
                );
              })),
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

      print("Starting the headless closed bakground task");
      var initializationSettingsAndroid = new AndroidInitializationSettings('newgradeicon');
      var initializationSettingsIOS = new IOSInitializationSettings();
      var initializationSettings = new InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
      flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
      flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: BackgroundService.onSelectNotification);
//Ensure that grades notification are enabled and battery saver disabled
      if (await getSetting("notificationNewGrade") && !await getSetting("batterySaver")) {
        if (await mainTestNewGrades()) {
          BackgroundService.showNotificationNewGrade();
        } else {
          print("Nothing updated");
        }
      } else {
        print("New grade notification disabled");
      }
      if (await getSetting("notificationNewMail") && !await getSetting("batterySaver")) {
        if (await mainTestNewMails()) {
          BackgroundService.showNotificationNewMail();
        } else {
          print("Nothing updated");
        }
      } else {
        print("New mail notification disabled");
      }
      if (await getSetting("agendaOnGoingNotification")) {
        print("Setting On going notification");
        await LocalNotification.setOnGoingNotification(dontShowActual: true);
      } else {
        print("On going notification disabled");
      }
      BackgroundFetch.finish(taskId);
    }).then((int status) {
      print('[BackgroundFetch] configure success: $status');
    });
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  _switchPage(int index) {
    _scrollTo(index);
  }

  _scrollTo(int index) {
    // scroll the calculated ammount
    drawerPageViewController.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
  }
}
