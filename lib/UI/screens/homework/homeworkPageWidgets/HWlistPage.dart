import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:ynotes/UI/components/dialogs.dart';
import 'package:ynotes/UI/screens/homework/homeworkPage.dart';
import 'package:ynotes/UI/screens/homework/homeworkPageWidgets/HWcontainer.dart';
import 'package:ynotes/UI/screens/homework/homeworkPageWidgets/HWelement.dart';
import 'package:ynotes/classes.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/main.dart';
import 'package:ynotes/models/homework/controller.dart';
import 'package:ynotes/usefulMethods.dart';
import 'package:ynotes/utils/themeUtils.dart';

class HomeworkFirstPage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeworkFirstPageState();
  }
}

class _HomeworkFirstPageState extends State<HomeworkFirstPage> {
  Future<void> refreshLocalHomeworkList() async {
    await hwcontroller.refresh(force: true);
  }

  void callback() {
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => mounted ? hwcontroller.refresh() : null);
  }

  void reloadDates() async {
    var realHW = await homeworkListFuture;
    setState(() {
      dates = getDates(realHW);
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return ChangeNotifierProvider<HomeworkController>.value(
        value: hwcontroller,
        child: Consumer<HomeworkController>(builder: (context, model, child) {
          return RefreshIndicator(
              onRefresh: refreshLocalHomeworkList,
              child: model.getHomework != null
                  ? (model.getHomework.length != 0)
                      ? Stack(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1),
                              child: ListView.builder(
                                  itemCount: getDates(model.getHomework).length,
                                  padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
                                  itemBuilder: (BuildContext context, int index) {
                                    return Column(
                                      children: <Widget>[
                                        if (getWeeksRelation(index, model.getHomework) != null)
                                          Row(children: <Widget>[
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                                  child: Divider(
                                                    color: ThemeUtils.textColor(),
                                                    height: 36,
                                                  )),
                                            ),
                                            Text(
                                              getWeeksRelation(index, model.getHomework),
                                              style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                                            ),
                                            Expanded(
                                              child: new Container(
                                                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                                  child: Divider(
                                                    color: ThemeUtils.textColor(),
                                                    height: 36,
                                                  )),
                                            ),
                                          ]),
                                        HomeworkContainer(
                                            getDates(model.getHomework)[index], this.callback, model.getHomework),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        )
                      : Container(
                          height: screenSize.size.height / 10 * 7.5,
                          width: screenSize.size.width / 5 * 4.7,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/noHomework.png')),
                              Text(
                                "Pas de devoirs à l'horizon... \non se détend ?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Asap",
                                  color: ThemeUtils.textColor(),
                                ),
                              ),
                              FlatButton(
                                onPressed: () {
                                  //Reload list
                                  refreshLocalHomeworkList();
                                },
                                child: !model.isFetching
                                    ? Text("Recharger",
                                        style: TextStyle(
                                          fontFamily: "Asap",
                                          color: ThemeUtils.textColor(),
                                        ))
                                    : FittedBox(
                                        child: SpinKitThreeBounce(
                                            color: Theme.of(context).primaryColorDark,
                                            size: screenSize.size.width / 5 * 0.4)),
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Theme.of(context).primaryColorDark)),
                              )
                            ],
                          ),
                        )
                  : SpinKitFadingFour(
                      color: Theme.of(context).primaryColorDark,
                      size: screenSize.size.width / 5 * 1,
                    ));
        }));
  }
}
