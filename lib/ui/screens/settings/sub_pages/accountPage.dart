import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/model.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          margin: EdgeInsets.symmetric(
              horizontal: screenSize.size.width / 5 * 0.05, vertical: screenSize.size.height / 10 * 0.08),
          height: screenSize.size.height,
          width: screenSize.size.width,
          child: Column(
            children: [
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
              Expanded(child: SizedBox()),
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
          )),
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
                      context, screenSize.size.width / 5 * 1.7, screenSize.size.height / 10 * 0.4, () {},
                      backgroundColor: Colors.blue, label: "Se connecter"),
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
