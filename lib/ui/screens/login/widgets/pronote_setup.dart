import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/text_field.dart';

class PronoteSetupPart extends StatefulWidget {
  final Function? callback;

  const PronoteSetupPart({Key? key, this.callback}) : super(key: key);
  @override
  _PronoteSetupPartState createState() => _PronoteSetupPartState();
}

class PronoteUrlFieldPart extends StatefulWidget {
  final Function? loginCallback;
  final Function? backButton;
  final Function? onLongPressCallback;
  final TextEditingController? pronoteUrl;
  PronoteUrlFieldPart({Key? key, this.pronoteUrl, this.loginCallback, this.backButton, this.onLongPressCallback})
      : super(key: key);
  @override
  _PronoteUrlFieldPartState createState() => _PronoteUrlFieldPartState();
}

class _PronoteSetupPartState extends State<PronoteSetupPart> {
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

  _buildPronoteLoginWay(String label, String description, IconData icon, String id) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Material(
      borderRadius: BorderRadius.circular(18),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          widget.callback!(id);
        },
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            width: screenSize.size.width / 5 * 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(icon, size: 70),
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
      ),
    );
  }
}

class _PronoteUrlFieldPartState extends State<PronoteUrlFieldPart> {
  bool useEnt = false;
  TextEditingController? _url = TextEditingController();
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomTextField(_url, "URL Pronote mobile", false, MdiIcons.link, false),
          SizedBox(height: screenSize.size.height / 10 * 0.2),
          GestureDetector(
            onTap: () {
              launch("https://support.ynotes.fr/compte/se-connecter-avec-son-compte-pronote");
            },
            child: Text("Où trouver l'URL Pronote ?",
                style: TextStyle(
                  fontFamily: 'Asap',
                  color: Colors.transparent,
                  shadows: [Shadow(color: Colors.white, offset: Offset(0, -5))],
                  fontSize: 17,
                  decorationColor: Colors.white,
                  fontWeight: FontWeight.normal,
                  textBaseline: TextBaseline.alphabetic,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2,
                  decorationStyle: TextDecorationStyle.dashed,
                )),
          ),
          SizedBox(height: screenSize.size.height / 10 * 0.2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, widget.backButton,
                  backgroundColor: Colors.grey, label: "Retour", textColor: Colors.white),
              CustomButtons.materialButton(context, null, screenSize.size.height / 10 * 0.5, widget.loginCallback,
                  onLongPress: widget.onLongPressCallback,
                  backgroundColor: Colors.green,
                  label: "Se connecter",
                  textColor: Colors.white),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _url = widget.pronoteUrl;
  }
}
