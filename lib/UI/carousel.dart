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
        Container(
          width: MediaQuery.of(context).size.width / 2,
          height: MediaQuery.of(context).size.width / 2,
          decoration: ShapeDecoration(
            color: Color(0xFF1CA68A),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(40.0),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          height: MediaQuery.of(context).size.width / 2.5,
          decoration: ShapeDecoration(
            color: Color(0xFF3F3F3F),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(70),
            ),
          ),
        ),
      ],
    );
  }
}

//PAGE2 STATE
class _page2State extends State<page2> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Transform.translate(
            offset: Offset(-(widget.offset - widget.idx) * 100,
                -(widget.offset - widget.idx) * 100),
            child: Container(
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: Border.all(
                      color: Colors.red,
                      width: 8.0,
                    ) +
                    Border.all(
                      color: Colors.green,
                      width: 8.0,
                    ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class _page3State extends State<page3> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: Border.all(
                    color: Colors.red,
                    width: 8.0,
                  ) +
                  Border.all(
                    color: Colors.green,
                    width: 8.0,
                  ) +
                  Border.all(
                    color: Colors.blue,
                    width: 8.0,
                  ),
            ),
          ),
        )
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

  _list(offset, idx) {
    return _pageInfoList = [
      PageInfo(
        widget: page1(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Colors.white,
      ),
      PageInfo(
        widget: page2(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color.fromARGB(255, 244, 177, 164),
      ),
      PageInfo(
        widget: page3(
          offset: offset,
          idx: idx,
        ),
        backgroundColor: Color.fromARGB(255, 209, 199, 158),
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
      body: Column(
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
    );
  }
}
