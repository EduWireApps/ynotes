import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes_packages/theme.dart';

class PronoteLoginWayBox extends StatefulWidget {
  final Function callback;
  const PronoteLoginWayBox({required this.callback, Key? key}) : super(key: key);

  @override
  _PronoteLoginWayBoxState createState() => _PronoteLoginWayBoxState();
}

class _PronoteLoginWayBoxState extends State<PronoteLoginWayBox> {
  TextEditingController passwordCon = TextEditingController();
  TextEditingController loginCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: theme.colors.neutral.shade300),
      child: Column(
        children: [
          _buildPronoteLoginWay(LoginPageTextContent.pronote.loginWays.geolocation,
              LoginPageTextContent.pronote.loginWays.geolocationDescription, MdiIcons.mapMarker, "location"),
          SizedBox(
            height: 1.2.h,
          ),
          _buildPronoteLoginWay(LoginPageTextContent.pronote.loginWays.qrCodeScanner,
              LoginPageTextContent.pronote.loginWays.qrCodeScannerDescription, Icons.qr_code, "qrcode"),
          SizedBox(
            height: 1.2.h,
          ),
          _buildPronoteLoginWay(LoginPageTextContent.pronote.loginWays.url,
              LoginPageTextContent.pronote.loginWays.urlDescription, MdiIcons.cursorText, "manual")
        ],
      ),
    );
  }

  _buildPronoteLoginWay(String label, String description, IconData icon, String id) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      color: theme.colors.neutral.shade200,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          widget.callback(id);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colors.neutral.shade200,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        icon,
                        size: 30,
                        color: theme.colors.neutral.shade500,
                      ),
                    ],
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(label,
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: theme.colors.neutral.shade500,
                                fontWeight: FontWeight.bold))),
                    Container(
                        child: Text(description,
                            style: TextStyle(
                              fontFamily: "Asap",
                              color: theme.colors.neutral.shade400,
                            )))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
