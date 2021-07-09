import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ynotes/core/utils/logging_utils.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/screens/login/widgets/conditions_of_use_dialog.dart';

class LoginDialog extends StatefulWidget {
  final Future<List> connectionData;
  const LoginDialog(this.connectionData, {Key? key}) : super(key: key);
  @override
  _LoginDialogState createState() => _LoginDialogState();
  show(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return LoginDialog(connectionData);
        });
  }
}

class _LoginDialogState extends State<LoginDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 500),
          child: Container(
            padding: EdgeInsets.only(left: 5, right: 5, top: 20, bottom: 20),
            child: Column(
              children: <Widget>[
                FutureBuilder<List>(
                  future: widget.connectionData,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        snapshot.data != null &&
                        snapshot.data!.length > 0 &&
                        snapshot.data![0] == 1) {
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.pop(context);

                        openAlertBox();
                      });
                      return Column(
                        children: <Widget>[
                          Icon(
                            Icons.check_circle,
                            size: 90,
                            color: Colors.lightGreen,
                          ),
                          Text(
                            snapshot.data![1].toString(),
                            textAlign: TextAlign.center,
                          )
                        ],
                      );
                    } else if (snapshot.hasData && snapshot.data![0] == 0) {
                      CustomLogger.log("LOGIN", "Snapshot data: ${snapshot.data}");
                      return Column(
                        children: <Widget>[
                          Icon(
                            Icons.error,
                            size: 90,
                            color: Colors.redAccent,
                          ),
                          Text(
                            snapshot.data![1].toString(),
                            textAlign: TextAlign.center,
                          ),
                          if (snapshot.data!.length > 2 && snapshot.data![2] != null && snapshot.data![2].length > 0)
                            CustomButtons.materialButton(
                              context,
                              120,
                              null,
                              () async {
                                List stepCustomLogger = snapshot.data![2];
                                try {
                                  //add step logs to clip board
                                  await Clipboard.setData(new ClipboardData(text: stepCustomLogger.join("\n")));
                                  CustomDialogs.showAnyDialog(context, "Logs copiés dans le presse papier.");
                                } catch (e) {
                                  CustomDialogs.showAnyDialog(context, "Impossible de copier dans le presse papier !");
                                }
                              },
                              label: "Copier les logs",
                            )
                        ],
                      );
                    } else {
                      return Container(
                          width: 50,
                          height: 50,
                          child: CircularProgressIndicator(
                            backgroundColor: Color(0xff444A83),
                          ));
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return ConditionsOfUseDialog();
        });
  }
}
