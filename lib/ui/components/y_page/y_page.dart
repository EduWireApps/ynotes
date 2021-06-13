import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_drawer/widgets/connection_status.dart';
import 'package:ynotes/ui/components/y_drawer/y_drawer.dart';
// import 'widgets/body.dart';
// import 'widgets/header.dart';

class YPage extends StatefulWidget {
  final String title;
  // final List<Widget> headerChildren;
  // final Widget? body;
  final Widget body;
  // final Color? primaryColor;
  // final Color? secondaryColor;
  final List<IconButton>? actions;
  final bool isScrollable;

  const YPage(
      {Key? key,
      required this.title,
      // required this.primaryColor,
      // required this.secondaryColor,
      // this.headerChildren = const [],
      this.actions,
      required this.body,
      this.isScrollable = true})
      : super(key: key);

  @override
  _YPageState createState() => _YPageState();
}

class _YPageState extends State<YPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData screenSize = MediaQuery.of(context);
    return Scaffold(
      // backgroundColor: widget.primaryColor,
      backgroundColor: Theme.of(context).backgroundColor,
      drawer: YDrawer(),
      // appBar: AppBar(
      //   backgroundColor: widget.primaryColor,
      //   shadowColor: Colors.transparent,
      // ),
      appBar: AppBar(
          backgroundColor: ThemeUtils.isThemeDark ? Theme.of(context).primaryColor : Theme.of(context).primaryColorDark,
          centerTitle: false,
          title: Text(widget.title, textAlign: TextAlign.start),
          systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          actions: widget.actions),
      body: widget.isScrollable
          ? SingleChildScrollView(child: _page(context))
          : Container(height: screenSize.size.height, child: _page(context)),
    );
  }

  _page(BuildContext context) {
    late Animation<double> showLoginControllerStatus;
    late AnimationController showLoginControllerStatusController;

    showLoginControllerStatusController = AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    showLoginControllerStatus = new Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
        parent: showLoginControllerStatusController, curve: Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)));
    return ChangeNotifierProvider<LoginController>.value(
      value: appSys.loginController,
      child: Consumer<LoginController>(builder: (context, model, child) {
        if (model.actualState != loginStatus.loggedIn) {
          showLoginControllerStatusController.forward();
        } else {
          showLoginControllerStatusController.reverse();
        }
        return Column(children: [
          ConnectionStatus(
            con: model,
            showLoginControllerStatus: showLoginControllerStatus,
          ),
          widget.isScrollable ? widget.body : Expanded(child: widget.body)
        ]);
      }),
    );
  }
}
