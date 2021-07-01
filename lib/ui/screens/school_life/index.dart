import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/column_generator.dart';
import 'package:ynotes/ui/components/y_page/y_page.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';

class SchoolLifePage extends StatefulWidget {
  const SchoolLifePage({Key? key}) : super(key: key);
  @override
  _SchoolLifePageState createState() => _SchoolLifePageState();
}

class _SchoolLifePageState extends State<SchoolLifePage> with LayoutMixin {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return YPage(
        title: "Vie scolaire",
        isScrollable: false,
        body: RefreshIndicator(
          onRefresh: refreshTickets,
          child: Container(
              width: screenSize.size.width,
              child: ChangeNotifierProvider<SchoolLifeController>.value(
                  value: appSys.schoolLifeController,
                  child: Consumer<SchoolLifeController>(builder: (context, model, child) {
                    //if there is no tickets
                    if ((model.tickets ?? []).length == 0 || model.tickets == null) {
                      return buildNoTickets();
                    } else {
                      return Container(
                        height: screenSize.size.height,
                        width: screenSize.size.width,
                        padding: EdgeInsets.symmetric(
                            vertical: screenSize.size.width / 5 * 0.1, horizontal: screenSize.size.width / 5 * 0.05),
                        child: SingleChildScrollView(
                          child: ColumnBuilder(
                              itemCount: (model.tickets)!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return buildTicket((model.tickets)!.reversed.toList()[index]);
                              }),
                        ),
                      );
                    }
                  }))),
        ));
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

    return Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).primaryColorDark),
        child: FittedBox(
            child: Icon(
          icon,
          color: ThemeUtils.textColor(),
        )),
        padding: EdgeInsets.all(15),
        width: 90,
        height: 90,
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
                  size: screenSize.size.height / 10 * 2.5,
                  color: ThemeUtils.textColor(),
                ),
                Text(
                  "Pas de données.",
                  style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 20),
                ),
                Container(
                  width: 90,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: ThemeUtils.textColor())),
                    ),
                    onPressed: () {
                      model.refresh(force: true);
                    },
                    child: !model.loading
                        ? Text("Recharger",
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor(),
                                fontSize: (screenSize.size.height / 10 * 8.8) / 10 * 0.2))
                        : FittedBox(
                            child: SpinKitThreeBounce(
                                color: ThemeUtils.textColor(), size: screenSize.size.width / 5 * 0.4)),
                  ),
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
