import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/core/utils/theme_utils.dart';

class AuthorizationsDialog extends StatefulWidget {
  final String? authName;
  final String? goal;
  const AuthorizationsDialog({Key? key, this.authName, this.goal}) : super(key: key);
  @override
  _AuthorizationsDialogState createState() => _AuthorizationsDialogState();
}

class _AuthorizationsDialogState extends State<AuthorizationsDialog> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize;
    screenSize = MediaQuery.of(context);
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Theme.of(context).primaryColorDark,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      contentPadding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
      content: Container(
        padding: EdgeInsets.all(screenSize.size.width / 5 * 0.1),
        width: screenSize.size.width / 5 * 4.4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                color: Theme.of(context).primaryColorDark,
              ),
              width: screenSize.size.width / 5 * 4.7,
              child: Column(
                children: [
                  Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.12),
                      ),
                      padding: EdgeInsets.all(screenSize.size.height / 10 * 0.1),
                      child: Transform.rotate(
                        angle: -0.1,
                        child: Transform.translate(
                          offset: Offset(screenSize.size.width / 5 * 0.05, 0),
                          child: Icon(
                            MdiIcons.handBackRight,
                            size: screenSize.size.width / 5 * 1.1,
                            color: Colors.blueGrey,
                          ),
                        ),
                      )),
                  Container(
                    margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                    width: screenSize.size.width / 5 * 4.4,
                    child: AutoSizeText.rich(
                      TextSpan(
                        text: "Autorisez yNotes à accéder à ",
                        children: <TextSpan>[
                          TextSpan(text: widget.authName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          const TextSpan(text: " pour que l'application fonctionne correctement."),
                        ],
                      ),
                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                    decoration:
                        BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(11)),
                    width: screenSize.size.width / 5 * 4.4,
                    child: AutoSizeText.rich(
                      TextSpan(
                        children: <TextSpan>[
                          const TextSpan(text: "Pour quoi faire ?", style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: "\n" + widget.goal!),
                        ],
                      ),
                      style: TextStyle(color: ThemeUtils.textColor(), fontFamily: "Asap"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                      width: screenSize.size.width / 5 * 4.4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.red,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text(
                              'Je refuse',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: screenSize.size.width / 5 * 0.1,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.green,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
                            ),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text(
                              "Donner l'accès",
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
