import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/ecole_directe.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/utils/logging_utils/logging_utils.dart';
import 'package:ynotes/core/utils/theme_utils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/custom_loader.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/files_bottom_sheet.dart';
import 'package:ynotes/ui/mixins/layout_mixin.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';

class ReadMailBottomSheet extends StatefulWidget {
  final Mail mail;

  const ReadMailBottomSheet(this.mail, {Key? key}) : super(key: key);

  @override
  _ReadMailBottomSheetState createState() => _ReadMailBottomSheetState();
}

class _ReadMailBottomSheetState extends State<ReadMailBottomSheet> with LayoutMixin {
  bool monochromatic = false;
  DateFormat format = DateFormat("dd-MM-yyyy HH:hh");

  @override
  Widget build(BuildContext context) {
    CustomLogger.log("BOTTOM SHEET", "(Read mail) Mail id: ${widget.mail.id}");
    MediaQueryData screenSize = MediaQuery.of(context);
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                color: Theme.of(context).primaryColor),
            child: FutureBuilder<String?>(
                future: getMail(),
                builder: (context, snapshot) {
                  return Container(
                      padding: const EdgeInsets.all(0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
                                      if (widget.mail.files.toList().isNotEmpty)
                                        IconButton(
                                          onPressed: () async {
                                            showFilesModalBottomSheet(context, widget.mail.files.toList());
                                          },
                                          icon: const Icon(MdiIcons.file),
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
                          SizedBox(
                            height:
                                isLargeScreen ? screenSize.size.height / 10 * 5.5 : screenSize.size.height / 10 * (8.8),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: screenSize.size.width / 5 * 0.2,
                                        vertical: screenSize.size.height / 10 * 0.2),
                                    child: AutoSizeText(
                                      widget.mail.subject != "" ? widget.mail.subject ?? "" : "(Sans sujet)",
                                      maxLines: 100,
                                      style: TextStyle(
                                          fontFamily: "Asap",
                                          color: ThemeUtils.textColor(),
                                          fontWeight: FontWeight.bold),
                                      minFontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(
                                    height: screenSize.size.height / 10 * 0.8,
                                    child: Row(
                                      children: [
                                        Container(
                                            margin: const EdgeInsets.only(left: 15),
                                            width: 90,
                                            child: CircleAvatar(
                                              child: Text(
                                                widget.mail.from?["name"][0] ?? "",
                                                style: TextStyle(
                                                    fontFamily: "Asap",
                                                    color: ThemeUtils.textColor(),
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              maxRadius: screenSize.size.width / 5 * 0.8,
                                            )),
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 15),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Wrap(
                                                  spacing: screenSize.size.width / 5 * 0.1,
                                                  children: [
                                                    Text(
                                                      widget.mail.from?["name"] ?? "",
                                                      style:
                                                          TextStyle(fontFamily: "Asap", color: ThemeUtils.textColor()),
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
                                                if ((widget.mail.to ?? []).isNotEmpty)
                                                  Text(
                                                    widget.mail.to![0]?["name"] ?? "",
                                                    style: TextStyle(
                                                        fontFamily: "Asap",
                                                        color: ThemeUtils.isThemeDark
                                                            ? Colors.white.withOpacity(0.5)
                                                            : Colors.black.withOpacity(0.5)),
                                                  )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: screenSize.size.width / 5 * 0.1),
                                          width: screenSize.size.width / 5 * 0.5,
                                          child: IconButton(
                                            icon: Icon(MdiIcons.undoVariant, color: ThemeUtils.textColor()),
                                            onPressed: () async {
                                              await CustomDialogs.writeModalBottomSheet(context,
                                                  defaultSubject: widget.mail.subject,
                                                  defaultListRecipients: recipientFromMap());
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
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
                                                  //hyperlinkColor: Colors.blue.shade300,
                                                  onTapUrl: (url) async {
                                                    if (await canLaunch(url)) {
                                                      await launch(url);
                                                      return true;
                                                    } else {
                                                      return false;
                                                    }
                                                  },
                                                  textStyle: TextStyle(color: ThemeUtils.textColor()),
                                                ),
                                              ),
                                              if (widget.mail.files.toList().isNotEmpty)
                                                YButton(
                                                    onPressed: () =>
                                                        showFilesModalBottomSheet(context, widget.mail.files.toList()),
                                                    text: widget.mail.files.toList().length.toString() +
                                                        " pièce" +
                                                        (widget.mail.files.toList().length > 1 ? "s" : "") +
                                                        " jointe" +
                                                        (widget.mail.files.toList().length > 1 ? "s" : ""),
                                                    icon: MdiIcons.file,
                                                    color: YColor.secondary),
                                            ],
                                          )
                                        : Center(
                                            child: CustomLoader(screenSize.size.height / 10 * 2.5,
                                                screenSize.size.width / 5 * 2.5, Theme.of(context).primaryColorDark),
                                          ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ));
                }),
          ),
        ),
      ],
    );
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
      Recipient(widget.mail.from?["prenom"], widget.mail.from?["nom"], widget.mail.from?["id"].toString(),
          widget.mail.from?["type"] == "P", widget.mail.from?["matiere"])
    ];
  }
}
