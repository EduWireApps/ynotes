import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/schoolLife/controller.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/columnGenerator.dart';

class SchoolLifePage extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;

  const SchoolLifePage({Key? key, required this.parentScaffoldState}) : super(key: key);
  @override
  _SchoolLifePageState createState() => _SchoolLifePageState();
}

class _SchoolLifePageState extends State<SchoolLifePage> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Vie scolaire",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: FlatButton(
            color: Colors.transparent,
            child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
            onPressed: () async {
              widget.parentScaffoldState.currentState?.openDrawer();
            },
          ),
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: RefreshIndicator(
        onRefresh: refreshTickets,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Container(
              height: screenSize.size.height,
              width: screenSize.size.width,
              child: ChangeNotifierProvider<SchoolLifeController>.value(
                  value: appSys.schoolLifeController,
                  child: Consumer<SchoolLifeController>(builder: (context, model, child) {
                    //if there is no tickets
                    if ((model.tickets ?? []).length == 0) {
                      return buildNoTickets();
                    } else {
                      return Container(
                        height: screenSize.size.height,
                        width: screenSize.size.width,
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.size.width / 5 * 0.1, horizontal: screenSize.size.width / 5 * 0.05),
                        child: ColumnBuilder(
                            itemCount: (model.tickets ?? []).length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildTicket(model.tickets![index]);
                            }),
                      );
                    }
                  }))),
        ),
      ),
    );
  }

  Widget buildCircle(SchoolLifeTicket ticket) {
    IconData? icon;
    if (ticket.type == "Absence") {
      icon = MdiIcons.alert;
    }
    if (ticket.type == "Retard") {
      icon = MdiIcons.clockAlertOutline;
    }
    if (ticket.type == "Repas") {
      icon = MdiIcons.foodOff;
    }

    var screenSize = MediaQuery.of(context);
    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColorDark),
        child: FittedBox(
            child: Icon(
          icon,
          color: ThemeUtils.textColor(),
        )),
        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.15),
        width: screenSize.size.width / 5 * 0.8,
        height: screenSize.size.width / 5 * 0.8,
        margin: EdgeInsets.all(10));
  }

  Widget buildNoTickets() {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ChangeNotifierProvider<SchoolLifeController>.value(
      value: appSys.schoolLifeController,
      child: Consumer<SchoolLifeController>(builder: (context, model, child) {
        return Center(
          child: Container(
            height: screenSize.size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  MdiIcons.stamper,
                  size: screenSize.size.width / 5 * 1.2,
                  color: ThemeUtils.textColor(),
                ),
                Text(
                  "Pas de données.",
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 20),
                ),
                FlatButton(
                  onPressed: () {
                    model.refresh(force: true);
                  },
                  child: model.loading
                      ? Text("Recharger",
                          style: TextStyle(
                              fontFamily: "Asap",
                              color: Colors.white,
                              fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                      : FittedBox(
                          child: SpinKitThreeBounce(
                              color: Theme.of(context).primaryColorDark, size: screenSize.size.width / 5 * 0.4)),
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(18.0),
                      side: BorderSide(color: Theme.of(context).primaryColorDark)),
                )
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildTicket(SchoolLifeTicket ticket) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        color: Theme.of(context).primaryColor,
        child: Row(
          children: [
            buildCircle(ticket),
            SizedBox(width: screenSize.size.width / 5 * 0.1),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, top: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ticket.libelle!,
                      style: TextStyle(
                          color: ThemeUtils.textColor(), fontFamily: "Asap", fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Motif : " + (ticket.motif ?? "(Sans motif)"),
                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      "Date : " + (ticket.displayDate ?? "(Sans date)"),
                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 15),
                      textAlign: TextAlign.left,
                    ),
                    RichText(
                        text: TextSpan(
                            style: TextStyle(
                                color: (ticket.isJustified ?? false) ? Colors.green : Colors.orange,
                                fontFamily: "Asap",
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                            children: [
                          TextSpan(
                            text: ticket.isJustified! ? "Justifié " : "A justifier ",
                          ),
                          WidgetSpan(
                              child: Icon((ticket.isJustified ?? false) ? MdiIcons.check : MdiIcons.exclamation,
                                  color: (ticket.isJustified ?? false) ? Colors.green : Colors.orange))
                        ])),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appSys.schoolLifeController.refresh();
    refreshTickets();
  }

  Future<void> refreshTickets() async {
    await appSys.schoolLifeController.refresh(force: true);
  }

  Widget separator(BuildContext context, String text) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      height: screenSize.size.height / 10 * 0.35,
      margin: EdgeInsets.only(
        top: screenSize.size.height / 10 * 0.1,
        left: screenSize.size.width / 5 * 0.25,
        bottom: screenSize.size.height / 10 * 0.1,
      ),
      child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Text(
          text,
          style:
              TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap", fontSize: 25, fontWeight: FontWeight.w600),
        ),
      ]),
    );
  }
}
