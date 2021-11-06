import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/core/utils/controller.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class ZConnectionStatus extends StatefulWidget {
  const ZConnectionStatus({Key? key}) : super(key: key);

  @override
  _ZConnectionStatusState createState() => _ZConnectionStatusState();
}

class _ZConnectionStatusState extends State<ZConnectionStatus> with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;

  loginStatus get _state => appSys.loginController.actualState;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: _state == loginStatus.loggedIn ? 1 : null,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.1, 1.0, curve: Curves.fastOutSlowIn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<LoginController>(
        controller: appSys.loginController,
        builder: (context, controller, _) {
          if (_state == loginStatus.loggedIn) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          return AnimatedBuilder(
              animation: _animation,
              builder: (context, _) => InkWell(
                  onTap: () => Navigator.pushNamed(context, "/settings/account"),
                  child: Ink(
                      child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          color: controller.color.backgroundColor,
                          height: YScale.s8 * _animation.value,
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: YScale.s5, child: FittedBox(child: controller.icon)),
                              YHorizontalSpacer(YScale.s2),
                              Text(controller.details,
                                  style: theme.texts.body1.copyWith(color: controller.color.foregroundColor)),
                            ],
                          )))));
        });
  }
}
