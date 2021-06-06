import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/customLoader.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/filesBottomSheet.dart';

class ReadMailBottomSheet extends StatefulWidget {
  final Mail mail;

  const ReadMailBottomSheet(this.mail, {Key? key}) : super(key: key);

  @override
  _ReadMailBottomSheetState createState() => _ReadMailBottomSheetState();
}

class _ReadMailBottomSheetState extends State<ReadMailBottomSheet> {
  bool monochromatic = false;
  DateFormat format = DateFormat("dd-MM-yyyy HH:hh");

  @override
  Widget build(BuildContext context) {
    print(this.widget.mail.id);
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<String?>(
        future: getMail(),
        builder: (context, snapshot) {
          return Container(
              height: screenSize.size.height,
              padding: EdgeInsets.all(0),
              child: new Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
                    width: screenSize.size.width,
                    height: screenSize.size.height / 10 * 1.0,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(MdiIcons.arrowLeft, color: ThemeUtils.textColor()),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (this.widget.mail.files.toList().length > 0)
                                IconButton(
                                  onPressed: () async {
                                    showFilesModalBottomSheet(context, this.widget.mail.files.toList());
                                  },
                                  icon: Icon(MdiIcons.file),
                                  color: ThemeUtils.textColor(),
                                ),
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    monochromatic = !monochromatic;
                                  });
                                },
                                icon: Icon((monochromatic ? MdiIcons.eye : MdiIcons.eyeOutline),
                                    color: ThemeUtils.textColor()),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: screenSize.size.height / 10 * (8.8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: screenSize.size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: screenSize.size.width / 5 * 0.2,
                                vertical: screenSize.size.height / 10 * 0.2),
                            child: AutoSizeText(
                              this.widget.mail.subject != "" ? this.widget.mail.subject ?? "" : "(Sans sujet)",
                              maxLines: 100,
                              style: TextStyle(
                                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold),
                              minFontSize: 18,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            height: screenSize.size.height / 10 * 0.8,
                            width: screenSize.size.width,
                            child: Row(
                              children: [
                                Container(
                                    margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                    width: screenSize.size.width / 5 * 0.8,
                                    child: CircleAvatar(
                                      child: Text(
                                        this.widget.mail.from?["name"][0] ?? "",
                                        style: TextStyle(
                                            fontFamily: "Asap",
                                            color: ThemeUtils.textColor(),
                                            fontWeight: FontWeight.bold),
                                      ),
                                      maxRadius: screenSize.size.width / 5 * 0.8,
                                    )),
                                Container(
                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                  width: screenSize.size.width / 5 * 3.4,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        spacing: screenSize.size.width / 5 * 0.1,
                                        children: [
                                          Text(
                                            this.widget.mail.from?["name"] ?? "",
                                            style: TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            format.format(DateTime.parse(widget.mail.date!)),
                                            style: TextStyle(
                                                fontFamily: "Asap",
                                                color: ThemeUtils.isThemeDark
                                                    ? Colors.white.withOpacity(0.5)
                                                    : Colors.black.withOpacity(0.5)),
                                          ),
                                        ],
                                      ),
                                      if ((this.widget.mail.to ?? []).isNotEmpty)
                                        Text(
                                          this.widget.mail.to![0]?["name"] ?? "",
                                          style: TextStyle(
                                              fontFamily: "Asap",
                                              color: ThemeUtils.isThemeDark
                                                  ? Colors.white.withOpacity(0.5)
                                                  : Colors.black.withOpacity(0.5)),
                                        )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                  width: screenSize.size.width / 5 * 0.5,
                                  child: IconButton(
                                    icon: Icon(MdiIcons.undoVariant, color: ThemeUtils.textColor()),
                                    onPressed: () async {
                                      await CustomDialogs.writeModalBottomSheet(context,
                                          defaultSubject: this.widget.mail.subject,
                                          defaultListRecipients: recipientFromMap());
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: screenSize.size.width,
                            child: (snapshot.hasData)
                                ? Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: screenSize.size.width / 5 * 0.1,
                                            vertical: screenSize.size.height / 10 * 0.2),
                                        child: HtmlWidget(
                                          htmlColors(snapshot.data),
                                          hyperlinkColor: Colors.blue.shade300,
                                          onTapUrl: (url) async {
                                            if (await canLaunch(url)) {
                                              await launch(url);
                                            } else {
                                              throw "Unable to launch url";
                                            }
                                          },
                                          textStyle: TextStyle(color: ThemeUtils.textColor()),
                                        ),
                                      ),
                                      if (this.widget.mail.files.toList().length > 0)
                                        CustomButtons.materialButton(context, null, null, () {
                                          showFilesModalBottomSheet(context, this.widget.mail.files.toList());
                                        },
                                            label: this.widget.mail.files.toList().length.toString() +
                                                " pièce" +
                                                (this.widget.mail.files.toList().length > 1 ? "s" : "") +
                                                " jointe" +
                                                (this.widget.mail.files.toList().length > 1 ? "s" : ""),
                                            icon: MdiIcons.file),
                                    ],
                                  )
                                : Center(
                                    child: CustomLoader(screenSize.size.width / 5 * 2.5,
                                        screenSize.size.width / 5 * 2.5, Theme.of(context).primaryColorDark),
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ));
        });
  }

  //Get monochromatic colors or not
  ///TO DO PUT IT IN A CONTROLLER
  Future<String?> getMail() async {
    if (widget.mail.content != null && widget.mail.content != "") {
      return widget.mail.content;
    } else {
      return await (appSys.api as APIEcoleDirecte)
          .readMail(widget.mail.id ?? "", true, widget.mail.mtype == "received");
    }
  }

  htmlColors(String? html) {
    if (!monochromatic) {
      return html;
    }
    String color = ThemeUtils.isThemeDark ? "white" : "black";
    String finalHTML = html!.replaceAll("color", color);
    return finalHTML;
  }

  recipientFromMap() {
    return [
      Recipient(
          this.widget.mail.from?["prenom"],
          this.widget.mail.from?["nom"],
          this.widget.mail.from?["id"].toString(),
          this.widget.mail.from?["type"] == "P",
          this.widget.mail.from?["matiere"])
    ];
  }
}
