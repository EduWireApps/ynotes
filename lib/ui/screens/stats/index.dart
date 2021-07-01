import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'widgets/leading_icon.dart';

class StatsPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> parentScaffoldState;

  const StatsPage({Key? key, required this.parentScaffoldState}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with LayoutMixin {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Scaffold(
      appBar: new AppBar(
          title: new Text(
            "Statistiques",
            style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
          ),
          leading: !isVeryLargeScreen
              ? TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent)),
                  child: Icon(MdiIcons.menu, color: ThemeUtils.textColor()),
                  onPressed: () async {
                    widget.parentScaffoldState.currentState?.openDrawer();
                  },
                )
              : null,
          backgroundColor: Theme.of(context).primaryColor),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        color: Theme.of(context).primaryColor,
        height: screenSize.size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Container(
              width: screenSize.size.width / 5 * 4.8,
              height: screenSize.size.height / 10 * 3,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(11),
                child: PlasmaRenderer(
                  particles: 5,
                  color: Color(0x8a2513ef),
                  size: 1.67,
                  speed: 10,
                  offset: 0.00,
                  blendMode: BlendMode.screen,
                  child: Container(
                    width: screenSize.size.width / 5 * 4.8,
                    child: Column(
                      children: [
                        Text(
                          "Statistiques globales",
                          style: TextStyle(fontFamily: "Asap", color: Colors.white, fontSize: 18),
                        ),
                        Divider(
                          color: ThemeUtils.textColor(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("45650",
                                style: TextStyle(
                                    fontFamily: "Asap",
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 29)),
                            SizedBox(
                              width: screenSize.size.width / 5 * 0.05,
                            ),
                            Tooltip(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(11), color: Theme.of(context).primaryColorLight),
                              margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.7),
                              message: "Votre score global calculé à partir d'une formule secrète",
                              child: Icon(
                                MdiIcons.information,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.center,
                          runSpacing: screenSize.size.height / 10 * 0.1,
                          spacing: screenSize.size.width / 5 * 0.2,
                          children: [
                            LeadingAndSubtitle(
                              leading: Text(
                                "14.5",
                                style: TextStyle(
                                    fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              color: Colors.white,
                              subtitle: "de moyenne générale",
                            ),
                            LeadingAndSubtitle(
                              leading: Text(
                                "14",
                                style: TextStyle(
                                    fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              color: Colors.white,
                              subtitle: "devoirs effectués",
                            ),
                            LeadingAndSubtitle(
                              leading: Text(
                                "14.5",
                                style: TextStyle(
                                    fontFamily: "Asap", color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                              ),
                              color: Colors.white,
                              subtitle: "de moyenne générale",
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Container(
              width: screenSize.size.width / 5 * 4.8,
              child: ExpandablePanel(
                header: Container(
                  width: screenSize.size.width / 5 * 4.8,
                  height: screenSize.size.height / 10 * 0.8,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.rectangle,
                    borderRadius: new BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Notes",
                        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 18),
                      ),
                    ],
                  ),
                ),
                collapsed: Container(
                    width: screenSize.size.width / 5 * 4.8,
                    height: screenSize.size.height / 10 * 0.1,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      shape: BoxShape.rectangle,
                      borderRadius:
                          new BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                      boxShadow: <BoxShadow>[
                        new BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.0,
                          offset: new Offset(0.0, 10.0),
                        ),
                      ],
                    )),
                expanded: Container(
                  width: screenSize.size.width / 5 * 4.8,
                  height: screenSize.size.height / 10 * 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColorLight,
                    shape: BoxShape.rectangle,
                    borderRadius:
                        new BorderRadius.only(bottomRight: Radius.circular(8), bottomLeft: Radius.circular(8)),
                    boxShadow: <BoxShadow>[
                      new BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10.0,
                        offset: new Offset(0.0, 10.0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Divider(
                        color: ThemeUtils.textColor(),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        alignment: WrapAlignment.center,
                        runSpacing: screenSize.size.height / 10 * 0.1,
                        spacing: screenSize.size.width / 5 * 0.2,
                        children: [
                          LeadingAndSubtitle(
                            leading: Text(
                              "14.5",
                              style: TextStyle(
                                  fontFamily: "Asap",
                                  color: ThemeUtils.textColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            subtitle: "est votre meilleure note",
                          ),
                          LeadingAndSubtitle(
                            leading: Text(
                              "14",
                              style: TextStyle(
                                  fontFamily: "Asap",
                                  color: ThemeUtils.textColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            subtitle: "est votre note la plus basse",
                          ),
                          LeadingAndSubtitle(
                            leading: Text(
                              "14.5",
                              style: TextStyle(
                                  fontFamily: "Asap",
                                  color: ThemeUtils.textColor(),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18),
                            ),
                            subtitle: "de moyenne générale",
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
