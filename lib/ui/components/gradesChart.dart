import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

final Color darkBlue = Color.fromARGB(255, 18, 32, 47);

//Lowest, avg, highest, personal
List val = [8, 12, 13.8, 18];
int outOf = 20;

class GradesChart extends StatelessWidget {
  const GradesChart({
    Key key,
    @required this.barLength,
    @required this.screenSize,
    @required this.height,
  }) : super(key: key);

  final double barLength;
  final double height;
  final MediaQueryData screenSize;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.black),
      ),
      width: screenSize.size.width,
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              height: screenSize.size.height / 5 * 0.02,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(50)),
              width: barLength,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Center(
              child: Container(
                width: barLength + screenSize.size.width / 5 * 0.3,
                margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.9),
                child: Stack(
                  children: [
                    if (val[0] != val[3]) Container(margin: EdgeInsets.only(left: getMargin(val[0], barLength)), child: Point(Colors.red, Icons.arrow_downward, 0, true)),
                    Container(margin: EdgeInsets.only(left: getMargin(val[1], barLength)), child: Point(Colors.grey, null, 1, true)),
                    if (val[2] != val[3]) Container(margin: EdgeInsets.only(left: getMargin(val[2], barLength)), child: Point(Colors.green, MdiIcons.arrowUpThick, 2, true)),
                    Container(margin: EdgeInsets.only(left: getMargin(val[3], barLength)), child: Point(Colors.blue, Icons.person, 3, false)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

//Add height for the avg value if it touches other
getHeight(var listValues, index, var screenSize, var lineSize, var gradeContainerWidth) {
  if (index != 1) {
    return screenSize.size.height / 10 * 0.4;
  }
  try {
    List localListValues = List();
    for (int i = 0; i < listValues.length; i++) {
      //Exclude the userGrade (which isn't below) and self value
      if (i != 3 && i != index) {
        localListValues.add(listValues[i]);
      }
    }

    print(localListValues);
    var smallerNearest = localListValues.where((e) => e < listValues[index]).toList()..sort();
    var higherNearest = localListValues.where((e) => e > listValues[index]).toList()..sort();

    //Add height if overlapping with another grade container)
    if ((getMargin(listValues[index], lineSize) - getMargin(smallerNearest.last, lineSize)) < gradeContainerWidth / 2 || (getMargin(higherNearest.first, lineSize) - getMargin(listValues[index], lineSize)) < gradeContainerWidth / 2) {
      return screenSize.size.height / 10 * 0.4 + screenSize.size.height / 10 * 0.55;
    } else {
      return screenSize.size.height / 10 * 0.4;
    }
  } catch (e) {
    print(e);
    print(listValues[index]);
    return screenSize.size.height / 10 * 0.4;
  }
}

//Get the left margin for any point
getMargin(var value, var lineSize) {
  double margin = (lineSize / outOf * value);

  return margin;
}

class Point extends StatefulWidget {
  final Color color;
  final IconData icon;
  final int index;
  final bool isGradeBelow;

  State<StatefulWidget> createState() {
    return _PointState();
  }

  Point(this.color, this.icon, this.index, this.isGradeBelow);
}

class _PointState extends State<Point> {
  Widget buildBubble() {
    var screenSize = MediaQuery.of(context);
    return Column(
      children: [
        if (this.widget.isGradeBelow) Container(color: this.widget.color, height: getHeight(val, this.widget.index, screenSize, screenSize.size.width * 0.25, screenSize.size.width / 5 * 0.8), width: screenSize.size.width / 5 * 0.01),
        Container(
            child: Center(child: FittedBox(child: Text(val[this.widget.index].toString()))),
            width: screenSize.size.width / 5 * 0.8,
            height: screenSize.size.height / 10 * 0.4,
            decoration: BoxDecoration(border: Border.all(width: 2, color: this.widget.color), color: this.widget.color, borderRadius: BorderRadius.circular(15))),
        if (!this.widget.isGradeBelow) Container(color: this.widget.color, height: screenSize.size.height / 10 * 0.4, width: screenSize.size.width / 5 * 0.01),
      ],
    );
  }

  Widget build(BuildContext context) {
    getBorderColor(int index) {
      if (index == 3) {
        if (val[0] == val[3]) {
          return Colors.red;
        }
        if (val[2] == val[3]) {
          return Colors.green;
        } else {
          return this.widget.color;
        }
      } else {
        return this.widget.color;
      }
    }

    var screenSize = MediaQuery.of(context);
    return Transform.translate(
      offset: Offset(0, (this.widget.isGradeBelow ? (getHeight(val, this.widget.index, screenSize, screenSize.size.width * 0.25, screenSize.size.width / 5 * 0.3) - screenSize.size.height / 10 * 0.5) * 0.5 : -(screenSize.size.height / 10 * 0.85))),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!this.widget.isGradeBelow) buildBubble(),
            Container(
                width: screenSize.size.width / 5 * 0.35,
                height: screenSize.size.width / 5 * 0.35,
                decoration: BoxDecoration(color: getBorderColor(this.widget.index), borderRadius: BorderRadius.circular(50)),
                child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[Center(child: FittedBox(child: Icon(this.widget.icon)))])),
            if (this.widget.isGradeBelow) buildBubble(),
          ],
        ),
      ),
    );
  }
}
