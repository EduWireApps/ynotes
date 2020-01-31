import 'package:ynotes/UI/loginPage.dart';
import 'package:flutter/material.dart';

class SlidingCarousel extends StatelessWidget {

  final PageController ctrl = PageController();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          body: PageView(
            // scrollDirection: Axis.vertical,
              controller: ctrl,
              children: [
                Container(  margin: EdgeInsets.only(bottom: 50, right: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),image: const DecorationImage( image: NetworkImage('https:///flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg')),)),
                Container(color: Colors.blue),
                Container(color: Colors.orange),
                Container(color: Colors.red)
              ]
          )

      ),
    );
  }
}