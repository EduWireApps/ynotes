import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:math';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:ynotes/land.dart';

int done = 50;

class SummaryPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _SummaryPageState();
  }
}

class _SummaryPageState extends State<SummaryPage> {
  PageController todoSettingsController;
  bool done2 = false;
  int _slider = 1;

  void initState() {
    todoSettingsController = new PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(
          top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 3),
      height: screenSize.size.height / 10 * 8.8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[


          //First division (gauge)

          Container(
            width: screenSize.size.width / 5 * 4.5,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 2,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 2.67,
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(0, 2.67),
                ),
              ],
                borderRadius: BorderRadius.circular(25),
                color: Color(0xff2C2C2C)),
            child: Stack(
              children: <Widget>[
                ClipRect(
                  child: Transform.translate(
                    offset: Offset(0, (screenSize.size.height / 10 * 8.8) / 15),
                    child: Transform.scale(
                      scale: screenSize.textScaleFactor*2.1,
                      child: Container(
                        padding: EdgeInsets.all(0),
                        //Gauge
                        child: charts.PieChart(_getDoneTasks(),

                            animate: false,
                            defaultRenderer: new charts.ArcRendererConfig(
                                arcWidth: (screenSize.size.width/70).round(),
                                startAngle: pi,
                                arcLength: pi,
                                strokeWidthPx: 1)),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      done.toString() + "%",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Asap",
                          color: Colors.white,
                          fontSize: screenSize.size.width / 11),
                    ),
                  ),
                ),
                Positioned(
                  bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2,
                  child: Container(
                    width: screenSize.size.width / 5 * 4.5,
                    child: Text(
                      'du travail fait !',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontFamily: "Asap"),
                    ),
                  ),
                ),
              ],
            ),
          ),

          //SecondDivision (homeworks)

          Container(
            margin: EdgeInsets.only(
                top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 3),
            width: screenSize.size.width / 5 * 4.5,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 4,
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 2.67,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2.67),
                  ),
                ],
                color: Color(0xff2C2C2C),
                borderRadius: BorderRadius.circular(25)),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(39)),
              child: PageView(
                controller: todoSettingsController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Stack(
                    children: <Widget>[
                      Positioned(
                        top: (screenSize.size.height / 10 * 8.8) / 95,
                        left: 20,
                        child: Container(
                          width: 30,
                          height: 30,
                          child: RawMaterialButton(
                            onPressed: () {
                              todoSettingsController.animateToPage(1,
                                  duration: Duration(milliseconds: 300),
                                  curve: Curves.ease);
                            },
                            child: new Icon(
                              Icons.settings,
                              color: Colors.white,
                              size: 25.0,
                            ),
                            shape: new CircleBorder(),
                            elevation: 1.0,
                            fillColor: Color(0xff141414),
                          ),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    0.1),
                            child: Text(
                              "A faire",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Asap",
                                  fontSize: 18,
                                  color: Colors.white),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.2,
                              top: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.2),
                          height: (screenSize.size.height / 10 * 8.8) / 10 * 3,
                          child: CupertinoScrollbar(
                            
                            child: AnimatedList(

                            initialItemCount: 5,
                            padding:
                            const EdgeInsets.only(left: 20.0, right: 20.0),
                            itemBuilder:(context, index, animation)  {
                            return HomeworkTicket(
                            "Maths", "DM sur les fonctions polynomes");

                            }
                            ),
                            ),
                            ),
                            ),
                            ],
                            ),
                            Stack(
                            children: <Widget>[
                            Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                            margin: EdgeInsets.only(

                                top: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    0.2),
                            child: AutoSizeText(
                              "Paramètres des devoirs rapides",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: "Asap",
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.2,
                              top: (screenSize.size.height / 10 * 8.8) /
                                  10 *
                                  0.2),
                          height: (screenSize.size.height / 10 * 8.8) / 10 * 3,
                          child: ListView(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 10),
                            children: <Widget>[
                              CupertinoSlider(

                                  value: _slider.toDouble(),
                                  min: 1.0,
                                  max: 10.0,
                                  divisions: 10,
                                  onChanged: (double newValue) {
                                    setState(() {
                                      _slider = newValue.round();
                                    });
                                  }),
                              Container(
                                margin: EdgeInsets.only( top: (screenSize.size.height / 10 * 8.8) /
                                    10 *
                                    0.2),
                                child: AutoSizeText(
                                  "Devoirs sur :\n"+ _slider.toString() + " jour" + (_slider > 1 ?  "s" : "") , textAlign: TextAlign.center, style: TextStyle(fontFamily: "Asap", fontSize: 15, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: EdgeInsets.only(bottom: screenSize.size.width / 5 * 0.2),
                          height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
                          width: screenSize.size.width / 5 * 2,
                          child: RaisedButton(

                            color: Color(0xff5DADE2),
                            shape: StadiumBorder(),
                            onPressed: () {
                              todoSettingsController.animateToPage(0,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.ease);

                            },
                            child: Text(
                              "Ok",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18, fontFamily: "Asap"),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),

          //Third division (quick marks)
          Container(
            margin: EdgeInsets.only(
                top: (screenSize.size.height / 10 * 8.8) / 10 * 1 / 3),
            width: screenSize.size.width / 5 * 4.5,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 2,
            decoration: BoxDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    blurRadius: 2.67,
                    color: Colors.black.withOpacity(0.2),
                    offset: Offset(0, 2.67),
                  ),
                ],
                borderRadius: BorderRadius.circular(25),
                color: Color(0xff2C2C2C)),
            child: Stack(
              children: <Widget>[],
            ),
          ),
        ],
      ),
    );
  }

  List<charts.Series<GaugeSegment, String>> _getDoneTasks() {
    final data = [
      new GaugeSegment('Done', done, Color(0xffA6F38B)),
      new GaugeSegment('NotDone', 100 - done, Color(0xffDC6A46)),
    ];

    return [
      new charts.Series<GaugeSegment, String>(
        id: 'ToDoGauge',
        domainFn: (GaugeSegment segment, _) => segment.segment,
        measureFn: (GaugeSegment segment, _) => segment.size,
        colorFn: (GaugeSegment segment, __) =>
            charts.ColorUtil.fromDartColor(segment.color),
        strokeWidthPxFn: (GaugeSegment segment, _) => 0.0,

        data: data,
      ),
    ];
  }
}

