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
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/components/quickMenu.dart';
import 'package:ynotes/UI/screens/agenda/agendaPage.dart';
import 'package:ynotes/UI/screens/cloud/cloudPage.dart';
import 'package:ynotes/UI/screens/downloads/downloadsExplorer.dart';
import 'package:ynotes/UI/screens/grades/gradesPage.dart';
import 'package:ynotes/UI/screens/homework/homeworkPage.dart';
import 'package:ynotes/UI/screens/mail/mailPage.dart';
import 'package:ynotes/UI/screens/polls/pollsPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPage.dart';
import 'package:ynotes/apis/EcoleDirecte.dart';
import 'package:ynotes/background.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/notifications.dart';
import 'package:ynotes/usefulMethods.dart';

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
  PageController drawerPageViewController;
  ValueNotifier<int> _notifier = ValueNotifier<int>(2);
  //Boolean
  bool isChanging = false;

  API apiecoledirecte = APIEcoleDirecte();
  bool firstStart = true;
  AnimationController quickMenuAnimationController;

  Animation<double> quickMenuButtonAnimation;
  StreamSubscription tabBarconnexion;
  final GlobalKey<AgendaPageState> agendaPage = new GlobalKey();
  final GlobalKey<SummaryPageState> summaryPage = new GlobalKey();
  final GlobalKey<HomeworkPageState> homeworkPage = new GlobalKey();
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
          defaultListRecipients: [Recipient(receivedNotification.payload["name"], receivedNotification.payload["surname"], receivedNotification.payload["id"], receivedNotification.payload["isTeacher"] == "true", null)], defaultSubject: receivedNotification.payload["subject"]);
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
    if (receivedNotification.channelKey == "persisnotif" && receivedNotification.toMap()["buttonKeyPressed"] == "REFRESH") {
      await LocalNotification.setOnGoingNotification();
      return;
    }
    if (receivedNotification.channelKey == "persisnotif" && receivedNotification.toMap()["buttonKeyPressed"] == "KILL") {
      await setSetting("agendaOnGoingNotification", false);
      await LocalNotification.cancelOnGoingNotification();
      return;
    }
  }

  @override
  void initState() {
    super.initState();
    AwesomeNotifications().initialize(
        null, [NotificationChannel(channelKey: 'alarm', defaultPrivacy: NotificationPrivacy.Private, channelName: 'Alarmes', importance: NotificationImportance.High, channelDescription: "Alarmes et rappels de l'application yNotes", defaultColor: Color(0xFF9D50DD), ledColor: Colors.white)]);
    try {
      AwesomeNotifications().actionStream.listen((receivedNotification) async {
        await getRelatedAction(receivedNotification);
      });
    } catch (e) {}
    // this creates the controller
    drawerPageViewController = PageController(
      initialPage: 2,
    )..addListener(_onPageViewUpdate);
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
    print("connected");
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
                            notifier: _notifier,
                            drawerPageViewController: drawerPageViewController,
                          );
                        }),
                  )),
            ),
          ),
          backgroundColor: darken(Theme.of(context).backgroundColor, forceAmount: 0.05),
          body: Stack(
            children: <Widget>[
              ClipRRect(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Scaffold(
                      backgroundColor: Theme.of(context).backgroundColor,
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(screenSize.size.height / 10 * 0.7),
                        child: ValueListenableBuilder(
                            valueListenable: _notifier,
                            builder: (context, value, child) {
                              return AppBar(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  title: Text(entries[value]["menuName"]),
                                  actions: [
                                    if ([0, 2, 4].contains(value))
                                      FlatButton(
                                        color: Colors.transparent,
                                        child: Icon(MdiIcons.wrenchOutline, color: isDarkModeEnabled ? Colors.white : Colors.black),
                                        onPressed: () {
                                          switch (value) {
                                            case 0:
                                              {
                                                agendaPage.currentState.triggerSettings();
                                              }
                                              break;
                                            case 2:
                                              {
                                                summaryPage.currentState.triggerSettings();
                                              }
                                              break;
                                            case 4:
                                              {
                                                homeworkPage.currentState.triggerSettings();
                                              }
                                              break;
                                          }
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
                      body: PageView(physics: NeverScrollableScrollPhysics(), controller: drawerPageViewController, children: [
                        AgendaPage(key: agendaPage),
                        DownloadsExplorer(),
                        SummaryPage(
                          switchPage: _switchPage,
                          key: summaryPage,
                        ),
                        SingleChildScrollView(physics: NeverScrollableScrollPhysics(), child: GradesPage()),
                        HomeworkPage(
                          key: homeworkPage,
                        ),
                        MailPage(),
                        CloudPage(),
                        PollsAndInfoPage()
                      ]),
                    ),
                  ],
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
                              margin: EdgeInsets.only(left: screenSize.size.width / 5 * 1.0, right: screenSize.size.width / 5 * 1, top: screenSize.size.height / 10 * 0.1),
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
                              child: FittedBox(
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
                          ),
                        );
                      });
                }),
              ),
            ],
          )),
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
        Mail mail = await mainTestNewMails();
        if (mail != null) {
          String content = await readMail(mail.id, mail.read);
          await LocalNotification.showNewMailNotification(mail, content);
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
    print("test");
    // scroll the calculated ammount
    drawerPageViewController.jumpToPage(index);
  }
}
