import 'package:flutter/material.dart';
import 'package:ynotes/core/utils/file_utils.dart';
import 'package:ynotes/core/utils/logging_utils.dart';

class ConditionsOfUseDialog extends StatefulWidget {
  const ConditionsOfUseDialog({
    Key? key,
  }) : super(key: key);

  @override
  _ConditionsOfUseDialogState createState() => _ConditionsOfUseDialogState();
}

class _ConditionsOfUseDialogState extends State<ConditionsOfUseDialog> {
  ScrollController scrollViewController = ScrollController();
  var offset = -4000.0;
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: Container(
        height: screenSize.size.height / 10 * 6,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                controller: scrollViewController,
                child: Container(
                  width: screenSize.size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Conditions d’utilisation",
                          style: TextStyle(fontSize: 24, fontFamily: "Asap", fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Divider(
                        color: Colors.grey,
                        height: 4.0,
                      ),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10),
                          child: SingleChildScrollView(
                              child: Container(
                            child: FutureBuilder(
                                //Read the TOS file
                                future: FileAppUtil.loadAsset("assets/documents/TOS_fr.txt"),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    CustomLogger.log("LOGIN", "An error occured while getting the TOS");
                                    CustomLogger.error(snapshot.error);
                                  }
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      fontFamily: "Asap",
                                    ),
                                    textAlign: TextAlign.left,
                                  );
                                }),
                          ))),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.only(left: 60, right: 60, top: 15, bottom: 18),
                          primary: Color(0xff27AE60),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0), bottomRight: Radius.circular(32.0)),
                          ),
                        ),
                        onPressed: () async {
                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, "/intro");
                        },
                        child: Text(
                          "J'accepte",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible:
                    (offset - (scrollViewController.hasClients ? scrollViewController.position.maxScrollExtent : 0) <
                        -45),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
                    child: FloatingActionButton(
                      onPressed: () {
                        scrollViewController.animateTo(scrollViewController.position.maxScrollExtent,
                            duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      },
                      child: RotatedBox(quarterTurns: 3, child: Icon(Icons.chevron_left)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    scrollViewController.addListener(() {
      setState(() {
        offset = scrollViewController.offset;
      });
    });
  }
}
