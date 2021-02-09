import 'package:flutter/material.dart';

class SuccessAchievementNotification extends StatefulWidget {
  @override
  _SuccessAchievementNotificationState createState() => _SuccessAchievementNotificationState();
}

class _SuccessAchievementNotificationState extends State<SuccessAchievementNotification> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        child: Stack(
          children: [
            Positioned(
              left: 26,
              top: 63,
              child: Container(
                width: 532,
                height: 34,
                decoration: BoxDecoration(
                  color: Color(
                    0xff444444,
                  ),
                  borderRadius: BorderRadius.circular(
                    56,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 26,
              top: 63,
              child: Container(
                width: 321,
                height: 34,
                decoration: BoxDecoration(
                  color: Color(
                    0xff69c883,
                  ),
                  borderRadius: BorderRadius.circular(
                    56,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 302,
              top: 69,
              child: Container(
                width: 27,
                height: 11,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(
                    56,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 31,
              top: 19,
              child: Text(
                "Faire 10 devoirs",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Asap",
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              left: 571,
              top: 51,
              child: Container(
                width: 57,
                height: 57,
                decoration: BoxDecoration(
                  color: Color(
                    0xff444444,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: 575,
              top: 66,
              child: Text(
                "5/10",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  fontFamily: "Asap",
                ),
                textAlign: TextAlign.center,
              ),
            ),

            /// stack requires empty non positioned widget to work properly. refer: https://github.com/flutter/flutter/issues/49631#issuecomment-582090992
            Container(),
          ],
        ),
        width: 674,
        height: 125,
        decoration: BoxDecoration(
          color: Color(
            0xff585858,
          ),
          borderRadius: BorderRadius.circular(
            10,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          19,
        ),
      ),
    );
  }
}
