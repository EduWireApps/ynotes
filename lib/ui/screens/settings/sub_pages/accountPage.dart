import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';
import 'package:ynotes/ui/components/modalBottomSheets/keyValues.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool isExpanded = false;
  ExpansionPanel buildAccountDetail() {
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
                        Container(
                            child: Icon(
                          Icons.power,
                          color: ThemeUtils.textColor(),
                        )),
                        Container(
                          child: Image(
                            width: MediaQuery.of(context).size.width / 5 * 0.3,
                            height: MediaQuery.of(context).size.width / 5 * 0.2,
                            fit: BoxFit.fill,
                            image: AssetImage('assets/images/EcoleDirecte/EcoleDirecteIcon.png'),
                            color: ThemeUtils.textColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 5 * 0.3,
                  ),
                  Text(
                    "Compte 1",
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
              buildKeyValuesInfo(context, "Nom du compte", ["Test"]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              buildKeyValuesInfo(context, "Classe", ["6eB"]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              buildKeyValuesInfo(context, "Est un compte supervisé par un parent", ["Oui"]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              buildKeyValuesInfo(context, "Nom du compte", ["Paparazi"]),
              SizedBox(
                height: screenSize.size.height / 10 * 0.3,
              ),
              Center(
                child: CustomButtons.materialButton(
                    context, screenSize.size.width / 5 * 1.7, screenSize.size.height / 10 * 0.4, () {},
                    backgroundColor: Colors.blue, label: "Se connecter"),
              )
            ],
          ),
        ));
  }

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
              Container(
                height: screenSize.size.height / 10 * 8,
                child: SingleChildScrollView(
                  child: ExpansionPanelList(
                      expandedHeaderPadding: EdgeInsets.zero,
                      expansionCallback: (index, newVal) {
                        setState(() {
                          isExpanded = !newVal;
                        });
                      },
                      children: (appSys.accounts.map((e) => buildAccountDetail()).toList())),
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
                      shadows: [Shadow(color: Colors.white, offset: Offset(0, -5))],
                      fontSize: 14,
                      decorationColor: Colors.white,
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
}
