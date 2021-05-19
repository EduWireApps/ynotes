import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/EcoleDirecte.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/downloadController.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/customLoader.dart';
import 'package:ynotes/ui/components/dialogs.dart';

class ReadMailBottomSheet extends StatefulWidget {
  final Mail mail;
  final int? index;

  const ReadMailBottomSheet(this.mail, this.index, {Key? key}) : super(key: key);

  @override
  _ReadMailBottomSheetState createState() => _ReadMailBottomSheetState();
}

class _ReadMailBottomSheetState extends State<ReadMailBottomSheet> {
  bool monochromatic = false;
  DateFormat format = DateFormat("dd-MM-yyyy HH:hh");

  //Get monochromatic colors or not
  @override
  Widget build(BuildContext context) {
    print(this.widget.mail.id);
    MediaQueryData screenSize = MediaQuery.of(context);
    return FutureBuilder<String?>(
        future: readMail(this.widget.mail.id ?? "", this.widget.mail.read ?? false),
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
                              IconButton(
                                onPressed: () {
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
                                        padding: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.1),
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
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 75),
                                        width: screenSize.size.width / 5 * 4.4,
                                        height: this.widget.mail.files!.length * (screenSize.size.height / 10 * 0.7),
                                        child: ListView.builder(
                                            itemCount: this.widget.mail.files!.length,
                                            itemBuilder: (BuildContext context, int index) {
                                              return Container(
                                                margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.2),
                                                child: Material(
                                                  borderRadius: BorderRadius.circular(screenSize.size.width / 5 * 0.1),
                                                  color: Color(0xff5FA9DA),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(screenSize.size.width / 5 * 0.5),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              bottom: BorderSide(width: 0, color: Colors.transparent))),
                                                      width: screenSize.size.width / 5 * 4.4,
                                                      height: screenSize.size.height / 10 * 0.7,
                                                      child: Stack(
                                                        children: <Widget>[
                                                          Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Container(
                                                              margin: EdgeInsets.only(
                                                                  left: screenSize.size.width / 5 * 0.1),
                                                              width: screenSize.size.width / 5 * 2.8,
                                                              child: ClipRRect(
                                                                child: Marquee(
                                                                    text: this
                                                                        .widget
                                                                        .mail
                                                                        .files
                                                                        .toList()[index]
                                                                        .documentName!,
                                                                    blankSpace: screenSize.size.width / 5 * 0.2,
                                                                    style: TextStyle(
                                                                        fontFamily: "Asap", color: Colors.white)),
                                                              ),
                                                            ),
                                                          ),
                                                          Positioned(
                                                            right: screenSize.size.width / 5 * 0.1,
                                                            top: screenSize.size.height / 10 * 0.11,
                                                            child: Container(
                                                              height: screenSize.size.height / 10 * 0.5,
                                                              decoration: BoxDecoration(
                                                                  color: ThemeUtils.darken(Color(0xff5FA9DA)),
                                                                  borderRadius: BorderRadius.circular(50)),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                children: <Widget>[
                                                                  ViewModelBuilder<DownloadController>.reactive(
                                                                      viewModelBuilder: () => DownloadController(),
                                                                      builder: (context, model, child) {
                                                                        return FutureBuilder(
                                                                            future: model.fileExists(this
                                                                                .widget
                                                                                .mail
                                                                                .files
                                                                                .toList()[index]
                                                                                .documentName),
                                                                            initialData: false,
                                                                            builder: (context, snapshot) {
                                                                              if (snapshot.data == false ||
                                                                                  model.isDownloading) {
                                                                                if (model.isDownloading) {
                                                                                  /// If download is in progress or connecting
                                                                                  if (model.downloadProgress == null ||
                                                                                      model.downloadProgress < 100) {
                                                                                    return Container(
                                                                                      padding: EdgeInsets.symmetric(
                                                                                        horizontal:
                                                                                            screenSize.size.width /
                                                                                                5 *
                                                                                                0.2,
                                                                                      ),
                                                                                      child: Center(
                                                                                        child: SizedBox(
                                                                                          width: screenSize.size.width /
                                                                                              5 *
                                                                                              0.3,
                                                                                          height:
                                                                                              screenSize.size.width /
                                                                                                  5 *
                                                                                                  0.3,
                                                                                          child:
                                                                                              CircularProgressIndicator(
                                                                                            backgroundColor:
                                                                                                Colors.green,
                                                                                            strokeWidth:
                                                                                                screenSize.size.width /
                                                                                                    5 *
                                                                                                    0.05,
                                                                                            value:
                                                                                                model.downloadProgress,
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  }

                                                                                  ///Download is ended
                                                                                  else {
                                                                                    return Container(
                                                                                        child: InkWell(
                                                                                      onTap: () async {
                                                                                        FileAppUtil.openFile(
                                                                                            this
                                                                                                .widget
                                                                                                .mail
                                                                                                .files
                                                                                                .toList()[index]
                                                                                                .documentName,
                                                                                            usingFileName: true);
                                                                                      },
                                                                                      //Force download
                                                                                      onLongPress: () async {
                                                                                        await model.download(this
                                                                                            .widget
                                                                                            .mail
                                                                                            .files
                                                                                            .toList()[index]);
                                                                                      },
                                                                                      child: Container(
                                                                                        width: screenSize.size.width /
                                                                                            5 *
                                                                                            0.6,
                                                                                        child: Icon(
                                                                                          MdiIcons.check,
                                                                                          color: Colors.green,
                                                                                        ),
                                                                                      ),
                                                                                    ));
                                                                                  }
                                                                                }

                                                                                ///Isn't downloading
                                                                                if (!model.isDownloading) {
                                                                                  return IconButton(
                                                                                    icon: Icon(
                                                                                      MdiIcons.fileDownloadOutline,
                                                                                      color: Colors.white,
                                                                                    ),
                                                                                    onPressed: () async {
                                                                                      await model.download(this
                                                                                          .widget
                                                                                          .mail
                                                                                          .files
                                                                                          .toList()[index]);
                                                                                    },
                                                                                  );
                                                                                }
                                                                              }

                                                                              ///If file already exists
                                                                              else {
                                                                                return Container(
                                                                                    child: InkWell(
                                                                                  onTap: () async {
                                                                                    FileAppUtil.openFile(
                                                                                            this
                                                                                            .widget
                                                                                            .mail
                                                                                            .files
                                                                                            .toList()[index]
                                                                                            .documentName,
                                                                                        usingFileName: true);
                                                                                  },
                                                                                  //Force download
                                                                                  onLongPress: () async {
                                                                                    await model.download(this
                                                                                        .widget
                                                                                        .mail
                                                                                        .files
                                                                                        .toList()[index]);
                                                                                  },
                                                                                  child: Container(
                                                                                    width:
                                                                                        screenSize.size.width / 5 * 0.6,
                                                                                    child: Icon(
                                                                                      MdiIcons.check,
                                                                                      color: Colors.green,
                                                                                    ),
                                                                                  ),
                                                                                ));
                                                                              }
                                                                              return Container();
                                                                            });
                                                                      }),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }),
                                      )
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
