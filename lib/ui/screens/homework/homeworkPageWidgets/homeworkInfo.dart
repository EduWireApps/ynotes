import 'package:flutter/material.dart';

class HomeworkInfos extends StatefulWidget {
  @override
  _HomeworkInfosState createState() => _HomeworkInfosState();
}

class _HomeworkInfosState extends State<HomeworkInfos> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
      child: Container(
        child: Column(
          children: [
            
          ],
        ),
      ),
    );
  }
}
