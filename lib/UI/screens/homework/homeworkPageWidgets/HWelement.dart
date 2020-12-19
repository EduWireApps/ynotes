import 'dart:math';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/homework/homeworkPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPage.dart';
import 'package:ynotes/UI/screens/summary/summaryPageWidgets/quickHomework.dart';
import 'package:ynotes/apis/utils.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models.dart';
import 'package:ynotes/models/homework/utils.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/fileUtils.dart';
import 'package:ynotes/utils/themeUtils.dart';

//Represents the element containing details about homework
class HomeworkElement extends StatefulWidget {
  final Homework homeworkForThisDay;
  final bool initialExpansion;
  HomeworkElement(this.homeworkForThisDay, this.initialExpansion);

  @override
  _HomeworkElementState createState() => _HomeworkElementState();
}

class _HomeworkElementState extends State<HomeworkElement> with TickerProviderStateMixin {
  ///Label to show on the left (I.E : "Tomorrow")
  String mainLabel = "";

  /// Show a small label if the main label doesn't show a date
  bool showSmallLabel = true;

  bool isExpanded = false;

  ///Expand document part or not
  bool isDocumentExpanded = false;

  //The index of the segmented control (travail à faire / contenu de cours)
  int segmentedControlIndex = 0;

  AnimationController _rotationController;
  Animation<double> _rotationAnimation;
  @override
  void initState() {
    super.initState();
    //Define the default expanding state
    getDefaultValue();
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _rotationAnimation = new Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.ease,
    ));
  }

  void getDefaultValue() async {
    var defaultValue = await getSetting("isExpandedByDefault");

    setState(() {
      isExpanded = defaultValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    ///Expand the element or not

    MediaQueryData screenSize = MediaQuery.of(context);
    var _zoom = 0.0;

    return Container(
      margin: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: FutureBuilder(
          future: getColor(this.widget.homeworkForThisDay.codeMatiere ?? ""),
          initialData: 0,
          builder: (context, snapshot) {
            Color color = Color(snapshot.data);

            return Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                      margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.5),
                      width: screenSize.size.width / 5 * 4.5,
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: Colors.transparent),
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                            bottomRight: Radius.circular(15)),
                      ),
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.only(bottomLeft: Radius.circular(11), bottomRight: Radius.circular(11)),
                        child: Column(
                          children: <Widget>[
                            if (this.widget.homeworkForThisDay.interrogation == true &&
                                isExpanded &&
                                this.widget.homeworkForThisDay.loaded)
                              Container(
                                margin: EdgeInsets.only(top: screenSize.size.width / 10 * 0.15),
                                padding: EdgeInsets.all(screenSize.size.width / 10 * 0.01),
                                width: screenSize.size.width / 5 * 4.5,
                                height: screenSize.size.width / 10 * 0.6,
                                decoration: BoxDecoration(
                                    color: Colors.orangeAccent,
                                    border: Border.all(
                                      width: 0,
                                      color: Colors.transparent,
                                    )),
                                child: FittedBox(
                                  child: Text(
                                    "Interrogation",
                                    style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            if (this.widget.homeworkForThisDay.loaded)
                              Container(
                                color: isDarkModeEnabled
                                    ? darken(Theme.of(context).primaryColorDark, forceAmount: 0.1)
                                    : darken(Theme.of(context).primaryColor, forceAmount: 0.03),
                                width: screenSize.size.width / 5 * 4.5,
                                height: isExpanded ? null : 0,
                                child: Container(
                                  decoration: BoxDecoration(border: Border.all(width: 0, color: Colors.transparent)),
                                  padding: isExpanded
                                      ? EdgeInsets.only(
                                          left: screenSize.size.height / 10 * 0.1,
                                          top: screenSize.size.height / 10 * 0.1,
                                          right: screenSize.size.height / 10 * 0.1)
                                      : null,
                                  child: Column(
                                    children: <Widget>[
                                      if ((widget.homeworkForThisDay.contenuDeSeance != null &&
                                              widget.homeworkForThisDay.contenuDeSeance != "") ||
                                          (widget.homeworkForThisDay.documentsContenuDeSeance != null &&
                                              widget.homeworkForThisDay.documentsContenuDeSeance.length > 0))
                                        Container(
                                          height: screenSize.size.height / 10 * 0.6,
                                          width: screenSize.size.width / 5 * 4.5,
                                          child: CupertinoSegmentedControl<int>(
                                              onValueChanged: (i) {
                                                setState(() {
                                                  segmentedControlIndex = i;
                                                });
                                              },
                                              groupValue: segmentedControlIndex,
                                              children: <int, Widget>{
                                                0: Text(
                                                  'A faire',
                                                  style: TextStyle(fontFamily: "Asap"),
                                                ),
                                                1: Text(
                                                  'Contenu',
                                                  style: TextStyle(fontFamily: "Asap"),
                                                  textAlign: TextAlign.center,
                                                ),
                                              }),
                                        ),
                                      if (this.widget.homeworkForThisDay.nomProf.length > 0)
                                        Container(
                                            child: Text(
                                          this.widget.homeworkForThisDay.nomProf,
                                          style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                        )),
                                      HtmlWidget(
                                          segmentedControlIndex == 0
                                              ? this.widget.homeworkForThisDay.contenu
                                              : this.widget.homeworkForThisDay.contenuDeSeance,
                                          textStyle: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                                          customWidgetBuilder: (element) {
                                        if (element.attributes['class'] == 'math-tex') {
                                          try {
                                            return Container(
                                                child: TeXView(
                                              child: TeXViewDocument(element.text,
                                                  style: TeXViewStyle.fromCSS(
                                                      """background-color: #${(isDarkModeEnabled ? darken(Theme.of(context).primaryColorDark, forceAmount: 0.1) : darken(Theme.of(context).primaryColor, forceAmount: 0.03)).toCSSColor()}; color: #${ThemeUtils.textColor().toCSSColor()}""")),
                                            ));
                                          } catch (e) {
                                            return Container();
                                          }
                                        }

                                        return null;
                                      }, onTapUrl: (url) async {
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw "Unable to launch url";
                                        }
                                      }),
                                    ],
                                  ),
                                ),
                              ),
                            if (this.widget.homeworkForThisDay.loaded &&
                                this.widget.homeworkForThisDay.documents != null &&
                                (segmentedControlIndex == 0
                                        ? this.widget.homeworkForThisDay.documents.length
                                        : this.widget.homeworkForThisDay.documentsContenuDeSeance.length) !=
                                    0 &&
                                isExpanded)
                              Container(
                                width: screenSize.size.width / 5 * 4.5,
                                child: Column(
                                  children: <Widget>[
                                    if (this.widget.homeworkForThisDay.loaded)
                                      Material(
                                        color: Color(0xff2874A6),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              isDocumentExpanded = !isDocumentExpanded;
                                            });
                                          },
                                          child: Container(
                                            height: screenSize.size.height / 10 * 0.5,
                                            width: screenSize.size.width / 5 * 4.5,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  "Documents",
                                                  style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                                ),
                                                Icon(MdiIcons.fileOutline, color: Colors.white),
                                                if (isDocumentExpanded)
                                                  SizedBox(
                                                    width: screenSize.size.width / 5 * 1.88,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 75),
                                      width: screenSize.size.width / 5 * 4.5,
                                      height: isDocumentExpanded
                                          ? (segmentedControlIndex == 0
                                                  ? widget.homeworkForThisDay.documents.length
                                                  : widget.homeworkForThisDay.documentsContenuDeSeance.length) *
                                              (screenSize.size.height / 10 * 0.7)
                                          : 0,
                                      child: ListView.builder(
                                          itemCount: segmentedControlIndex == 0
                                              ? widget.homeworkForThisDay.documents.length
                                              : widget.homeworkForThisDay.documentsContenuDeSeance.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Material(
                                              color: Color(0xff5FA9DA),
                                              child: InkWell(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      border:
                                                          Border(bottom: BorderSide(width: 0.2, color: Colors.white))),
                                                  width: screenSize.size.width / 5 * 4.4,
                                                  height: screenSize.size.height / 10 * 0.7,
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          margin:
                                                              EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                                          width: screenSize.size.width / 5 * 3.8,
                                                          child: ClipRRect(
                                                            child: Marquee(
                                                                text: (segmentedControlIndex == 0
                                                                        ? widget.homeworkForThisDay.documents
                                                                        : widget.homeworkForThisDay
                                                                            .documentsContenuDeSeance)[index]
                                                                    .libelle,
                                                                blankSpace: screenSize.size.width / 5 * 0.2,
                                                                style:
                                                                    TextStyle(fontFamily: "Asap", color: Colors.white)),
                                                          ),
                                                        ),
                                                      ),
                                                      Positioned(
                                                        right: screenSize.size.width / 5 * 0.1,
                                                        top: screenSize.size.height / 10 * 0.11,
                                                        child: Container(
                                                          height: screenSize.size.height / 10 * 0.5,
                                                          decoration: BoxDecoration(
                                                              color: darken(Color(0xff5FA9DA)),
                                                              borderRadius: BorderRadius.circular(50)),
                                                          child: ViewModelBuilder<DownloadModel>.reactive(
                                                              viewModelBuilder: () => DownloadModel(),
                                                              builder: (context, model, child) {
                                                                return FutureBuilder(
                                                                    future: model.fileExists((segmentedControlIndex == 0
                                                                            ? widget.homeworkForThisDay.documents
                                                                            : widget.homeworkForThisDay
                                                                                .documentsContenuDeSeance)[index]
                                                                        .libelle),
                                                                    initialData: false,
                                                                    builder: (context, snapshot) {
                                                                      if (snapshot.data == false) {
                                                                        if (model.isDownloading) {
                                                                          /// If download is in progress or connecting
                                                                          if (model.downloadProgress == null ||
                                                                              model.downloadProgress < 100) {
                                                                            return Container(
                                                                              padding: EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    screenSize.size.width / 5 * 0.2,
                                                                              ),
                                                                              child: Center(
                                                                                child: SizedBox(
                                                                                  width:
                                                                                      screenSize.size.width / 5 * 0.3,
                                                                                  height:
                                                                                      screenSize.size.width / 5 * 0.3,
                                                                                  child: CircularProgressIndicator(
                                                                                    backgroundColor: Colors.green,
                                                                                    strokeWidth: screenSize.size.width /
                                                                                        5 *
                                                                                        0.05,
                                                                                    value: model.downloadProgress,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            );
                                                                          }

                                                                          ///Download is ended
                                                                          else {
                                                                            return Container(
                                                                                child: IconButton(
                                                                              padding:
                                                                                  EdgeInsets.symmetric(vertical: 0),
                                                                              icon: Row(
                                                                                mainAxisAlignment:
                                                                                    MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Icon(
                                                                                    MdiIcons.check,
                                                                                    color: Colors.green,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              onPressed: () async {
                                                                                print((segmentedControlIndex == 0
                                                                                            ? widget.homeworkForThisDay
                                                                                                .documents
                                                                                            : widget.homeworkForThisDay
                                                                                                .documentsContenuDeSeance)[
                                                                                        index]
                                                                                    .libelle);
                                                                                FileAppUtil.openFile(
                                                                                    (segmentedControlIndex == 0
                                                                                            ? widget.homeworkForThisDay
                                                                                                .documents
                                                                                            : widget.homeworkForThisDay
                                                                                                .documentsContenuDeSeance)[index]
                                                                                        .libelle,
                                                                                    usingFileName: true);
                                                                              },
                                                                            ));
                                                                          }
                                                                        }

                                                                        ///Isn't downloading
                                                                        if (!model.isDownloading) {
                                                                          return IconButton(
                                                                            padding: EdgeInsets.symmetric(vertical: 0),
                                                                            icon: Icon(
                                                                              MdiIcons.fileDownloadOutline,
                                                                              color: Colors.white,
                                                                            ),
                                                                            onPressed: () async {
                                                                              await model.download(
                                                                                  (segmentedControlIndex == 0
                                                                                          ? widget
                                                                                              .homeworkForThisDay.documents
                                                                                          : widget.homeworkForThisDay
                                                                                              .documentsContenuDeSeance)[
                                                                                      index]);
                                                                            },
                                                                          );
                                                                        }
                                                                      }

                                                                      ///If file already exists
                                                                      else {
                                                                        return Container(
                                                                            height: screenSize.size.height / 10 * 8,
                                                                            child: IconButton(
                                                                              padding:
                                                                                  EdgeInsets.symmetric(vertical: 0),
                                                                              icon: Icon(
                                                                                MdiIcons.check,
                                                                                color: Colors.green,
                                                                              ),
                                                                              onPressed: () async {
                                                                                FileAppUtil.openFile(
                                                                                    (segmentedControlIndex == 0
                                                                                            ? widget.homeworkForThisDay
                                                                                                .documents
                                                                                            : widget.homeworkForThisDay
                                                                                                .documentsContenuDeSeance)[index]
                                                                                        .libelle,
                                                                                    usingFileName: true);
                                                                              },
                                                                            ));
                                                                      }
                                                                    });
                                                              }),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          }),
                                    )
                                  ],
                                ),
                              ),

                            //Show a button to send homework
                            if (this.widget.homeworkForThisDay.loaded &&
                                this.widget.homeworkForThisDay.rendreEnLigne == true &&
                                isExpanded)
                              Material(
                                color: Color(0xff63A86A),
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                child: InkWell(
                                  onTap: () async {
                                    CustomDialogs.showUnimplementedSnackBar(context);
                                    /*
                                        File file = await FilePicker.getFile();
                                        await api.uploadFile("CDT", this.widget.homeworkForThisDay.idDevoir, file.path);*/
                                  },
                                  child: Container(
                                    width: screenSize.size.width / 5 * 4.9,
                                    height: screenSize.size.height / 10 * 0.5,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Rendre en ligne",
                                          style: TextStyle(fontFamily: "Asap", color: Colors.white),
                                        ),
                                        Icon(Icons.file_upload, color: Colors.white)
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            Material(
                                color: color,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        isExpanded = !isExpanded;
                                      });
                                      if (isExpanded) {
                                        _rotationController.forward();
                                      } else {
                                        _rotationController.reverse();
                                      }
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(width: 0.00000, color: Colors.transparent),
                                        ),
                                        width: screenSize.size.width / 5 * 4.5,
                                        height: screenSize.size.height / 10 * 0.4,
                                        child: Center(
                                            child: AnimatedBuilder(
                                                animation: _rotationAnimation,
                                                builder: (context, snapshot) {
                                                  return Transform.rotate(
                                                      angle: pi * 3 * _rotationAnimation.value,
                                                      child: Icon(Icons.expand_more));
                                                }))))),
                          ],
                        ),
                      )),
                ),

                //Label
                Align(
                  alignment: Alignment.topCenter,
                  child: Material(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                    color: color,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                        if (isExpanded) {
                          _rotationController.forward();
                        } else {
                          _rotationController.reverse();
                        }
                      },
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                      child: GestureDetector(
                        excludeFromSemantics: true,
                        onLongPress: () async {
                          await CustomDialogs.showHomeworkDetailsDialog(context, this.widget.homeworkForThisDay);
                          setState(() {});
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 0, color: Colors.transparent),
                          ),
                          width: screenSize.size.width / 5 * 4.5,
                          height: isExpanded
                              ? (screenSize.size.height / 10 * 8.8) / 10 * 0.6
                              : (screenSize.size.height / 10 * 8.8) / 10 * 0.6,
                          child: Stack(children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  left: screenSize.size.width / 5 * 0.2,
                                  top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: FittedBox(
                                  child: Row(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Text(
                                        this.widget.homeworkForThisDay.matiere,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.normal),
                                      ),
                                      if (widget.homeworkForThisDay.interrogation == true)
                                        Container(
                                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.15),
                                          width: screenSize.size.width / 5 * 0.15,
                                          height: screenSize.size.width / 5 * 0.15,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.orangeAccent),
                                        ),
                                      if (widget.homeworkForThisDay.rendreEnLigne == true)
                                        Container(
                                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.15),
                                          width: screenSize.size.width / 5 * 0.15,
                                          height: screenSize.size.width / 5 * 0.15,
                                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                                        ),
                                      Container(
                                        width: screenSize.size.width / 5 * 0.5,
                                        height: screenSize.size.width / 5 * 0.5,
                                        child: FittedBox(
                                          child: FutureBuilder(
                                              future: offline.doneHomework
                                                  .getHWCompletion(widget.homeworkForThisDay.id ?? ''),
                                              initialData: false,
                                              builder: (context, snapshot) {
                                                bool done = snapshot.data;
                                                return CircularCheckBox(
                                                  activeColor: Colors.blue,
                                                  inactiveColor: Colors.white,
                                                  value: done,
                                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                                  onChanged: (bool x) async {
                                                    setState(() {
                                                      done = !done;
                                                      donePercentFuture = HomeworkUtils.getHomeworkDonePercent();
                                                    });
                                                    offline.doneHomework
                                                        .setHWCompletion(widget.homeworkForThisDay.id, x);
                                                  },
                                                );
                                              }),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                            ),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}
