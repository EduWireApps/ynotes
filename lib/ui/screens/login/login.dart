import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/pronote/schools_model.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/y_page/mixins.dart';
import 'package:ynotes/ui/components/y_page/y_page_local.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes/ui/screens/login/widgets/api_choice_box.dart';
import 'package:ynotes/ui/screens/login/widgets/contact_bottom_sheet.dart';
import 'package:ynotes/ui/screens/login/widgets/login_box.dart';
import 'package:ynotes/ui/screens/login/widgets/login_dialog.dart';
import 'package:ynotes/ui/screens/login/widgets/pronote_geolocation_box.dart';
import 'package:ynotes/ui/screens/login/widgets/pronote_login_way_box.dart';
import 'package:ynotes/ui/screens/login/widgets/pronote_qr_box.dart';
import 'package:ynotes/ui/screens/login/widgets/pronote_url_box.dart';
import 'package:ynotes/ui/screens/settings/sub_pages/logs.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

enum availableLoginPageBoxes {
  ApiChoiceBox,
  PronoteLoginWayBox,
  PronoteQrCodeBox,
  PronoteGeolocationBox,
  PronoteUrlBox,
  LoginBox
}

class LoginPageBox {
  final availableLoginPageBoxes box;
  final Widget widget;

  LoginPageBox({required this.box, required this.widget});
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin, YPageMixin {
  availableLoginPageBoxes previousPage = availableLoginPageBoxes.ApiChoiceBox;
  availableLoginPageBoxes currentPage = availableLoginPageBoxes.ApiChoiceBox;

  PageController? pageController;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _url = TextEditingController();
  late PronoteSpace chosenSpace;
  Future<List>? connectionData;
  @override
  Widget build(BuildContext context) {
    //build background
    return Scaffold(
      body: Material(
        color: theme.colors.neutral.shade100,
        child: SafeArea(
          child: Stack(
            children: [
              //background
              Column(
                children: [
                  Expanded(
                      child: Container(
                    color: theme.colors.neutral.shade100,
                  )),
                  Expanded(
                      child: Container(
                    color: theme.colors.neutral.shade200,
                  ))
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  _buildTopButtons(),
                  Expanded(child: _buildPageView()),
                  _buildMetaPart()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///Pronote demonstration login
  Future<void> demoLogin() async {
    if (appSys.settings.system.chosenParser == 1 &&
        _url.text.length == 0 &&
        _password.text.length == 0 &&
        _username.text.length == 0) {
      connectionData = appSys.api!.login("demonstration", "pronotevs", additionnalSettings: {
        "url": "https://demo.index-education.net/pronote/parent.html",
        "mobileCasLogin": false,
      });
    }
    if (connectionData != null) LoginDialog(connectionData!).show(context);
  }

  Future<void> ecoleDirecteDemoLogin() async {
    connectionData = appSys.api!.login("john.doe", "123456", additionnalSettings: {
      "demo": true,
    });
    if (connectionData != null) LoginDialog(connectionData!).show(context);
  }

  goToPage(availableLoginPageBoxes box, {bool back = false}) {
    if (!back) {
      setState(() {
        previousPage = currentPage;
        currentPage = box;
      });
    }

    CustomLogger.log("LOGIN", [previousPage, currentPage]);

    pageController?.jumpToPage(pageBoxes().indexWhere((element) => element.box == box));
  }

  initState() {
    super.initState();
    pageController = PageController();
  }

  ///All the available page boxes
  List<LoginPageBox> pageBoxes() {
    return [
      LoginPageBox(
          box: availableLoginPageBoxes.ApiChoiceBox,
          widget: _buildSinglePage(
              title: LoginPageTextContent.apiChoice.pageTitle,
              description: LoginPageTextContent.apiChoice.pageDescription,
              child: ApiChoiceBox(
                callback: () async {
                  await setChosenParser(appSys.settings.system.chosenParser);
                  await appSys.initOffline();
                  setState(() {
                    appSys.api = apiManager(appSys.offline);
                  });
                  if (appSys.api?.apiName == "Pronote") {
                    goToPage(availableLoginPageBoxes.PronoteLoginWayBox);
                  } else {
                    goToPage(availableLoginPageBoxes.LoginBox);
                  }
                },
              ))),
      LoginPageBox(
        box: availableLoginPageBoxes.PronoteLoginWayBox,
        widget: _buildSinglePage(
            title: appSys.api?.apiName ?? "",
            description: LoginPageTextContent.pronote.loginWays.pageDescription,
            child: PronoteLoginWayBox(callback: (String way) {
              _pronoteSetupPartCallback(way);
            })),
      ),
      LoginPageBox(
        box: availableLoginPageBoxes.PronoteUrlBox,
        widget: _buildSinglePage(
            title: appSys.api?.apiName ?? "",
            description: LoginPageTextContent.pronote.url.pageDescription,
            child: PronoteUrlBox(
              urlCon: _url,
              longPressCallBack: () => demoLogin(),
              callback: () => goToPage(availableLoginPageBoxes.LoginBox),
            )),
      ),
      LoginPageBox(
        box: availableLoginPageBoxes.PronoteQrCodeBox,
        widget: _buildSinglePage(
            title: appSys.api?.apiName ?? "",
            description: LoginPageTextContent.pronote.qrCode.pageDescription,
            child: PronoteQrCodeBox()),
      ),
      LoginPageBox(
        box: availableLoginPageBoxes.PronoteGeolocationBox,
        widget: _buildSinglePage(
            title: appSys.api?.apiName ?? "",
            description: LoginPageTextContent.pronote.qrCode.pageDescription,
            child: PronoteGeolocationBox(
              callback: (String url) {
                _url.text = url;
                goToPage(availableLoginPageBoxes.PronoteUrlBox);
              },
            )),
      ),
      LoginPageBox(
        box: availableLoginPageBoxes.LoginBox,
        widget: _buildSinglePage(
            title: appSys.api?.apiName ?? "",
            description: LoginPageTextContent.login.pageDescription,
            child: LoginBox(
              passwordCon: _password,
              loginCon: _username,
              longPressCallback: () => ecoleDirecteDemoLogin(),
              callback: () => simpleLogin(),
            )),
      ),
    ];
  }

  Future<void> simpleLogin() async {
    //Actions when pressing the ok button
    if (_username.text != "" && (appSys.settings.system.chosenParser == 1 ? _url.text != "" : true)) {
      //Login using the chosen API
      connectionData = appSys.api!.login(_username.text.trim(), _password.text.trim(),
          additionnalSettings: {"url": _url.text.trim(), "mobileCasLogin": false, "demo": false});
      if (connectionData != null) LoginDialog(connectionData!).show(context);
    } else {
      CustomLogger.log("LOGIN", _username.text);
      CustomDialogs.showAnyDialog(context, "Remplissez tous les champs.");
    }
  }

  titleAndLabel({required String name, required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [Spacer()],
        ),
        Text(name,
            style: TextStyle(
                fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: 40, color: theme.colors.neutral.shade500)),
        Text(label,
            style: TextStyle(
                fontFamily: "Asap", fontWeight: FontWeight.w600, fontSize: 20, color: theme.colors.neutral.shade400)),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  _buildMetaPart() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      decoration: BoxDecoration(color: theme.colors.neutral.shade100),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0.9.h),
      width: screenSize.size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: InkWell(
                child: new Text(
                  'FAQ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Asap",
                      fontWeight: FontWeight.normal,
                      color: theme.colors.neutral.shade400,
                      fontSize: 17),
                ),
                onTap: () => launch('https://ynotes.fr/faq')),
          ),
          Expanded(
              child: InkWell(
            child: new Text('Contact',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.normal,
                    color: theme.colors.neutral.shade400,
                    fontSize: 17)),
            onTap: () => contactBottomSheet(context),
          )),
          Expanded(
            child: InkWell(
                child: new Text(
                  'CGU',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Asap",
                      fontWeight: FontWeight.normal,
                      color: theme.colors.neutral.shade400,
                      fontSize: 17),
                ),
                onTap: () => launch('https://ynotes.fr/legal/CGUYNotes.pdf')),
          ),
        ],
      ),
    );
  }

  _buildPageView() {
    return PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
      children: pageBoxes().map((e) => e.widget).toList(),
    );
  }

