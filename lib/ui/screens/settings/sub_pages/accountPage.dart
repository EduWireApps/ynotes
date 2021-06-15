import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wiredash/wiredash.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
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
  List<bool?> expanded = List.filled((appSys.account!.managableAccounts ?? []).length, false);
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ConstrainedBox(constraints: BoxConstraints(maxWidth: 500), child: LoginStatus()),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Card(
              color: Theme.of(context).primaryColorLight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: (screenSize.size.width / 5) * 0.1),
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
                                print(index);
                                setState(() {
                                  expanded[index] = !(expanded[index] ?? false);
                                });
                              },
                              children: (appSys.account!.managableAccounts ?? [])
                                  .map((e) =>
                                      buildAccountDetail(e, (appSys.account!.managableAccounts ?? []).indexOf(e)))
                                  .toList())),
                    ),
                    CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.45, () async {
                      if (await CustomDialogs.showConfirmationDialog(context, null,
                              alternativeText:
                                  "Voulez-vous vraiment vous déconnecter (et supprimer toutes vos données) ?",
                              alternativeButtonConfirmText: "Se déconnecter") ??
                          false) {
                        await appSys.exitApp();
                        appSys.api = null;
                        appSys.buildControllers();
                        setState(() {});
                        Phoenix.rebirth(context);
                      }
                    },
                        padding: EdgeInsets.all(5),
                        backgroundColor: Colors.red,
                        icon: MdiIcons.logout,
                        iconColor: Colors.white,
                        label: "Déconnexion",
                        textColor: Colors.white),
                  ],
                ),
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
    );
  }

  ExpansionPanel buildAccountDetail(SchoolAccount account, int index) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ExpansionPanel(
        backgroundColor: Theme.of(context).primaryColorDark,
        isExpanded: (expanded[index] ?? false),
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
                    margin: EdgeInsets.only(left: 15),
                    padding: EdgeInsets.symmetric(horizontal: 10),
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
                            width: (appSys.account?.apiType == API_TYPE.EcoleDirecte ? 30 : 50),
                            height: (appSys.account?.apiType == API_TYPE.EcoleDirecte ? 30 : 20),
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
                    width: 15,
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

  buildApiIssues() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return FutureBuilder<List>(
        future: appSys.api!.apiStatus(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Card(
              color: (snapshot.data?[0] == 0) ? Color(0xffFEF08A) : Color(0xff99F6E4),
              child: Container(
                width: screenSize.size.width,
                padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Etat des serveurs", style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Asap")),
                    Text(snapshot.data?[1], style: TextStyle(fontFamily: "Asap")),
                  ],
                ),
              ),
            );
          } else {
            return Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
                width: screenSize.size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Etat des serveurs en cours de chargement...",
                        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Asap")),
                  ],
                ),
              ),
            );
          }
        });
  }

  buildMainAccountInfos() {
    return Column(
      children: [
        Wrap(
          spacing: 5,
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
  String errorLabel = "Tapez pour consulter les détails.";

  String apiIssues = "Il se peut que votre système scolaire rencontre des problèmes !";

  String errorExplanation =
      "Consultez l'erreur suivante. Reconnectez-vous maintenant ou dans quelques minutes. Si rien ne change, Contactez le support avec le bouton ci-dessous.";
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
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: screenSize.size.width / 5 * 0.1, vertical: screenSize.size.height / 10 * 0.1),
      child: (Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Que dois-je faire ?",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          Text(errorExplanation, textAlign: TextAlign.justify),
          Text(
            "Erreur retournée par l'application :",
            textAlign: TextAlign.justify,
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          Text(model.logs, textAlign: TextAlign.justify),
          SizedBox(
            height: screenSize.size.height / 10 * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtons.materialButton(context, screenSize.size.width / 5 * 1.7, screenSize.size.height / 10 * 0.4,
                  () {
                model.login();
              }, backgroundColor: Colors.orange, label: "Reconnexion", textColor: Colors.white),
              CustomButtons.materialButton(context, screenSize.size.width / 5 * 1.7, screenSize.size.height / 10 * 0.4,
                  () {
                //show wiredash
                Wiredash.of(context)!.show();
              }, backgroundColor: Colors.blue, label: "Support", textColor: Colors.white),
            ],
          ),
        ],
      )),
    );
  }

  buildExpandable() {}
  Widget buildIcon(LoginController _loginController) {
    return case2(
      _loginController.actualState,
      {
        loginStatus.loggedOff: SpinKitThreeBounce(
          size: 50,
          color: Colors.black38,
        ),
        loginStatus.offline: Icon(
          MdiIcons.networkStrengthOff,
          size: 50,
          color: Colors.black38,
        ),
        loginStatus.error: GestureDetector(
          child: Icon(
            MdiIcons.exclamation,
            size: 50,
            color: Colors.black38,
          ),
        ),
        loginStatus.loggedIn: Icon(
          MdiIcons.check,
          size: 50,
          color: Colors.black38,
        )
      },
      SpinKitThreeBounce(
        size: 40,
        color: Colors.black38,
      ),
    ) as Widget;
  }

  buildLoginStatus(LoginController model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          controller.toggle();
        });
      },
      child: Expandable(
        controller: controller,
        collapsed: buildTopCard(model, false),
        expanded: buildTopCard(model, true),
      ),
    );
  }

  buildTopCard(LoginController model, bool expanded) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Card(
      color: case2(model.actualState, {
        loginStatus.loggedIn: Color(0xff4ADE80),
        loginStatus.loggedOff: Color(0xffA8A29E),
        loginStatus.error: Color(0xffF87171),
        loginStatus.offline: Color(0xffFCD34D),
      }),
      child: Column(
        children: [
          Container(
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
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeUtils.darken(
                            case2(model.actualState, {
                              loginStatus.loggedIn: Color(0xff4ADE80),
                              loginStatus.loggedOff: Color(0xffA8A29E),
                              loginStatus.error: Color(0xffF87171),
                              loginStatus.offline: Color(0xffFCD34D),
                            }) as Color,
                            forceAmount: 0.15)),
                    child: FittedBox(child: buildIcon(model)),
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
          if (expanded && (model.actualState == loginStatus.error || model.actualState == loginStatus.loggedOff))
            buildErrorDetails(model)
        ],
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
