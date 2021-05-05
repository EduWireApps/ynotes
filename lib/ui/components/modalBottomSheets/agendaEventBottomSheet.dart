import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/ui/animations/FadeAnimation.dart';
import 'package:ynotes/core/utils/themeUtils.dart';

import '../../../usefulMethods.dart';

///Bottom windows with some infos on the discipline and the possibility to change the discipline color
void agendaEventBottomSheet(context) {
  Color colorGroup;

  showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (BuildContext bc) {
        return AgendaEventChoice();
      });
}

class AgendaEventChoice extends StatelessWidget {
  const AgendaEventChoice({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
        height: screenSize.size.height / 10 * 4,
        padding: EdgeInsets.all(2),
        child: FittedBox(
          child: new Column(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
                  width: screenSize.size.width / 5 * 3.5,
                  child: FadeAnimatedTextKit(
                    text: [
                      "Organisez vos journées",
                      "Organisez vos soirées",
                      "Organisez votre vie",
                    ],
                    textStyle: TextStyle(
                      fontFamily: "Asap",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: ThemeUtils.textColor(),
                    ),
                    textAlign: TextAlign.center,
                    repeatForever: true,
                    duration: Duration(milliseconds: 8000),
                  )),
              SizedBox(
                height: screenSize.size.height / 10 * 0.1,
              ),
              FadeAnimation(
                0.1,
                _buildEventChoiceButton(context, "Événement", Colors.green.shade200, MdiIcons.calendar),
              ),
              FadeAnimation(
                0.12,
                _buildEventChoiceButton(context, "Événement intelligent", Colors.blue.shade200, MdiIcons.bus),
              ),
            ],
          ),
        ));
  }
}

_buildEventChoiceButton(BuildContext context, String content, Color color, IconData icon) {
  MediaQueryData screenSize = MediaQuery.of(context);
  return Container(
    margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18)),
      boxShadow: [
        BoxShadow(
          color: ThemeUtils.darken(Theme.of(context).primaryColor).withOpacity(0.8),
          spreadRadius: 0.2,
          blurRadius: 5,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        child: InkWell(
          splashColor: ThemeUtils.darken(color),
          onTap: () async {},
          child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment(1.4, 0.0), // 10% of the width, so there are ten blinds.
                  colors: [ThemeUtils.darken(color, forceAmount: 0.3), color], // whitish to gray
                  tileMode: TileMode.repeated, // repeats the gradient over the canvas
                ),
              ),
              width: screenSize.size.width / 5 * 4,
              height: screenSize.size.height / 10 * 0.7,
              padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.25),
              child: Stack(
                children: [
                  Transform.rotate(
                    angle: -0.1,
                    child: Transform.translate(
                        offset: Offset(-screenSize.size.width / 5 * 0.5, -screenSize.size.height / 10 * 0.2),
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              icon,
                              color: ThemeUtils.darken(color, forceAmount: 0.8).withOpacity(0.2),
                              size: screenSize.size.width / 5 * 1.2,
                            ))),
                  ),
                  Center(
                    child: AutoSizeText(content,
                        style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w300, fontSize: 28),
                        textAlign: TextAlign.center),
                  ),
                ],
              )),
        ),
      ),
    ),
  );
}
