import 'dart:async';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shake/shake.dart';
import 'package:stacked/stacked.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/UI/components/shifting_tabbar-master/shifting_tabbar.dart';
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

// this will control the button clicks and tab changing
TabController controller;

class _TabBuilderState extends State<TabBuilder> with TickerProviderStateMixin {
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

  // when swiping, the _controller.index value only changes after the animation, therefore, we need this to trigger the animations and save the current index
  int _currentIndex = 1;

  // saves the previous active tab
  int _prevControllerIndex = 0;

  // saves the value of the tab animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
  double _aniValue = 0.0;

  // saves the previous value of the tab animation. It's used to figure the direction of the animation
  double _prevAniValue = 0.0;

  // scroll controller for the TabBar
  ScrollController _scrollController = new ScrollController();

  // regist if the the button was tapped
  bool _buttonTap = false;

  @override
  void initState() {
    super.initState();
    
    // this creates the controller with 6 tabs (in our case)
    controller = TabController(vsync: this, length: 5, initialIndex: 1);

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
    quickMenuAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    quickMenuButtonAnimation = new Tween(
      begin: 1.0,
      end: 1.3,
    ).animate(new CurvedAnimation(parent: quickMenuAnimationController, curve: Curves.easeIn, reverseCurve: Curves.easeOut));

    if (firstStart == true) {
      //Get grades before
      //disciplinesListFuture = localApi.getGrades();
      //Get homework before
      //homeworkListFuture = localApi.getNextHomework();
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

  @override
  void dispose() {
    super.dispose();
  }

  bool wiredashShown = false;
  callbackOnShake(BuildContext context) async {}

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
            bottomNavigationBar: PreferredSize(
              preferredSize: Size.fromHeight(screenSize.size.height / 10 * 0.9),
              child: Container(
                height: screenSize.size.height / 10 * 0.9,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: ShiftingTabBar(
                      // Specify a color to background or it will pick it from primaryColor of your app ThemeData
                      color: Colors.transparent,
                      controller: controller,
                      labelStyle: TextStyle(color: isDarkModeEnabled ? Colors.white : Colors.black, fontFamily: "Asap"),
                      // You can change brightness manually to change text color style to dark and light or
                      // it will decide based on your background color
                      // brightness: Brightness.dark,
                      tabs: [
                        // Also you should use ShiftingTab widget instead of Tab widget to get shifting animation
                        ShiftingTab(
                          icon: Icon(Icons.home, color: isDarkModeEnabled ? Colors.white : Colors.black),
                          text: "Space",
                        ),
                        ShiftingTab(
                          icon: Icon(Icons.insert_chart, color: isDarkModeEnabled ? Colors.white : Colors.black),
                          text: "Résumé",
                        ),
                        ShiftingTab(icon: Icon(MdiIcons.formatListNumbered, color: isDarkModeEnabled ? Colors.white : Colors.black), text: "Notes"),
                        ShiftingTab(icon: Icon(MdiIcons.viewAgenda, color: isDarkModeEnabled ? Colors.white : Colors.black), text: "Devoirs"),
                        ShiftingTab(icon: Icon(MdiIcons.appsBox, color: isDarkModeEnabled ? Colors.white : Colors.black), text: "Apps"),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            body: Container(
              child: Stack(
                children: <Widget>[
                  TabBarView(physics: BouncingScrollPhysics(), controller: controller, children: [
                    SpacePage(),
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
              ),
            )),
      ),
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
    controller.animateTo(index);
  }
}
