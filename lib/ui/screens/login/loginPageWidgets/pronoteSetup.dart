import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/screens/login/loginPageWidgets/textField.dart';

class PronoteSetupPart extends StatefulWidget {
  final Function callback;

  const PronoteSetupPart({Key key, this.callback}) : super(key: key);
  @override
  _PronoteSetupPartState createState() => _PronoteSetupPartState();
}

class _PronoteSetupPartState extends State<PronoteSetupPart> {
  _buildPronoteLoginWay(String label, String description, IconData icon, String id) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Material(
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          widget.callback(id);
        },
        child: Container(
          width: screenSize.size.width / 5 * 4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: screenSize.size.width / 5 * 1.1,
                  height: screenSize.size.width / 5 * 1.1,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(icon, size: screenSize.size.width / 5 * 0.5),
                    ],
                  )),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        child: Text(label,
                            style: TextStyle(fontFamily: "Asap", color: Colors.black, fontWeight: FontWeight.bold))),
                    Container(child: Text(description, style: TextStyle(fontFamily: "Asap", color: Colors.black)))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            _buildPronoteLoginWay(
                "Scanner un QR Code", "Scannez le QR code fourni par votre établissement.", Icons.qr_code, "qrcode"),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            _buildPronoteLoginWay("Etablissements proches",
                "Utilisez la géolocalisation pour situer votre établissement.", MdiIcons.mapMarker, "location"),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            _buildPronoteLoginWay("Saisir l'URL",
                "Saisissez vous même l'adresse Pronote fournie par votre établissement.", MdiIcons.cursorText, "manual")
          ],
        ),
      ],
    );
  }
}

class PronoteUrlFieldPart extends StatefulWidget {
  final Function callback;
  final TextEditingController pronoteUrl;
  PronoteUrlFieldPart({Key key, this.callback, this.pronoteUrl}) : super(key: key);
  @override
  _PronoteUrlFieldPartState createState() => _PronoteUrlFieldPartState();
}

class _PronoteUrlFieldPartState extends State<PronoteUrlFieldPart> {
  bool useEnt = false;
  TextEditingController _url = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _url = widget.pronoteUrl;
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoginPageTextField(_url, "URL Pronote", false, MdiIcons.link),
          SizedBox(height: screenSize.size.height / 10 * 0.4),
          CustomButtons.materialButton(context, screenSize.size.width / 5 * 2.2, null, widget.callback,
              backgroundColor: Colors.green, label: "Se connecter", textColor: Colors.white)
        ],
      ),
    );
  }
}
