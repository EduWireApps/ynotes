import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/y_drawer/widgets/connection_status.dart';
import 'package:ynotes/ui/components/y_drawer/y_drawer.dart';
import 'package:ynotes_packages/theme.dart';

class YPage extends StatefulWidget {
  final String title;
  final Widget body;
  final List<IconButton>? actions;
  final bool isScrollable;

  const YPage({Key? key, required this.title, this.actions, required this.body, this.isScrollable = true})
      : super(key: key);

  @override
  _YPageState createState() => _YPageState();
}

class _YPageState extends State<YPage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final MediaQueryData screenSize = MediaQuery.of(context);
    return Row(
      children: [
        if (screenSize.size.width > 800)
          Container(
            height: screenSize.size.height,
            width: 310,
            child: YDrawer(),
          ),
        Expanded(
          child: Scaffold(
            backgroundColor: theme.colors.neutral.shade200,
            drawer: (screenSize.size.width < 800) ? YDrawer() : null,
            appBar: AppBar(
                backgroundColor: theme.colors.neutral.shade100,
                centerTitle: false,
                title: Text(widget.title, textAlign: TextAlign.start),
                systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
                brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light,
                actions: widget.actions),
            body: widget.isScrollable
                ? SingleChildScrollView(child: _page(context))
                : Container(height: screenSize.size.height, child: _page(context)),
          ),
        ),
      ],
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
