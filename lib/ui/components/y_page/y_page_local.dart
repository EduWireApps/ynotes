import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes_packages/components.dart';

class YPageLocal extends StatefulWidget {
  final Widget child;
  final String title;
  final List<IconButton>? actions;
  final bool scrollable;
  const YPageLocal({Key? key, required this.child, required this.title, this.actions, this.scrollable = true})
      : super(key: key);

  @override
  _YPageLocalState createState() => _YPageLocalState();
}

class _YPageLocalState extends State<YPageLocal> {
  @override
  Widget build(BuildContext context) {
    void closePage() => Navigator.pop(context);

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: closePage,
            ),
            backgroundColor:
                ThemeUtils.isThemeDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
            centerTitle: false,
            title: Text(widget.title, textAlign: TextAlign.start),
            systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light,
            actions: widget.actions),
        body: widget.scrollable
            ? YShadowScrollContainer(color: Theme.of(context).backgroundColor, children: [widget.child])
            : widget.child);
  }
}
