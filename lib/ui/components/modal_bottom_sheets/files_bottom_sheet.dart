import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_ns/liquid_progress_indicator.dart';
import 'package:marquee/marquee.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/shared/downloadController.dart';
import 'package:ynotes/core/utils/fileUtils.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/column_generator.dart';
import 'package:ynotes/ui/components/modal_bottom_sheets/drag_handle.dart';

void showFilesModalBottomSheet(context, List<Document> files) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return FilesBottomSheet(files);
      });
}

class FilesBottomSheet extends StatefulWidget {
  final List<Document> documents;

  const FilesBottomSheet(this.documents, {Key? key}) : super(key: key);
  @override
  _FilesBottomSheetState createState() => _FilesBottomSheetState();
}

class _FilesBottomSheetState extends State<FilesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);

    return ConstrainedBox(
      constraints:
          BoxConstraints(minHeight: screenSize.size.height / 10 * 1.7, maxHeight: screenSize.size.height / 10 * 4.2),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.2),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DragHandle(),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Text(
              "Téléchargements",
              style: TextStyle(
                  fontFamily: "Asap", color: ThemeUtils.textColor(), fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.1,
            ),
            Flexible(
              child: SingleChildScrollView(
                child: ColumnBuilder(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    itemCount: widget.documents.length,
                    itemBuilder: (context, index) {
                      return buildFileItem(widget.documents[index]);
                    }),
              ),
            ),
            SizedBox(
              height: screenSize.size.height / 10 * 0.3,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBackground(DownloadController model, Document document, {Widget? child}) {
    MediaQueryData screenSize = MediaQuery.of(context);
    print(model.isDownloading);
    if (model.isDownloading) {
      return FutureBuilder<Color>(
          future: getFileItemColor(model, document),
          builder: (context, snapshot) {
            return Container(
              height: screenSize.size.height / 10 * 0.5,
              width: screenSize.size.width / 5 * 4.8,
              margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
              child: LiquidLinearProgressIndicator(
                  value: model.downloadProgress ?? 0.0, // Defaults to 0.5.
                  valueColor: AlwaysStoppedAnimation(Color(0xff27AE60)), // Defaults to the current Theme's accentColor.
                  backgroundColor: ThemeUtils.isThemeDark
                      ? lightTheme.primaryColorDark
                      : darkTheme.primaryColorDark, // Defaults to the current Theme's backgroundColor.
                  borderColor: Colors.transparent,
                  borderWidth: 0,
                  borderRadius:
                      5, // The direction the liquid moves (Axis.vertical = bottom to top, Axis.horizontal = left to right). Defaults to Axis.horizontal.
                  center: child),
            );
          });
    } else {
      return FutureBuilder<Color>(
          future: getFileItemColor(model, document),
          builder: (context, snapshot) {
            return Container(
              margin: EdgeInsets.only(bottom: screenSize.size.height / 10 * 0.1),
              child: Material(
                  color: snapshot.data ??
                      (ThemeUtils.isThemeDark ? lightTheme.primaryColorDark : darkTheme.primaryColorDark),
                  borderRadius: BorderRadius.circular(5),
                  child: InkWell(
                      borderRadius: BorderRadius.circular(5),
                      onTap: () async {
                        if (await model.fileExists(document.documentName)) {
                          await FileAppUtil.openFile(document.documentName, usingFileName: true);
                        } else {
                          await model.download(document);
                        }
                      },
                      child: child)),
            );
          });
    }
  }

  Widget buildFileItem(Document document) {
    MediaQueryData screenSize = MediaQuery.of(context);
    return ViewModelBuilder<DownloadController>.reactive(
        viewModelBuilder: () => DownloadController(),
        builder: (context, model, child) {
          return buildBackground(model, document,
              child: Container(
                width: screenSize.size.width / 5 * 4.8,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.transparent),
                height: screenSize.size.height / 10 * 0.5,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: screenSize.size.width / 5 * 0.1, right: screenSize.size.width / 5 * 0.1),
                          child: AutoSizeText(
                            document.documentName ?? "",
                            style: TextStyle(
                              fontFamily: "Asap",
                              color: ThemeUtils.textColor(revert: true),
                            ),
                            overflowReplacement: Marquee(
                              text: document.documentName ?? "",
                              style: TextStyle(
                                fontFamily: "Asap",
                                color: ThemeUtils.textColor(revert: true),
                              ),
                            ),
                          )),
                    ),
                    FutureBuilder<List>(
                        future: getIconColors(model, document),
                        builder: (context, snapshot) {
                          return Container(
                            width: screenSize.size.width / 5 * 0.5,
                            height: screenSize.size.height / 10 * 0.4,
                            decoration: BoxDecoration(
                                color: snapshot.data?[0] ??
                                    (ThemeUtils.isThemeDark ? lightTheme.primaryColorDark : darkTheme.primaryColorDark),
                                borderRadius: BorderRadius.circular(5)),
                            margin: EdgeInsets.symmetric(horizontal: screenSize.size.width / 5 * 0.05),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(snapshot.data?[2] ?? MdiIcons.cloudDownload),
                              onPressed: () async {
                                if (await model.fileExists(document.documentName)) {
                                  await FileAppUtil.openFile(document.documentName, usingFileName: true);
                                } else {
                                  await model.download(document);
                                }
                              },
                              color: snapshot.data?[1] ?? (ThemeUtils.textColor(revert: true)),
                            ),
                          );
                        })
                  ],
                ),
              ));
        });
  }

  Future<Color> getFileItemColor(DownloadController model, Document document) async {
    if (await model.fileExists(document.documentName)) {
      return Color(0xff27AE60);
    } else {
      return ThemeUtils.isThemeDark ? lightTheme.primaryColorDark : darkTheme.primaryColorDark;
    }
  }

  Future<List> getIconColors(DownloadController model, Document document) async {
    if (await model.fileExists(document.documentName)) {
      return [ThemeUtils.textColor(revert: true), Color(0xff27AE60), MdiIcons.eye];
    } else if (model.hasError) {
      return [Colors.red, ThemeUtils.textColor(revert: true), MdiIcons.fileAlert];
    } else {
      return [
        ThemeUtils.isThemeDark ? lightTheme.primaryColor : darkTheme.primaryColor,
        ThemeUtils.textColor(revert: true),
        MdiIcons.cloudDownload
      ];
    }
  }
}
