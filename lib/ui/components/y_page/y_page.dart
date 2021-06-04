import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/drawer.dart';
import 'package:ynotes/ui/components/y_page/body.dart';
import 'package:ynotes/ui/components/y_page/header.dart';

class YPage extends StatefulWidget {
  final String title;
  // final List<Widget> headerChildren;
  // final Widget? body;
  final Widget body;
  // final Color? primaryColor;
  // final Color? secondaryColor;
  final List<IconButton>? actions;

  const YPage(
      {Key? key,
      required this.title,
      // required this.primaryColor,
      // required this.secondaryColor,
      // this.headerChildren = const [],
      this.actions,
      required this.body})
      : super(key: key);

  @override
  _YPageState createState() => _YPageState();
}

class _YPageState extends State<YPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: widget.primaryColor,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: AppDrawer(),
      // appBar: AppBar(
      //   backgroundColor: widget.primaryColor,
      //   shadowColor: Colors.transparent,
      // ),
      appBar: AppBar(
          backgroundColor: ThemeUtils.isThemeDark
              ? Theme.of(context).primaryColorLight
              : Theme.of(context).primaryColorDark,
          centerTitle: false,
          title: Text(widget.title, textAlign: TextAlign.start),
          systemOverlayStyle: ThemeUtils.isThemeDark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark,
          actions: widget.actions),
      body: SingleChildScrollView(
        child: SafeArea(child: widget.body
            // child: Column(
            //   children: [
            //     YPageHeader(
            //       title: widget.title,
            //       children: widget.headerChildren,
            //     ),
            //     if (widget.body != null) YPageBody(child: widget.body)
            //   ],
            // ),
            ),
      ),
    );
  }
}
