import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
import 'package:ynotes/UI/gradesPage.dart';
import 'package:ynotes/landGrades.dart';
import 'package:ynotes/UI/summaryPage.dart';
class TabBuilder extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _TabBuilderState();
  }
}

class _TabBuilderState extends State<TabBuilder> with TickerProviderStateMixin {


  //This controller allow the app to toggle a function when there is a tab change
  TabController _tabController;
  @override
  void initState() {
    super.initState();

    //Define a controller in order to control the scrolls
    _tabController = TabController(vsync: this, length: 4, initialIndex: 1);
    _tabController.addListener(_handleTabChange);
    //Animation of the radius


  }

  //On tab change
  void _handleTabChange() {



    if (_tabController.index==0 || _tabController.index==3 )
      {


      }
    else {


    }

  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double extrasize = 0;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            backgroundColor: Color(0xff141414),
            appBar: PreferredSize(
              preferredSize: Size(null, 100),
              child: ClipRRect(

                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                child: Container(
                  padding: EdgeInsets.all(0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 10 * 1.2,
                  child: ClipRRect(

                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25)),
                    child: Container(
                      color: Color(0xff404040),
                      child: Container(
                        child: Stack(
                          children: [
                            Align(

                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width / 5*0.1 , top:  MediaQuery.of(context).size.height/10*0.05),
                                width: MediaQuery.of(context).size.height / 10 * 0.7,
                                height: MediaQuery.of(context).size.height / 10 * 0.7,
                                child: ClipOval(

                                  child: Material(

                                    color: Colors.grey.withOpacity(0.5),
                                    child: IconButton(

                                      color: Colors.white,

                                      icon: Icon(Icons.settings, ),
                                      onPressed:() {
                                        sortMarks(2);


                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(

                              alignment: Alignment.bottomCenter,
                              child: Container(
                                margin: EdgeInsets.only(bottom: 0),

                                height:
                                    MediaQuery.of(context).size.height / 10 * 0.4,
                                width: MediaQuery.of(context).size.width,
                                child: Theme(
                                  data: ThemeData(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                  ),
                                  child: TabBar(

                                      controller: _tabController,
                                      labelColor: Colors.white,
                                      labelPadding: EdgeInsets.all(0),
                                      unselectedLabelColor: Colors.white,
                                      indicatorSize: TabBarIndicatorSize.label,
                                      indicatorWeight: 0,
                                      indicatorPadding: EdgeInsets.only(bottom: 0),
                                      indicator: BoxDecoration(


                                          borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(10),
                                              topRight: Radius.circular(10)),
                                          color: Color(0xff141414)),
                                      tabs: [
                                        Tab(
                                          child: Container(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Space",
                                                style:
                                                    TextStyle(fontFamily: "Asap"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Tab(

                                          child: Container(
                                            margin: EdgeInsets.only(bottom: 0),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text("Résumé",
                                                  style: TextStyle(
                                                      fontFamily: "Asap")),
                                            ),
                                          ),
                                        ),
                                        Badge(
                                          animationType: BadgeAnimationType.scale,
                                          toAnimate: true,
                                          showBadge: newGrades,
                                          elevation: 0,
                                          position:   BadgePosition.topRight(right:  MediaQuery.of(context).size.width / 10 *0.001, top: -MediaQuery.of(context).size.height / 15 * 0.1),
                                          badgeColor: Colors.blue,

                                          child: Tab(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text("Notes",
                                                  style:
                                                      TextStyle(fontFamily: "Asap")),
                                            ),
                                          ),
                                        ),
                                        Tab(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text("Agenda",
                                                style:
                                                    TextStyle(fontFamily: "Asap")),
                                          ),
                                        )
                                      ]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Stack(

              children: <Widget>[
                TabBarView(controller: _tabController, children: [
                  Icon(Icons.apps),
                  SummaryPage(),
                  gradesPage(),
                  Icon(Icons.games),
                ]),
              ],
            )));
  }
}
