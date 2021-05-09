import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';

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
      color: Theme.of(context).primaryColor,
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: screenSize.size.width,
            child: Text(
              "Paramètres d'affichage",
              style: TextStyle(
                  fontFamily: "Asap", fontSize: 22, fontWeight: FontWeight.w500, color: ThemeUtils.textColor()),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
          buildForceTextColorSwitch(),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
          Container(
            width: screenSize.size.width,
            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
            child: Text(
              "Couleur de la page",
              style: TextStyle(
                  fontFamily: "Asap", fontSize: 19, fontWeight: FontWeight.w500, color: ThemeUtils.textColor()),
              textAlign: TextAlign.start,
            ),
          ),
          PageColorChoice(),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
          Container(
            width: screenSize.size.width,
            margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
            child: Text(
              "Police",
              style: TextStyle(
                  fontFamily: "Asap", fontSize: 19, fontWeight: FontWeight.w500, color: ThemeUtils.textColor()),
              textAlign: TextAlign.start,
            ),
          ),
          PageTextChoice(),
          Divider(
            color: ThemeUtils.textColor().withOpacity(0.1),
          ),
        ],
      ),
    );
  }

  buildForceTextColorSwitch() {
    var screenSize = MediaQuery.of(context);

    return /*CupertinoFormRow(
      child: CupertinoSwitch(
        value: appSys.settings!["user"]["homeworkPage"]["forceMonochromeContent"],
        onChanged: (value) {
          appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "forceMonochromeContent", value);
          setState(() {});
        },
      ),
      prefix: Text("Forcer le monochrome",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 17)),
      helper: Text(
        "Les textes des devoirs ne s'afficheront que dans la couleur primaire du thème choisi",
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 13),
      ),
    );*/
        SwitchListTile(
      value: appSys.settings!["user"]["homeworkPage"]["forceMonochromeContent"],
      title: Text("Forcer le monochrome",
          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 19)),
      subtitle: Text(
        "Les textes des devoirs ne s'afficheront que dans la couleur primaire du thème choisi",
        style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 12),
      ),
      onChanged: (value) async {
        appSys.updateSetting(appSys.settings!["user"]["homeworkPage"], "forceMonochromeContent", value);
        setState(() {});
      },
      secondary: Icon(
        MdiIcons.eye,
        color: ThemeUtils.textColor(),
      ),
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
          buildColorDot(true, ThemeUtils.textColor(revert: true)),
          buildColorDot(false, Theme.of(context).primaryColorDark),
          buildColorDot(false, Color(0xfff2e7bf)),
        ],
      ),
    );
  }

  buildColorDot(bool selected, Color color) {
    var screenSize = MediaQuery.of(context);
    return Container(
      width: screenSize.size.width / 5 * 0.6,
      height: screenSize.size.width / 5 * 0.6,
      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: selected ? Border.all(width: 2, color: Colors.blue) : Border.all(width: 2, color: Colors.grey)),
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
      margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  currentFont,
                  style: TextStyle(fontFamily: ".SF UI Text", fontSize: 25),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.05),
                child: Text(
                  "Changer",
                  style: TextStyle(fontFamily: "Asap", fontSize: 19, color: Colors.blueAccent),
                ),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  currentFont,
                  style: TextStyle(fontFamily: currentFont, fontSize: 25),
                ),
              ),
              Container(
                width: screenSize.size.width / 5 * 1.2,
                height: screenSize.size.height / 10 * 0.5,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), border: Border.all()),
                child: Row(
                  children: [
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        minusController.forward();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border(
                          right: BorderSide(),
                        )),
                        child: Center(
                          child: AnimatedBuilder(
                              animation: minusController,
                              builder: (context, child) {
                                return Transform.scale(scale: minusAnimation.value, child: Text("-"));
                              }),
                        ),
                      ),
                    )),
                    Expanded(
                        child: GestureDetector(
                      onTap: () {
                        plusController.forward();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(),
                          ),
                        ),
                        child: Center(
                          child: AnimatedBuilder(
                              animation: plusAnimation,
                              builder: (context, child) {
                                return Transform.scale(scale: plusAnimation.value, child: Text("+"));
                              }),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    plusController = AnimationController(value: 0.0, duration: Duration(milliseconds: 200), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          plusController.reverse();
        }
      });

    minusController = AnimationController(value: 0.0, duration: Duration(milliseconds: 200), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          minusController.reverse();
        }
      });

    minusAnimation = Tween(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: minusController, curve: Curves.easeInQuint));
    plusAnimation = Tween(
      begin: 1.0,
      end: 1.8,
    ).animate(CurvedAnimation(parent: plusController, curve: Curves.easeInQuint));
  }
}