  Widget _buildSinglePage({required Widget child, required String title, required String description}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
            width: 90.w.clamp(0, 400),
            child: Column(
              children: [
                FadeAnimation(0.2, titleAndLabel(name: title, label: description)),
                Align(alignment: Alignment.center, child: FadeAnimation(0.2, child)),
              ],
            )),
        SizedBox(
          height: 50,
        ),
      ],
    );
  }

  _buildTopButtons() {
    return Row(
      children: [
        SizedBox(
          width: 5,
        ),
        YButton(
            onPressed: () {
              goToPage(availableLoginPageBoxes.ApiChoiceBox);
            },
            text: "Retour",
            icon: Icons.chevron_left),
        Spacer(),
        YButton(
            onPressed: () async {
              openLocalPage(YPageLocal(child: LogsPage(), title: "Logs"));
            },
            text: "Logs",
            icon: Icons.bug_report),
        SizedBox(
          width: 5,
        ),
      ],
    );
  }

  _pronoteSetupPartCallback(String id) async {
    switch (id) {
      case "qrcode":
        {
          goToPage(availableLoginPageBoxes.PronoteQrCodeBox);
        }
        break;
      case "location":
        {
          goToPage(availableLoginPageBoxes.PronoteGeolocationBox);
        }
        break;
      case "manual":
        {
          goToPage(availableLoginPageBoxes.PronoteUrlBox);
        }
        break;
    }
  }
}
