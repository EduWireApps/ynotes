import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/modalBottomSheets/dragHandle.dart';

class HomeworkReaderOptionsBottomSheet extends StatefulWidget {
  @override
  _HomeworkReaderOptionsBottomSheetState createState() => _HomeworkReaderOptionsBottomSheetState();
}

class PageColorChoice extends StatefulWidget {
  @override
  _PageColorChoiceState createState() => _PageColorChoiceState();
}

class PageTextChoice extends StatefulWidget {
  @override
  _PageTextChoiceState createState() => _PageTextChoiceState();
}

class _HomeworkReaderOptionsBottomSheetState extends State<HomeworkReaderOptionsBottomSheet>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(
          vertical: screenSize.size.height / 10 * 0.2, horizontal: screenSize.size.width / 5 * 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: DragHandle()),
          SizedBox(
            height: screenSize.size.height / 10 * 0.15,
          ),
          SizedBox(
            width: screenSize.size.width,
            child: Text(
              "Paramètres d'affichage",
              style: TextStyle(
                  fontFamily: "Asap", fontSize: 22, fontWeight: FontWeight.w600, color: ThemeUtils.textColor()),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.15,
          ),
          buildForceTextColorSwitch(),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          PageColorChoice(),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          PageTextChoice(),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
        ],
      ),
    );
  }

  buildForceTextColorSwitch() {
    var screenSize = MediaQuery.of(context);
    return Column(
      children: [
        Row(
          children: [
            Icon(MdiIcons.eye, color: ThemeUtils.textColor()),
            SizedBox(
              width: screenSize.size.width / 5 * 0.1,
            ),
            Expanded(
                child: Container(
                    child: Text("Forcer le monochrome",
                        style: TextStyle(
                            fontFamily: "Asap",
                            color: ThemeUtils.textColor(),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)))),
            Switch(
              value: appSys.settings!["user"]["homeworkPage"]["forceMonochromeContent"],
              onChanged: (value) async {
                appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "forceMonochromeContent", value);
                setState(() {});
              },
            )
          ],
        ),
        Text("Les textes des devoirs ne s’afficheront que dans la couleur primaire du thème choisi",
            style: TextStyle(
                fontFamily: "Asap",
                color: ThemeUtils.textColor().withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w400))
      ],
    );
  }
}

class _PageColorChoiceState extends State<PageColorChoice> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(MdiIcons.palette, color: ThemeUtils.textColor()),
          SizedBox(
            width: screenSize.size.width / 5 * 0.1,
          ),
          Expanded(
              child: Container(
                  child: Text("Couleur de la page",
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold)))),
          buildColorDot(0, Theme.of(context).primaryColorDark),
          buildColorDot(1, ThemeUtils.textColor(revert: true)),
          if (!ThemeUtils.isThemeDark) buildColorDot(2, Color(0xfff2e7bf)),
        ],
      ),
    );
  }

  buildColorDot(int index, Color color) {
    var screenSize = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "pageColorVariant", index);
        setState(() {});
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        width: screenSize.size.width / 5 * 0.6,
        height: screenSize.size.width / 5 * 0.6,
        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: (appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] ?? 0) == index
                ? Border.all(width: 2, color: Colors.blue)
                : Border.all(width: 2, color: Colors.grey)),
      ),
    );
  }
}

class _PageTextChoiceState extends State<PageTextChoice> with TickerProviderStateMixin {
  late AnimationController plusController;
  late AnimationController minusController;
  late Animation<double> plusAnimation;
  late Animation<double> minusAnimation;

  List<String> availableFonts = ["Asap", "Roboto", "SF Pro Display"];

  String currentFont = "Asap";
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            MdiIcons.formatSize,
            color: ThemeUtils.textColor(),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.1,
          ),
          Expanded(
              child: Container(
                  child: Text("Taille du texte",
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: ThemeUtils.textColor(),
                          fontSize: 14,
                          fontWeight: FontWeight.bold)))),
          Text(
            appSys.settings!["user"]["homeworkPage"]["fontSize"].toString(),
            style: TextStyle(
                fontFamily: currentFont,
                fontSize: (appSys.settings!["user"]["homeworkPage"]["fontSize"] ?? 20).toDouble(),
                color: ThemeUtils.textColor()),
          ),
          SizedBox(
            width: screenSize.size.width / 5 * 0.2,
          ),
          Container(
            width: screenSize.size.width / 5 * 1.2,
            height: screenSize.size.height / 10 * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Theme.of(context).primaryColorDark,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    minusController.forward();
                    if (appSys.settings!["user"]["homeworkPage"]["fontSize"] > 11)
                      appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "fontSize",
                          appSys.settings!["user"]["homeworkPage"]["fontSize"] - 1);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                      right: BorderSide(color: ThemeUtils.textColor().withOpacity(0.2)),
                    )),
                    child: Center(
                      child: AnimatedBuilder(
                          animation: minusController,
                          builder: (context, child) {
                            return Transform.scale(
                                scale: minusAnimation.value,
                                child: Text(
                                  "-",
                                  style: TextStyle(color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
                                ));
                          }),
                    ),
                  ),
                )),
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    plusController.forward();
                    if (appSys.settings!["user"]["homeworkPage"]["fontSize"] < 35)
                      appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "fontSize",
                          appSys.settings!["user"]["homeworkPage"]["fontSize"] + 1);
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Center(
                      child: AnimatedBuilder(
                          animation: plusAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                                scale: plusAnimation.value,
                                child: Text("+",
                                    style: TextStyle(color: ThemeUtils.textColor(), fontWeight: FontWeight.bold)));
                          }),
                    ),
                  ),
                )),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    plusController = AnimationController(value: 0.0, duration: Duration(milliseconds: 120), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          plusController.reverse();
        }
      });

    minusController = AnimationController(value: 0.0, duration: Duration(milliseconds: 120), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          minusController.reverse();
        }
      });

    minusAnimation = Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: minusController, curve: Curves.easeInBack));
    plusAnimation = Tween(
      begin: 1.0,
      end: 2.0,
    ).animate(CurvedAnimation(parent: plusController, curve: Curves.easeInBack));
  }
}