//The basic ticket for homeworks with the discipline and the description and a checkbox
class HomeworkTicket extends StatefulWidget {
  final String discipline;
  final String description;

  const HomeworkTicket(this.discipline, this.description);
  State<StatefulWidget> createState() {
    return _HomeworkTicketState();
  }
}

class _HomeworkTicketState extends State<HomeworkTicket> {
  bool done = false;
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(
          bottom: (screenSize.size.height / 10 * 8.8) / 10 * 0.2),
      child: Material(
        color: Color(0xff727CB4),
        borderRadius: BorderRadius.circular(39),
        child: InkWell(
          borderRadius: BorderRadius.circular(39),
          onTap: () {},
          child: Container(
            width: screenSize.size.width / 5 * 4,
            height: (screenSize.size.height / 10 * 8.8) / 10 * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(39),

              //TO DO :  SEARCH IN DISCIPLINES DATABASE
            ),
            child: Row(
              children: <Widget>[
                CircularCheckBox(
                  activeColor: Colors.blue,
                  inactiveColor: Colors.white,
                  value: done,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  onChanged: (bool x) {
                    setState(() {
                      done = !done;
                    });
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(widget.discipline,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Asap",
                            fontWeight: FontWeight.bold)),
                    Text(
                      widget.description,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 15, fontFamily: "Asap"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Sample data type.
class GaugeSegment {
  final String segment;
  final int size;
  final Color color;

  GaugeSegment(this.segment, this.size, this.color);
}
