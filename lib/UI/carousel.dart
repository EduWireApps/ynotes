import 'package:auto_size_text/auto_size_text.dart';
import 'package:ynotes/UI/loginPage.dart';
import 'package:flutter/material.dart';

class SlidingCarousel extends StatefulWidget {
  SlidingCarousel({Key key}) : super(key: key);
  _SlidingCarouselState createState() => _SlidingCarouselState();
}

//Create states of each page
class page1 extends StatefulWidget {
  final double offset;
  final int idx;
  page1({Key key, this.offset, this.idx}) : super(key: key);
  _page1State createState() => _page1State();
}

class page2 extends StatefulWidget {
  final double offset;
  final int idx;
  page2({Key key, this.offset, this.idx}) : super(key: key);
  _page2State createState() => _page2State();
}

class page3 extends StatefulWidget {
  final double offset;
  final int idx;
  page3({Key key, this.offset, this.idx}) : super(key: key);

  _page3State createState() => _page3State();
}

//PAGE1 STATE
class _page1State extends State<page1> {
  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        Transform.translate(
          offset: Offset(-(widget.offset) * 400 - 75 + 75 * widget.offset,
              -135 + 135 * widget.offset),
          child: Align(
              alignment: Alignment.center,
              child: Transform.rotate(
                angle: -0.4 + widget.offset * 0.4,
                child: Icon(
                  Icons.star,
                  color: Color(0xFFE7D928),
                  size: 150.0,
                ),
              )),
        ),
        Positioned(
          top: 20,
          height: 90,
          width: MediaQuery.of(context).size.width,
          child: Transform.translate(
              offset: Offset(-(widget.offset) * 200, 0),
              child: SizedBox(
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "Bienvenue dans",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' yNotes !',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
        ),
        Transform.translate(
          offset: Offset(-(widget.offset) * 60, 0),
          child: Stack(
            children: <Widget>[
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: 0.1 - (widget.offset / 10),
                child: Transform.translate(
                  offset: Offset(15, -50 + (widget.offset * 50)),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: MediaQuery.of(context).size.width / 2,
                          height: MediaQuery.of(context).size.width / 2,
                          decoration: ShapeDecoration(
                            color: Color(0xFFD5B872),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(40.0),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              height: MediaQuery.of(context).size.width / 2.5,
                              decoration: ShapeDecoration(
                                color: Color(0xFF3F3F3F),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(70),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                  margin: EdgeInsets.only(left: 22, top: 10),
                                  width:
                                      MediaQuery.of(context).size.width / 3.5,
                                  height:
                                      MediaQuery.of(context).size.width / 3.5,
                                  child: Image(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/marks/3.0x/mark.png')),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: 0.4 - (widget.offset / 2.5),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: ShapeDecoration(
                          color: Color(0xFFC9463C),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 2.5,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3F3F3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(70),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(left: 22, top: 10),
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                child: Image(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/marks/3.0x/mark.png')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(-(widget.offset) * 300 + 125, 50),
                child: Align(
                    alignment: Alignment.center,
                    child: Transform.rotate(
                      angle: 0.6 - (widget.offset / 1.6),
                      child: Icon(
                        Icons.book,
                        color: Color(0xFF606060),
                        size: 110.0,
                      ),
                    )),
              ),
              Transform.rotate(
                origin: Offset(
                  -(MediaQuery.of(context).size.width / 5),
                  (MediaQuery.of(context).size.width / 4),
                ),
                angle: -0.2 + (widget.offset * 0.2),
                child: Stack(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 2,
                        decoration: ShapeDecoration(
                          color: Color(0xFF1CA68A),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(40.0),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            width: MediaQuery.of(context).size.width / 2.5,
                            height: MediaQuery.of(context).size.width / 2.5,
                            decoration: ShapeDecoration(
                              color: Color(0xFF3F3F3F),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(70),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(left: 22, top: 10),
                                width: MediaQuery.of(context).size.width / 3.5,
                                height: MediaQuery.of(context).size.width / 3.5,
                                child: Image(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'assets/images/marks/3.0x/mark.png')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          width: MediaQuery.of(context).size.width,
          bottom: MediaQuery.of(context).size.height/15,
          height: 90,
          child: Transform.translate(
              offset: Offset(-(widget.offset) * 200, 0),
              child: Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  width: 50,
                  height: 140.0,
                  child: AutoSizeText.rich(
                      TextSpan(
                        text: "Car les",
                        children: <TextSpan>[
                          TextSpan(
                              text: ' outils ',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: ' sont aussi importants que le'),
                          TextSpan(
                              text: ' travail...',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
        )
      ],
    );
  }
}

//PAGE2 STATE
class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Transform.translate(
                  offset: Offset(200-(widget.offset-1)*20,57 ),
                  child: Container(
                      height: 100,
                      width: 100,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/calendar.png'))),
                ),
                Transform.translate(
    offset: Offset(70-(widget.offset-1)*20,-157 ),
                  child: Container(
                      height: 120,
                      width: 120,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child:
                              Image.asset('assets/images/shelves/clock.png'))),
                ),
                Transform.translate(
                  offset: Offset(0-(widget.offset-1)*400, -90),
                  child: Container(
                      height: 170,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/shelve1.png'))),
                ),
                Transform.translate(
                  offset: Offset(0-(widget.offset-1)*300, 90),
                  child: Container(
                      height: 90,
                      width: 320,
                      child: FittedBox(
                          fit: BoxFit.fill,
                          child: Image.asset(
                              'assets/images/shelves/shelve2.png'))),
                ),
              ],
            ),
          ),
          Positioned(
            bottom:  MediaQuery.of(context).size.height/15,
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
                offset: Offset(-(widget.offset - 1) * 200, 0),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(
                        TextSpan(
                          text: "...emmenez l'école",
                          children: <TextSpan>[
                            TextSpan(
                                text: ' dans votre poche ! ',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0)))),
          )
        ],
      ),
    );
  }
}

class _page3State extends State<page3> {
  @override
  Widget build(BuildContext context) {
    double opacityvalue = 0;
    if (widget.offset-1>0)
      {
        opacityvalue = widget.offset-1;
      }
    else {
      opacityvalue = 0;
    }
    return Stack(
      children: <Widget>[

        Positioned(
          left: MediaQuery.of(context).size.width/8-(widget.offset-2)*250,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(

                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 6-(widget.offset-2),
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          right: MediaQuery.of(context).size.width/8+(widget.offset-2)*70,
          top: MediaQuery.of(context).size.height/5,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 1.2-(widget.offset-2)*1.2,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width/3.5-(widget.offset-2)*310,
          top: MediaQuery.of(context).size.height/2.3,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 4-(widget.offset-2)*1.4,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 110.0,
                  ),
                ),
              )),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width/12-(widget.offset-2)*280,
          top: MediaQuery.of(context).size.height/4,
          child: Align(
              alignment: Alignment.center,
              child: Opacity(
                opacity: opacityvalue,
                child: Transform.rotate(
                  angle: 2-(widget.offset-2)*1.5,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ),
              )),
        ),


          Positioned(
            bottom:  MediaQuery.of(context).size.height/5,
            height: 90,
            width: MediaQuery.of(context).size.width,
            child: Transform.translate(
                offset: Offset(-(widget.offset - 2) * 200, 0),
                child: Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    width: 50,
                    height: 140.0,
                    child: AutoSizeText.rich(

                        TextSpan(
                          text: "...sans oublier de gérer votre",
                          children: <TextSpan>[
                            TextSpan(
                                text: ' espace !',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", fontSize: 30.0,color: Colors.white)))),
          ),
        Positioned(
          left: MediaQuery.of(context).size.width/4,
          bottom: MediaQuery.of(context).size.height/10,
          child:   Container(
            width:  MediaQuery.of(context).size.width/2,
            height: 50,
            child: RaisedButton(
              color: Color(0xff5DADE2),
              shape: StadiumBorder(),
              onPressed: () {},
              child: const Text(
                  'Allons-y !',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),

        ),


      ],
    );
  }
}

class PageInfo {
  //Widget Used
  Widget widget;
  //BG used
  Color backgroundColor;
  PageInfo({this.widget, this.backgroundColor});
}

class _SlidingCarouselState extends State<SlidingCarousel> {
  List<PageInfo> _pageInfoList;

  PageController _pageController;
  double _pageOffset;
  int _currentPageId;

  void initState() {
    super.initState();
    _pageOffset = 0.0;

    _currentPageId = 0;

    _pageController = PageController()
      ..addListener(() {
        setState(() {
          _pageOffset = _pageController.page;
        });
      });
    _list(_pageOffset, 0);
  }
//set a list of basic infos (colors)
  _list(offset, idx) {
    return _pageInfoList = [
      PageInfo(
        widget: page1(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFECFCFF),
      ),
      PageInfo(
        widget: page2(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFFE5AE6C),
      ),
      PageInfo(
        widget: page3(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color(0xFF252B62),
      )
    ];
  }

  _setOffset(idx) {
    _list(_pageOffset, idx);
    return _pageInfoList[idx].widget;
  }

  _getBGColor() {
    if (_pageOffset.toInt() + 1 < _pageInfoList.length) {
      //Current background color
      Color current = _pageInfoList[_pageOffset.toInt()].backgroundColor;
      Color next = _pageInfoList[_pageOffset.toInt() + 1].backgroundColor;
      return Color.lerp(current, next, _pageOffset - _pageOffset.toInt());
    } else {
      return _pageInfoList.last.backgroundColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBGColor(),
      body: WillPopScope(
        onWillPop: () async {
          Future.value(
              false);
        },
        child: Column(
          children: <Widget>[
            Expanded(
              child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pageInfoList.length,
                  itemBuilder: (context, idx) {
                    return Container(
                        height: MediaQuery.of(context).size.height,
                        child: Center(child: _setOffset(idx)));
                  }),
            )
          ],
        ),
      ),
    );
  }
}
