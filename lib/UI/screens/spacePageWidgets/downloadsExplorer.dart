import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/UI/components/dialogs.dart';

import '../../../usefulMethods.dart';

class DownloadsExplorer extends StatefulWidget {
  @override
  _DownloadsExplorerState createState() => _DownloadsExplorerState();
}

class _DownloadsExplorerState extends State<DownloadsExplorer> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return Container(
      margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: Theme.of(context).primaryColor,
      ),
      width: screenSize.size.width / 5 * 4.5,
      child: Column(
        children: <Widget>[
          Container(
              width: screenSize.size.width / 5 * 4.5,
              margin: EdgeInsets.all(screenSize.size.width / 5 * 0.2),
              child: Text(
                "Mes documents",
                style: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.bold,
                    color: isDarkModeEnabled ? Colors.white : Colors.black),
                textAlign: TextAlign.left,
              )),
            
          Container( width: screenSize.size.width / 5 * 4.4,
          height: screenSize.size.height/10*0.4,
          
          child:   Row(children: <Widget>[

              ],),
          ),

          ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: FutureBuilder(
              future: getListOfFiles(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.length != 0) {
                    List<FileInfo> listFiles = snapshot.data;
                    return Container(
                      height: screenSize.size.height / 10 * 3.7,
                      child: ListView.builder(
                        padding: EdgeInsets.all(0.0),
                        itemCount: listFiles.length,
                        itemBuilder: (context, index) {
                          final item = listFiles[index].fileName;
                          return Dismissible(
                            direction: DismissDirection.startToEnd,
                            background: Container(color: Colors.red),
                            confirmDismiss: (direction) async {
                              setState(() {});
                              return await CustomDialogs.showConfirmationDialog(
                                      context, listFiles[index].file, null) ==
                                  true;
                            },
                            onDismissed: (direction) async {
                              await FileAppUtil.remove(listFiles[index].file);
                              setState(() {
                                listFiles.removeAt(index);
                              });
                            },
                            key: Key(item),
                            child: Container(
                              child: Column(
                                children: <Widget>[
                                  ConstrainedBox(
                                    constraints: new BoxConstraints(
                                      minHeight: screenSize.size.height / 10 * 0.8,
                                    ),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          bottom: (screenSize.size.height / 10 * 0.008)),
                                      child: Material(
                                        color: Theme.of(context).primaryColorDark,
                                        child: InkWell(
                                          splashColor: Color(0xff525252),
                                          onTap: () {
                                            openFile(listFiles[index].fileName);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: screenSize.size.width / 5 * 0.25,
                                                vertical: screenSize.size.height / 10 * 0.2),
                                            child: Column(
                                              children: <Widget>[
                                                Stack(
                                                  children: <Widget>[
                                                    Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        snapshot.data[index].fileName,
                                                        style: TextStyle(
                                                            fontFamily: "Asap",
                                                            fontSize:
                                                                screenSize.size.height / 10 * 0.2,
                                                            color: isDarkModeEnabled
                                                                ? Colors.white
                                                                : Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    DateFormat("yyyy-MM-dd HH:mm").format(
                                                        snapshot.data[index].lastModifiedDate),
                                                    style: TextStyle(
                                                        fontFamily: "Asap",
                                                        fontSize: screenSize.size.height / 10 * 0.2,
                                                        color: isDarkModeEnabled
                                                            ? Colors.white.withOpacity(0.5)
                                                            : Colors.black.withOpacity(0.5)),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Container(
                      height: screenSize.size.height / 10 * 3.7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            MdiIcons.downloadOffOutline,
                            color: isDarkModeEnabled ? Colors.white : Colors.black,
                            size: screenSize.size.width / 5 * 1.5,
                          ),
                          Text(
                            "Aucun téléchargement.",
                            style: TextStyle(
                                fontFamily: "Asap",
                                color: isDarkModeEnabled ? Colors.white : Colors.black,
                                fontSize: 15),
                          )
                        ],
                      ),
                    );
                  }
                } else {
                  return SpinKitFadingFour(
                    color: Theme.of(context).primaryColorDark,
                    size: screenSize.size.width / 5 * 1,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
