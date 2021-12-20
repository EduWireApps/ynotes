import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';

class HomeworkReaderOptionsBottomSheet extends StatefulWidget {
  const HomeworkReaderOptionsBottomSheet({Key? key}) : super(key: key);

  @override
  _HomeworkReaderOptionsBottomSheetState createState() => _HomeworkReaderOptionsBottomSheetState();
}

class PageColorChoice extends StatefulWidget {
  const PageColorChoice({Key? key}) : super(key: key);

  @override
  _PageColorChoiceState createState() => _PageColorChoiceState();
}

class PageTextChoice extends StatefulWidget {
  const PageTextChoice({Key? key}) : super(key: key);

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
          const Center(child: DragHandle()),
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
          const PageColorChoice(),
          SizedBox(
            height: screenSize.size.height / 10 * 0.2,
          ),
          const PageTextChoice(),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(MdiIcons.eye, color: ThemeUtils.textColor()),
            SizedBox(
              width: screenSize.size.width / 5 * 0.1,
            ),
            Expanded(
                child: Text("Forcer le monochrome",
                    style: TextStyle(
                        fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 14, fontWeight: FontWeight.bold))),
            Switch(
              value: (appSys.settings.user.homeworkPage.forceMonochromeContent),
              onChanged: (value) async {
                appSys.settings.user.homeworkPage.forceMonochromeContent = value;
                appSys.saveSettings();
                setState(() {});
              },
            )
          ],
        ),
        Text("Les textes des devoirs ne s’afficheront que dans la couleur primaire du thème choisi",
            textAlign: TextAlign.start,
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
              child: Text("Couleur de la page",
                  style: TextStyle(
                      fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 14, fontWeight: FontWeight.bold))),
          buildColorDot(0, Theme.of(context).primaryColorDark),
          buildColorDot(1, ThemeUtils.textColor(revert: true)),
          if (!ThemeUtils.isThemeDark) buildColorDot(2, const Color(0xfff2e7bf)),
        ],
      ),
    );
  }

  buildColorDot(int index, Color color) {
    var screenSize = MediaQuery.of(context);
    return GestureDetector(
      onTap: () {
        appSys.settings.user.homeworkPage.pageColorVariant = index;
        appSys.saveSettings();
        setState(() {});
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        width: 50,
        height: 50,
        margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.05),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: (appSys.settings.user.homeworkPage.pageColorVariant) == index
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
    return Row(
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
            child: Text("Taille du texte",
                style: TextStyle(
                    fontFamily: "Asap", color: ThemeUtils.textColor(), fontSize: 14, fontWeight: FontWeight.bold))),
        Text(
          (appSys.settings.user.homeworkPage.fontSize).toString(),
          style: TextStyle(
              fontFamily: currentFont,
              fontSize: (appSys.settings.user.homeworkPage.fontSize).toDouble(),
              color: ThemeUtils.textColor()),
        ),
        SizedBox(
          width: screenSize.size.width / 5 * 0.2,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Container(
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
                    if ((appSys.settings.user.homeworkPage.fontSize) > 11) {
                      appSys.settings.user.homeworkPage.fontSize = (appSys.settings.user.homeworkPage.fontSize - 1);
                    }
                    appSys.saveSettings();
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
                    if ((appSys.settings.user.homeworkPage.fontSize) < 35) {
                      appSys.settings.user.homeworkPage.fontSize = (appSys.settings.user.homeworkPage.fontSize + 1);
                    }
                    appSys.saveSettings();

                    setState(() {});
                  },
                  child: Container(
                    decoration: const BoxDecoration(),
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
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    plusController = AnimationController(value: 0.0, duration: const Duration(milliseconds: 120), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          plusController.reverse();
        }
      });

    minusController = AnimationController(value: 0.0, duration: const Duration(milliseconds: 120), vsync: this)
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
