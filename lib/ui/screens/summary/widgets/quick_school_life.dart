import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ynotes/core/logic/school_life/controller.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';

class QuickSchoolLife extends StatefulWidget {
  const QuickSchoolLife({Key? key}) : super(key: key);

  @override
  _QuickSchoolLifeState createState() => _QuickSchoolLifeState();
}

class _QuickSchoolLifeState extends State<QuickSchoolLife> {
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return ChangeNotifierProvider<SchoolLifeController>.value(
        value: appSys.schoolLifeController,
        child: Consumer<SchoolLifeController>(builder: (context, model, child) {
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(top: 0),
            shadowColor: Colors.transparent,
            color: Colors.transparent,
            child: Container(
              color: Colors.transparent,
              margin: const EdgeInsets.only(top: 0),
              width: screenSize.size.width,
              child: ClipRRect(
                child: Stack(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                            margin: EdgeInsets.only(
                                top: (screenSize.size.height / 10 * 8.8) / 10 * 0.1,
                                left: screenSize.size.width / 5 * 0.25,
                                right: screenSize.size.width / 5 * 0.15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Card(
                                  color: Theme.of(context).primaryColor,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.08),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            width: 30,
                                            height: 30,
                                            child: const Icon(
                                              MdiIcons.ticket,
                                              color: Colors.white,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xff27272A),
                                              borderRadius: BorderRadius.circular(500),
                                            )),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: screenSize.size.width / 5 * 0.3,
                                              right: screenSize.size.width / 5 * 0.3),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text((model.tickets?.length ?? 0).toString(),
                                                  style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: ThemeUtils.textColor(),
                                                    fontWeight: FontWeight.bold,
                                                  )),
                                              Text(" tickets",
                                                  style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: ThemeUtils.textColor(),
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: screenSize.size.height / 10 * 0.2,
                                )
                              ],
                            ))),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}
