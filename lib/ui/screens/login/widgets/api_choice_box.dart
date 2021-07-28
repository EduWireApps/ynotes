import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/column_generator.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes_packages/theme.dart';

class ApiChoiceBox extends StatefulWidget {
  final Function callback;
  const ApiChoiceBox({Key? key, required this.callback}) : super(key: key);

  @override
  _ApiChoiceBoxState createState() => _ApiChoiceBoxState();
}

class _ApiChoiceBoxState extends State<ApiChoiceBox> with TickerProviderStateMixin {
  List<Map> apis() => [
        {
          "name": "EcoleDirecte",
          "mainColor": Color(0xff2874A6),
          "icon": AssetImage('assets/images/icons/ecoledirecte/EcoleDirecteIcon.png'),
        },
        {
          "name": "Pronote",
          "mainColor": Color(0xff61b872),
          "icon": AssetImage('assets/images/icons/pronote/PronoteIcon.png'),
        },
        /*{
          "name": "La Vie Scolaire",
          "mainColor": Color(0xff3e456b),
          "icon": AssetImage(
            'assets/images/icons/laviescolaire/LVSIcon.png',
          ),
        },*/
      ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: theme.colors.neutral.shade300),
      child: Column(
        children: [
          ColumnBuilder(
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Material(
                      color: apis()[index]["mainColor"],
                      borderRadius: BorderRadius.circular(11),
                      child: InkWell(
                        onTap: () async {
                          await setChosenParser(index);
                          await appSys.initOffline();
                          setState(() {
                            appSys.api = apiManager(appSys.offline);
                          });
                          widget.callback();
                        },
                        borderRadius: BorderRadius.circular(25),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 350),
                          child: Container(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  width: 40,
                                  height: 40,
                                  child: FittedBox(
                                    child: Image(
                                      image: apis()[index]["icon"],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Text(apis()[index]["name"],
                                        textAlign: TextAlign.start,
                                        style: TextStyle(fontFamily: "Asap", fontSize: 25, color: Colors.white))),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 0.9.h)
                  ],
                );
              },
              itemCount: apis().length),
          Row(
            children: [
              Spacer(),
              Text(
                LoginPageTextContent.login.unavailableService,
                style: TextStyle(
                    fontFamily: "Asap", color: theme.colors.neutral.shade400, decoration: TextDecoration.underline),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
