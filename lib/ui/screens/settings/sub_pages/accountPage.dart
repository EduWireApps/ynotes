import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';
import 'package:ynotes/usefulMethods.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class LoginStatus extends StatefulWidget {
  @override
  _LoginStatusState createState() => _LoginStatusState();
}

class _AccountPageState extends State<AccountPage> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            LoginStatus(),
            Card(
              color: Theme.of(context).primaryColor,
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: (screenSize.size.width / 5) * 0.1, vertical: (screenSize.size.width / 5) * 0.1),
                child: Column(
                  children: [
                    buildMainAccountInfos(),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: (screenSize.size.width / 5) * 0.1, vertical: (screenSize.size.width / 5) * 0.1),
                      child: SingleChildScrollView(
                          child: ExpansionPanelList(
                              expandedHeaderPadding: EdgeInsets.zero,
                              expansionCallback: (index, newVal) {
                                setState(() {
                                  isExpanded = !newVal;
                                });
                              },
                              children: (appSys.account!.managableAccounts ?? [])
                                  .map((e) => buildAccountDetail(e))
                                  .toList())),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.2,
            ),
            GestureDetector(
              onTap: () async {
                launch('https://support.ynotes.fr/compte');
              },
              child: Text("En savoir plus sur les comptes",
                  style: TextStyle(
                    fontFamily: 'Asap',
                    color: Colors.transparent,
                    shadows: [Shadow(color: ThemeUtils.textColor(), offset: Offset(0, -5))],
                    fontSize: 14,
                    decorationColor: ThemeUtils.textColor(),
                    fontWeight: FontWeight.normal,
                    textBaseline: TextBaseline.alphabetic,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2,
                    decorationStyle: TextDecorationStyle.dashed,
                  )),
            ),
          ],
        ),
      ),
      appBar: new AppBar(
        title: new Text("Compte"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  ExpansionPanel buildAccountDetail(SchoolAccount account) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ExpansionPanel(
        backgroundColor: Theme.of(context).primaryColor,
        isExpanded: isExpanded,
        canTapOnHeader: true,
        headerBuilder: (context, index) {
          return Center(
            child: Container(
              width: screenSize.size.width,
              child: Wrap(
                alignment: WrapAlignment.start,
                crossAxisAlignment: WrapCrossAlignment.center,
                direction: Axis.horizontal,
                spacing: screenSize.size.width / 5 * 0.1,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                    padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColorDark, borderRadius: BorderRadius.circular(11)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (appSys.currentSchoolAccount == account)
                          Container(
                              child: Icon(
                            Icons.power,
                            color: ThemeUtils.textColor(),
                          )),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width / 10 * 0.1),
                          child: Image(
                            width: MediaQuery.of(context).size.width /
                                5 *
                                (appSys.account?.apiType == API_TYPE.EcoleDirecte ? 0.2 : 0.4),
                            height: screenSize.size.width /
                                5 *
                                (appSys.account?.apiType == API_TYPE.EcoleDirecte ? 0.2 : 0.4),
                            image: AssetImage(appSys.account?.apiType == API_TYPE.EcoleDirecte
                                ? 'assets/images/EcoleDirecte/EcoleDirecteIcon.png'
                                : 'assets/images/Pronote/PronoteIcon.png'),
                            color: appSys.account?.apiType == API_TYPE.EcoleDirecte ? ThemeUtils.textColor() : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5 * 0.3,
                  ),
                  Text(
                    account.name ?? "",
                    style: TextStyle(
                      fontFamily: "Asap",
                      color: ThemeUtils.textColor(),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
        body: Container(
          decoration: BoxDecoration(color: Theme.of(context).primaryColorDark),
          padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildKeyValuesInfo(context, "Prénom", [(account.name ?? "")]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              buildKeyValuesInfo(context, "Nom", [(account.surname ?? "")]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              buildKeyValuesInfo(context, "Classe", [(account.studentClass ?? "")]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              Container(
                width: screenSize.size.width,
                child: buildKeyValuesInfo(context, "Etablissement scolaire", [(account.schoolName ?? "")]),
              ),
              SizedBox(
                height: screenSize.size.height / 10 * 0.3,
              ),
              if (appSys.currentSchoolAccount != account)
                Center(
                  child: CustomButtons.materialButton(
                      context, screenSize.size.width / 5 * 1.7, screenSize.size.height / 10 * 0.4, () {
                    setState(() {
                      appSys.currentSchoolAccount = account;
                    });
                  }, backgroundColor: Colors.blue, label: "Se connecter"),
                )
            ],
          ),
        ));
  }

  buildMainAccountInfos() {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      children: [
        Wrap(
          spacing: screenSize.size.width / 5 * 0.05,
          children: [
            Text(
              "Bonjour " + (appSys.account?.name ?? "{pas de nom}"),
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Asap", color: ThemeUtils.textColor()),
            ),
            Text(
              appSys.account?.surname ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Asap", color: ThemeUtils.textColor()),
            ),
          ],
        ),
        (appSys.account?.isParentMainAccount ?? false)
            ? Text(
                "Vous pouvez gérer le(s) compte(s) suivant(s) :",
                style: TextStyle(fontWeight: FontWeight.w200, fontFamily: "Asap", color: ThemeUtils.textColor()),
              )
            : Text(
                "Votre compte :",
                style: TextStyle(fontWeight: FontWeight.w200, fontFamily: "Asap", color: ThemeUtils.textColor()),
              ),
      ],
    );
  }
}

class _LoginStatusState extends State<LoginStatus> {
  ExpandableController controller = ExpandableController();
  String loggedTitle = "Tout va bien vous êtes connecté !";
  String loggedLabel = "Les petits oiseaux chantent et le ciel est bleu.";

  String offlineTitle = "Vous êtes hors ligne";
  String offlineLabel = "Vous pouvez accéder à vos données hors ligne.";

  String loggedOffTitle = "Vous êtes déconnecté";
  String loggedOffLabel = "Nous vous connectons...";

  String errorTitle = "Aille... une erreur a eu lieu.";
  String errorLabel = "Regardez les détails pour trouver de l'aide.";

  String apiIssues = "Il se peut que votre système scolaire rencontre des problèmes !";

  String errorExplanation =
      "Consultez l'erreur suivante. Reconnectez-vous maintenant ou dans quelques minutes. Si rien ne change, consultez le support avec le bouton ci-dessous.";
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
      child: ChangeNotifierProvider.value(
        value: appSys.loginController,
        child: Consumer(
          builder: (context, LoginController model, child) {
            return buildLoginStatus(model);
          },
        ),
      ),
    );
  }

  buildErrorDetails(LoginController model) {
    return Card(
      margin: EdgeInsets.zero,
      color: case2(model.actualState, {
        loginStatus.loggedIn: Color(0xff4ADE80),
        loginStatus.loggedOff: Color(0xffA8A29E),
        loginStatus.error: Color(0xffEF4444),
        loginStatus.offline: Color(0xffFCD34D),
      }),
      child: (Column(
        children: [
          Text("Que dois-je faire ?"),
          Text(errorExplanation),
        ],
      )),
    );
  }

  buildExpandable() {}
  Widget buildIcon(LoginController _loginController) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return case2(
      _loginController.actualState,
      {
        loginStatus.loggedOff: SpinKitThreeBounce(
          size: screenSize.size.width / 5 * 0.3,
          color: Colors.black38,
        ),
        loginStatus.offline: Icon(
          MdiIcons.networkStrengthOff,
          size: screenSize.size.width / 5 * 0.3,
          color: Colors.black38,
        ),
        loginStatus.error: GestureDetector(
          child: Icon(
            MdiIcons.exclamation,
            size: screenSize.size.width / 5 * 0.3,
            color: Colors.black38,
          ),
        ),
        loginStatus.loggedIn: Icon(
          MdiIcons.check,
          size: screenSize.size.width / 5 * 0.3,
          color: Colors.black38,
        )
      },
      SpinKitThreeBounce(
        size: screenSize.size.width / 5 * 0.4,
        color: Colors.black38,
      ),
    ) as Widget;
  }

  buildLoginStatus(LoginController model) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        print("ok");
        setState(() {
          controller.toggle();
        });
      },
      child: Expandable(
        controller: controller,
        collapsed: buildTopCard(model),
        expanded: Column(
          children: [buildTopCard(model), buildErrorDetails(model)],
        ),
      ),
    );
  }

  buildTopCard(LoginController model) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Card(
      color: case2(model.actualState, {
        loginStatus.loggedIn: Color(0xff4ADE80),
        loginStatus.loggedOff: Color(0xffA8A29E),
        loginStatus.error: Color(0xffEF4444),
        loginStatus.offline: Color(0xffFCD34D),
      }),
      child: Container(
        width: screenSize.size.width,
        padding: EdgeInsets.symmetric(
            vertical: screenSize.size.height / 10 * 0.1, horizontal: screenSize.size.width / 5 * 0.1),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: screenSize.size.height / 10 * 0.7,
                width: screenSize.size.height / 10 * 0.7,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ThemeUtils.darken(
                        case2(model.actualState, {
                          loginStatus.loggedIn: Color(0xff4ADE80),
                          loginStatus.loggedOff: Color(0xffA8A29E),
                          loginStatus.error: Color(0xffEF4444),
                          loginStatus.offline: Color(0xffFCD34D),
                        }) as Color,
                        forceAmount: 0.15)),
                child: buildIcon(model),
              ),
            ),
            SizedBox(
              width: screenSize.size.width / 5 * 0.1,
            ),
            Flexible(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    choseDetails(model)[0],
                    maxLines: 100,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
                  ),
                  Text(
                    choseDetails(model)[1],
                    maxLines: 100,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w200),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  choseDetails(LoginController _loginController) {
    if (_loginController.actualState == loginStatus.loggedIn) {
      return [loggedTitle, loggedLabel];
    }
    if (_loginController.actualState == loginStatus.loggedOff) {
      return [loggedOffTitle, loggedOffLabel];
    }
    if (_loginController.actualState == loginStatus.offline) {
      return [offlineTitle, offlineLabel];
    }
    if (_loginController.actualState == loginStatus.error) {
      return [errorTitle, errorLabel];
    }
  }
}
