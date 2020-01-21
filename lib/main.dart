// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(          // Add the 3 lines from here...
        primaryColor: Colors.blue,
        backgroundColor: Colors.black
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome there !'),
        ),
        body: Center(
          child: Text('Hello')
        )


      )
    );
  }
// #enddocregion build
}
// #enddocregion MyApp

