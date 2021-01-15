import 'dart:async';
import 'dart:ui';

import 'package:awesome_notifications/awesome_notifications.dart';
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
import 'package:workmanager/workmanager.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/components/quickMenu.dart';
import 'package:ynotes/UI/screens/agenda/agendaPage.dart';
import 'package:ynotes/UI/screens/cloud/cloudPage.dart';
import 'package:ynotes/UI/screens/downloads/downloadsExplorer.dart';
import 'package:ynotes/UI/screens/grades/gradesPage.dart';
import 'package:ynotes/UI/screens/homework/homeworkPage.dart';
import 'package:ynotes/UI/screens/mail/mailPage.dart';
import 'package:ynotes/UI/screens/polls/pollsPage.dart';
import 'package:ynotes/UI/screens/statspage/statspage.dart';
import 'package:ynotes/UI/screens/summary/summaryPage.dart';
import 'package:ynotes/UI/screens/viescolaire/schoolLifePage.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/models/homework/controller.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

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

class _DrawerBuilderState extends State<DrawerBuilder> with TickerProviderStateMixin {
  ///Apps
  ///`relatedApi` should be set to null if both APIs can use it
  ///-1 is only shown in debug mode
  List<Map> entries() {
    return [
      {
        "menuName": "Résumé",
        "icon": MdiIcons.home,
        "page": SummaryPage(
          switchPage: _switchPage,
          key: summaryPage,
        ),
        "key": summaryPage
      },
      {
        "menuName": "Vie Scolaire",
        "icon": MdiIcons.stamper,
        "page": SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: SchoolLifePage()),
      },
      {
        "menuName": "Notes",
        "icon": MdiIcons.trophy,
        "page": SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: GradesPage()),
      },
      {
        "menuName": "Devoirs",
        "icon": MdiIcons.calendarCheck,
        "page": HomeworkPage(
          key: homeworkPage,
        ),
        "key": homeworkPage
      },
      {"menuName": "Agenda", "icon": MdiIcons.calendar, "page": AgendaPage(key: agendaPage), "key": agendaPage},
      {
        "menuName": "Messagerie",
        "icon": MdiIcons.mail,
        "relatedApi": 0,
        "page": MailPage(),
      },
      {"menuName": "Cloud", "icon": MdiIcons.cloud, "relatedApi": 0, "page": CloudPage()},
      {"menuName": "Sondages", "icon": MdiIcons.poll, "relatedApi": 1, "page": PollsAndInfoPage()},
      {
        "menuName": "Fichiers",
        "icon": MdiIcons.file,
        "relatedApi": 0,
        "page": DownloadsExplorer(),
      },
      {
        "menuName": "Statistiques",
        "icon": MdiIcons.chartBar,
        "relatedApi": -1,
        "page": StatsPage(),
      },
    ];
  }

  PageController drawerPageViewController;
  ValueNotifier<int> _notifier = ValueNotifier<int>(0);
  //Boolean
  bool isChanging = false;

  bool firstStart = true;
  AnimationController quickMenuAnimationController;

  Animation<double> quickMenuButtonAnimation;
  StreamSubscription tabBarconnexion;
  GlobalKey<AgendaPageState> agendaPage = new GlobalKey();
  GlobalKey<SummaryPageState> summaryPage = new GlobalKey();
  GlobalKey<HomeworkPageState> homeworkPage = new GlobalKey();
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
  int _previousPage;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  //Chose which triggered action to use
  getRelatedAction(ReceivedNotification receivedNotification) async {
    if (receivedNotification.channelKey == "newmail" && receivedNotification.toMap()["buttonKeyPressed"] == "REPLY") {
      CustomDialogs.writeModalBottomSheet(context,
          defaultListRecipients: [
            Recipient(receivedNotification.payload["name"], receivedNotification.payload["surname"],
                receivedNotification.payload["id"], receivedNotification.payload["isTeacher"] == "true", null)
          ],
          defaultSubject: receivedNotification.payload["subject"]);
      return;
    }

    if (receivedNotification.channelKey == "newmail" && receivedNotification.toMap()["buttonKeyPressed"] != null) {
      drawerPageViewController.jumpToPage(4);
      return;
    }

    if (receivedNotification.channelKey == "newgrade" && receivedNotification.toMap()["buttonKeyPressed"] != null) {
      drawerPageViewController.jumpToPage(3);
      return;
    }
    if (receivedNotification.channelKey == "persisnotif" &&
        receivedNotification.toMap()["buttonKeyPressed"] == "REFRESH") {
      await AppNotification.setOnGoingNotification();
      return;
    }
    if (receivedNotification.channelKey == "persisnotif" &&
        receivedNotification.toMap()["buttonKeyPressed"] == "KILL") {
      await setSetting("agendaOnGoingNotification", false);
      await AppNotification.cancelOnGoingNotification();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    //Init hw controller
    hwcontroller = HomeworkController(localApi);
    AwesomeNotifications().initialize(null, [
      NotificationChannel(
          channelKey: 'alarm',
          defaultPrivacy: NotificationPrivacy.Private,
          channelName: 'Alarmes',
          importance: NotificationImportance.High,
          channelDescription: "Alarmes et rappels de l'application yNotes",
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ]);
    try {
      AwesomeNotifications().actionStream.listen((receivedNotification) async {
        await getRelatedAction(receivedNotification);
      });
    } catch (e) {}
    // this creates the controller
    drawerPageViewController = PageController(
      initialPage: 0,
    )..addListener(_onPageViewUpdate);
    bodyController = AnimationController(vsync: this, duration: drawerAnimationDuration);

    showTransparentLoginStatusController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showTransparentLoginStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: showTransparentLoginStatusController, curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));

    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => QuickMenu(removeQuickMenu),
    );

    //Define a controller in order to control  quick menu animation
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(
        new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));

    if (firstStart == true) {
      firstStart = false;
    }
    //removeQuickMenu();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    tabBarconnexion = connectionStatus.connectionChange.listen(connectionChanged);
    isOffline = !connectionStatus.hasConnection;
    _previousPage = drawerPageViewController.initialPage;
  }

  _onPageViewUpdate() {
    _notifier?.value = drawerPageViewController.page.round();
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

  @override
  void dispose() {
    _notifier?.dispose();
    drawerPageViewController.dispose();
    super.dispose();
  }

  void connectionChanged(dynamic hasConnection) {
    print("Connection changed");
    setState(() {
      isOffline = !hasConnection;
    });
  }

  bool wiredashShown = false;
  callbackOnShake(BuildContext context) async {}

  @override
  Widget build(BuildContext context) {
    //status bar info
    SystemChrome.setSystemUIOverlayStyle(isDarkModeEnabled ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);

    double extrasize = 0;
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      //PAppbar
      child: Scaffold(
          key: _drawerKey,
          resizeToAvoidBottomPadding: false,
          resizeToAvoidBottomInset: false,
          drawer: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme.of(context).primaryColor, //This will change the drawer background to blue.
              //other styles
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                  width: screenSize.size.width / 5 * 3.6,
                  child: Drawer(
                    child: ValueListenableBuilder(
                        valueListenable: _notifier,
                        builder: (context, value, child) {
                          return CustomDrawer(
                            entries(),
                            notifier: _notifier,
                            drawerPageViewController: drawerPageViewController,
                          );
                        }),
                  )),
            ),
          ),
          backgroundColor: ThemeUtils.darken(Theme.of(context).backgroundColor, forceAmount: 0.05),
          body: Stack(
            children: <Widget>[
              ClipRRect(
                child: Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(screenSize.size.height / 10 * 0.7),
                    child: ValueListenableBuilder(
                        valueListenable: _notifier,
                        builder: (context, value, child) {
                          return AppBar(
                              shadowColor: Colors.transparent,
                              backgroundColor: isDarkModeEnabled
                                  ? Theme.of(context).primaryColorLight
                                  : Theme.of(context).primaryColorDark,
                              title: Text(entries()[value]["menuName"]),
                              actions: [
                                if (entries()[value]["key"] != null)
                                  FlatButton(
                                    color: Colors.transparent,
                                    child:
                                        Icon(MdiIcons.wrench, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                    onPressed: () {
                                      entries()[value]["key"].currentState.triggerSettings();
                                    },
                                  )
                              ],
                              leading: FlatButton(
                                color: Colors.transparent,
                                child: Icon(MdiIcons.menu, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                onPressed: () {
                                  _drawerKey.currentState.openDrawer();
                                },
                              ));
                        }),
                  ),
                  body: PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: drawerPageViewController,
                    itemBuilder: (context, index) {
                      return entries()[index]["page"];
                    },
                  ),
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
                            opacity: 0.8,
                            child: Container(
                              margin: EdgeInsets.only(
                                  left: screenSize.size.width / 5 * 2.25, top: screenSize.size.height / 10 * 0.1),
                              height: screenSize.size.width / 5 * 0.5,
                              width: screenSize.size.width / 5 * 0.5,
                              padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                              decoration: BoxDecoration(
                                color: case2(model.actualState, {
                                  loginStatus.loggedIn: Colors.green,
                                  loginStatus.loggedOff: Colors.grey,
                                  loginStatus.error: Colors.red.shade500,
                                  loginStatus.offline: Colors.orange,
                                }),
                                borderRadius: BorderRadius.all(Radius.circular(1000)),
                              ),
                              child: FittedBox(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    case2(
                                      model.actualState,
                                      {
                                        loginStatus.loggedOff: SpinKitThreeBounce(
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        loginStatus.offline: Icon(
                                          MdiIcons.networkStrengthOff,
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        ),
                                        loginStatus.error: GestureDetector(
                                          onTap: () async {
                                            await model.login();
                                          },
                                          child: Icon(
                                            MdiIcons.exclamation,
                                            size: screenSize.size.width / 5 * 0.3,
                                            color: Theme.of(context).primaryColorDark,
                                          ),
                                        ),
                                        loginStatus.loggedIn: Icon(
                                          MdiIcons.check,
                                          size: screenSize.size.width / 5 * 0.3,
                                          color: Theme.of(context).primaryColorDark,
                                        )
                                      },
                                      SpinKitThreeBounce(
                                        size: screenSize.size.width / 5 * 0.4,
                                        color: Theme.of(context).primaryColorDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                }),
              ),
            ],
          )),
    );
  }

  _switchPage(int index) {
    _scrollTo(index);
  }

  _scrollTo(int index) {
    print("test");
    // scroll the calculated ammount
    drawerPageViewController.jumpToPage(index);
  }
}
