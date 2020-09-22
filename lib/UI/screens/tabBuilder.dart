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
import 'package:shake/shake.dart';
import 'package:stacked/stacked.dart';
import 'package:wiredash/wiredash.dart';
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
    // this will execute the function every time there's a swipe animation
    controller.animation.addListener(_handleTabAnimation);
    // this will execute the function every time the _controller.index value changes
    controller.addListener(_handleTabChange);
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
    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () {
      callbackOnShake(context);
    });

    double extrasize = 0;
    return WillPopScope(
      onWillPop: () async {
        Future.value(false);
        return false;
      },
      //PAppbar
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
                                              controller.index = index;
                                            });
                                            _setCurrentIndex(index);
                                          },
                                          controller: controller,
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
                                                    controller.index = 0;
                                                  });

                                                  _setCurrentIndex(0);
                                                  //removeQuickMenu();
                                                },
                                                onLongPress: () {},
                                                child: Tab(
                                                  child: AnimatedContainer(
                                                    margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                                    duration: Duration(milliseconds: 170),
                                                    width: (_currentIndex == 0 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
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
                                                          if (_currentIndex == 0)
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
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    controller.index = 1;
                                                  });
                                                  _setCurrentIndex(1);
                                                },
                                                child: AnimatedContainer(
                                                  margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                                  duration: Duration(milliseconds: 170),
                                                  width: (_currentIndex == 1 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                                  child: Align(
                                                    alignment: Alignment.center,
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: <Widget>[
                                                        Icon(
                                                          Icons.info,
                                                          color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                        ),
                                                        if (_currentIndex == 1)
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
                                            ),

                                            ///Grades page
                                            Badge(
                                              animationType: BadgeAnimationType.scale,
                                              toAnimate: true,
                                              showBadge: newGrades,
                                              elevation: 0,
                                              position: BadgePosition.topRight(right: MediaQuery.of(context).size.width / 10 * 0.001, top: MediaQuery.of(context).size.height / 15 * 0.11),
                                              badgeColor: Colors.blue,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    controller.index = 2;
                                                  });
                                                  _setCurrentIndex(2);
                                                },
                                                child: Tab(
                                                  child: AnimatedContainer(
                                                    margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                                    duration: Duration(milliseconds: 170),
                                                    width: (_currentIndex == 2 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
                                                    child: Align(
                                                      alignment: Alignment.center,
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: <Widget>[
                                                          Icon(
                                                            Icons.format_list_numbered,
                                                            color: isDarkModeEnabled ? Colors.white : Colors.black,
                                                          ),
                                                          if (_currentIndex == 2)
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
                                            ),

                                            ///Homework page
                                            AnimatedContainer(
                                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                              duration: Duration(milliseconds: 170),
                                              width: (_currentIndex == 3 ? MediaQuery.of(context).size.width / 5 * 1.2 : MediaQuery.of(context).size.width / 5 * 0.45),
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    controller.index = 3;
                                                  });
                                                  _setCurrentIndex(3);
                                                },
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
                                                        if (_currentIndex == 3)
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
                                            ),

                                            ///Apps page
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  controller.index = 4;
                                                });
                                                _setCurrentIndex(4);
                                              },
                                              child: AnimatedContainer(
                                                duration: Duration(milliseconds: 170),
                                                margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.15),
                                                width: (_currentIndex == 4 ? MediaQuery.of(context).size.width / 5 * 1.5 : MediaQuery.of(context).size.width / 5 * 0.5),
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
                                                        if (_currentIndex == 4)
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
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ))))),
          body: Container(
            child: Stack(
              children: <Widget>[
                TabBarView(controller: controller, children: [
                  SpacePage(),
                  SummaryPage(tabController: controller),
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
        await LocalNotification.setOnGoingNotification();
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

  // runs during the switching tabs animation
  _handleTabAnimation() {
    // gets the value of the animation. For example, if one is between the 1st and the 2nd tab, this value will be 0.5
    _aniValue = controller.animation.value;

    // if the button wasn't pressed, which means the user is swiping, and the amount swipped is less than 1 (this means that we're swiping through neighbor Tab Views)
    if (!_buttonTap && ((_aniValue - _prevAniValue).abs() < 1)) {
      // set the current tab index
      _setCurrentIndex(_aniValue.round());
    }

    // save the previous Animation Value
    _prevAniValue = _aniValue;
  }

  // runs when the displayed tab changes
  _handleTabChange() {
    // if a button was tapped, change the current index
    if (_buttonTap) _setCurrentIndex(controller.index);

    // this resets the button tap
    if ((controller.index == _prevControllerIndex) || (controller.index == _aniValue.round())) _buttonTap = false;

    // save the previous controller index
    _prevControllerIndex = controller.index;
  }

  _setCurrentIndex(int index) {
    // if we're actually changing the index
    if (index != _currentIndex) {
      setState(() {
        // change the index
        _currentIndex = index;
      });
      // scroll the TabBar to the correct position (if we have a scrollable bar)
      _scrollTo(index);
    }
  }

  _scrollTo(int index) {
    // scroll the calculated ammount
    controller.animateTo(index);
  }
}
