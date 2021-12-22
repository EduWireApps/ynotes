import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/shared/login_controller.dart';
import 'package:ynotes/useful_methods.dart';

class ConnectionStatus extends StatefulWidget {
  final LoginController con;
  final Animation<double> showLoginControllerStatus;

  const ConnectionStatus({Key? key, required this.con, required this.showLoginControllerStatus}) : super(key: key);

  @override
  _ConnectionStatusState createState() => _ConnectionStatusState();
}

class _ConnectionStatusState extends State<ConnectionStatus> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return AnimatedBuilder(
        animation: widget.showLoginControllerStatus,
        builder: (context, animation) {
          return Opacity(
            opacity: 0.8,
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/settings/account"),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                color: case2(widget.con.actualState, {
                  loginStatus.loggedIn: const Color(0xff4ADE80),
                  loginStatus.loggedOff: const Color(0xffA8A29E),
                  loginStatus.error: const Color(0xffF87171),
                  loginStatus.offline: const Color(0xffFCD34D),
                }),
                height: (screenSize.size.height / 10 * 0.4 * (1 - widget.showLoginControllerStatus.value)),
                child: ClipRRect(
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                            case2(
                              widget.con.actualState,
                              {
                                loginStatus.loggedOff: const SpinKitThreeBounce(
                                  size: 30,
                                  color: Color(0xff57534E),
                                ),
                                loginStatus.offline: const Icon(
                                  MdiIcons.networkStrengthOff,
                                  size: 30,
                                  color: Color(0xff78716C),
                                ),
                                loginStatus.error: GestureDetector(
                                  onTap: () async {},
                                  child: const Icon(
                                    MdiIcons.exclamation,
                                    size: 30,
                                    color: Color(0xff57534E),
                                  ),
                                ),
                                loginStatus.loggedIn: const Icon(
                                  MdiIcons.check,
                                  size: 30,
                                  color: Color(0xff57534E),
                                )
                              },
                              const SpinKitThreeBounce(
                                size: 30,
                                color: Color(0xff57534E),
                              ),
                            ) as Widget,
                          ]),
                          Text(widget.con.details,
                              style: const TextStyle(fontFamily: "Asap", color: Color(0xff57534E))),
                          const Text(" Voir l'état du compte.",
                              style:
                                  TextStyle(fontFamily: "Asap", color: Color(0xff57534E), fontWeight: FontWeight.bold))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
