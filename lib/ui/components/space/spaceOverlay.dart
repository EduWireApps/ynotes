import 'package:flutter/material.dart';

Map spaceCoolSentences = {
  "gradesImprovement": [
    "Envie de voir l'évolution de vos notes ?",
    "Les statistiques d'évolution de vos notes sont disponibles.",
    "Voulez-vous voir si vos notes se portent bien ?"
  ],
  "doneHomeworkStatistics": [
    "Voir vos statistiques de travail.",
    "Envie de savoir si vous travaillez régulièrement ?",
    "J'ai calculé vos statistiques de travail !"
  ],
};

///Build a Stack with space overlay
///Widget have to be used passing a `child` which can't be null.
class SpaceOverlay extends StatefulWidget {
  final child;

  const SpaceOverlay({Key? key, required this.child}) : super(key: key);
  @override
  _SpaceOverlayState createState() => _SpaceOverlayState();
}

Offset i = Offset(0, 0);

class _SpaceOverlayState extends State<SpaceOverlay>
    with TickerProviderStateMixin {
  GlobalKey spaceKey = GlobalKey();
  bool deployed = false;
  Animation<double>? showAnimation;
  late AnimationController showAnimationController;
  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    showAnimationController =
        AnimationController(duration: Duration(milliseconds: 350), vsync: this);
    showAnimation = Tween<double>(begin: 1, end: 15).animate(CurvedAnimation(
        parent: showAnimationController, curve: Curves.easeInCubic));

    return Stack(children: [
      buildChild(),
      Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: getWidgetHeight(),
          width: getWidgetWidth(),
          child: ClipRRect(
            child: Container(
              child: Stack(
                children: [
                  Align(
                      alignment: Alignment.bottomLeft,
                      child: Container(child: buildBlurAndSpaceLabel())),
                ],
              ),
              height: getWidgetHeight(),
              width: getWidgetWidth(),
            ),
          ),
        ),
      )
    ]);
  }

  expandAnimation() {}
  buildChild() {
    return Center(
      child: Container(
        key: spaceKey,
        child: widget.child,
      ),
    );
  }

  getWidgetHeight() {
    final keyContext = spaceKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      return box.size.height;
    } else {
      return 0.0;
    }
  }

  getWidgetWidth() {
    final keyContext = spaceKey.currentContext;
    if (keyContext != null) {
      final box = keyContext.findRenderObject() as RenderBox;
      return box.size.width;
    } else {
      return 0.0;
    }
  }

  buildBlurAndSpaceLabel() {
    return Container(
      height: getWidgetHeight(),
      width: getWidgetWidth(),
      color: Colors.black.withOpacity(0.2),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: getWidgetHeight() / 5 * 0.8,
              height: getWidgetHeight() / 5 * 0.8,
              child: buildExpandingCircle(),
            ),
          )
        ],
      ),
    );
  }

  buildExpandingCircle() {
    return Material(
      borderRadius: BorderRadius.only(topRight: Radius.circular(1000)),
      color: Colors.blue,
      child: InkWell(
        onTap: () {
          showAnimationController.forward();
        },
        borderRadius: BorderRadius.only(topRight: Radius.circular(1000)),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(topRight: Radius.circular(1000)),
          ),
        ),
      ),
    );
  }
}
