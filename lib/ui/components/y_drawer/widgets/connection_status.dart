import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/logic/shared/loginController.dart';
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
              onTap: () => Navigator.pushNamed(context, "/account"),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 400),
                color: case2(widget.con.actualState, {
                  loginStatus.loggedIn: Color(0xff4ADE80),
                  loginStatus.loggedOff: Color(0xffA8A29E),
                  loginStatus.error: Color(0xffF87171),
                  loginStatus.offline: Color(0xffFCD34D),
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
                                loginStatus.loggedOff: SpinKitThreeBounce(
                                  size: 30,
                                  color: Color(0xff57534E),
                                ),
                                loginStatus.offline: Icon(
                                  MdiIcons.networkStrengthOff,
                                  size: 30,
                                  color: Color(0xff78716C),
                                ),
                                loginStatus.error: GestureDetector(
                                  onTap: () async {},
                                  child: Icon(
                                    MdiIcons.exclamation,
                                    size: 30,
                                    color: Color(0xff57534E),
                                  ),
                                ),
                                loginStatus.loggedIn: Icon(
                                  MdiIcons.check,
                                  size: 30,
                                  color: Color(0xff57534E),
                                )
                              },
                              SpinKitThreeBounce(
                                size: 30,
                                color: Color(0xff57534E),
                              ),
                            ) as Widget,
                          ]),
                          Text(widget.con.details, style: TextStyle(fontFamily: "Asap", color: Color(0xff57534E))),
                          Text(" Voir l'état du compte.",
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
