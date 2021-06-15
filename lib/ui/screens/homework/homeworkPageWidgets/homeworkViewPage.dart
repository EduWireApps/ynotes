import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ynotes/core/apis/utils.dart';
import 'package:ynotes/core/logic/appConfig/controller.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/offline/data/homework/homework.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/dialogs.dart';
import 'package:ynotes/ui/components/modalBottomSheets/filesBottomSheet.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/addHomeworkDialog.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/homeworkReaderOptions.dart';

// ignore: must_be_immutable
class HomeworkDayViewPage extends StatefulWidget {
  List<Homework> homework;
  final int defaultPage;
  final bool disableGlobalRefresh;
  HomeworkDayViewPage(this.homework, {Key? key, this.defaultPage = 0, this.disableGlobalRefresh = false})
      : super(key: key);
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkDayViewPage> {
  late PageController pageView;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    String date = "(vide)";

    return Scaffold(
      appBar: new AppBar(
        title: ChangeNotifierProvider<PageController>.value(
            value: pageView,
            child: Consumer<PageController>(builder: (context, model, child) {
              if (widget.homework.isNotEmpty && widget.homework[getPageIndex(model).round()].date != null) {
                date = DateFormat("EEEE dd MMMM", "fr_FR")
                    .format(widget.homework[getPageIndex(model).round()].date!)
                    .toUpperCase();
              }
              return new Text(
                date,
                style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
              );
            })),
        systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        actions: [
          Container(
            width: screenSize.size.width / 5 * 0.6,
            child: TextButton(
                onPressed: () async {
                  await refreshSelf(force: true);
                },
                child: Icon(MdiIcons.refresh, color: ThemeUtils.textColor())),
          ),
          Container(
            width: screenSize.size.width / 5 * 0.6,
            margin: EdgeInsets.only(right: screenSize.size.width / 5 * 0.1),
            child: TextButton(
                onPressed: () async {
                  await showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25))),
                      context: context,
                      backgroundColor: Theme.of(context).primaryColor,
                      isScrollControlled: true,
                      builder: (context) {
                        return HomeworkReaderOptionsBottomSheet();
                      });
                  setState(() {});
                },
                child: Icon(MdiIcons.eyePlus, color: ThemeUtils.textColor())),
          ),
        ],
        brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: widget.homework.isEmpty
          ? buildNoHomework()
          : ChangeNotifierProvider<ApplicationSystem>.value(
              value: appSys,
              child: Consumer<ApplicationSystem>(builder: (context, model, child) {
                return Container(
                  color: pageColor(model),
                  child: Column(
                    children: [
                      ChangeNotifierProvider<PageController>.value(
                        value: pageView,
                        child: Consumer<PageController>(builder: (context, model, child) {
                          return FutureBuilder<Color>(
                              future: getBackgroundColor(getPageIndex(model)),
                              builder: (context, snapshot) {
                                return buildHeader(
                                    widget.homework[getPageIndex(model).round()],
                                    ThemeUtils.isThemeDark
                                        ? (snapshot.data ?? Colors.white).withOpacity(0.4)
                                        : (snapshot.data ?? Colors.white),
                                    ((model.hasClients) ? (model.page ?? 0) : 0).round());
                              });
                        }),
                      ),
                      Expanded(
                          child: PageView.builder(
                              controller: pageView,
                              itemCount: widget.homework.length,
                              itemBuilder: (context, index) {
                                return buildPage(widget.homework[index]);
                              })),
                    ],
                  ),
                );
              }),
            ),
    );
  }

  buildButtons(Homework hw, Color color) {
    var screenSize = MediaQuery.of(context);
    return Container(
      color: pageColor(appSys),
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButtons.materialButton(context, 45, 45, () async {
                setState(() {
                  hw.done = !(hw.done ?? false);
                });
                await HomeworkOffline(appSys.offline).updateSingleHW(hw);
              },
                  padding: EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(11),
                  backgroundColor: (hw.done ?? false) ? Colors.green : color,
                  icon: MdiIcons.check,
                  iconColor: ThemeUtils.textColor()),
              CustomButtons.materialButton(context, 45, 45, () async {
                setState(() {
                  hw.pinned = !(hw.pinned ?? false);
                });
                await HomeworkOffline(appSys.offline).updateSingleHW(hw);
              },
                  padding: EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(11),
                  backgroundColor: (hw.pinned ?? false) ? Colors.green : color,
                  icon: MdiIcons.pin,
                  iconColor: ThemeUtils.textColor()),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: (hw.files.toList()).length > 0
                      ? Container(
                          key: ValueKey<int>(0),
                          child: CustomButtons.materialButton(context, 45, 45, () async {
                            await refreshSelf();
                            showFilesModalBottomSheet(context, hw.files.toList());
                          },
                              borderRadius: BorderRadius.circular(11),
                              backgroundColor: color,
                              icon: MdiIcons.fileDocumentMultipleOutline,
                              iconColor: ThemeUtils.textColor()),
                        )
                      : Container()),
              CustomButtons.materialButton(context, 45, 45, () async {
                await CustomDialogs.showHomeworkDetailsDialog(context, hw);
                setState(() {});
              },
                  padding: EdgeInsets.all(5),
                  borderRadius: BorderRadius.circular(11),
                  backgroundColor: color,
                  icon: MdiIcons.shareVariantOutline,
                  iconColor: ThemeUtils.textColor()),
              if (hw.editable)
                CustomButtons.materialButton(context, 45, 45, () async {
                  Homework? temp = await showAddHomeworkBottomSheet(context, hw: hw);
                  if (temp != null) {
                    await HomeworkOffline(appSys.offline).updateSingleHW(temp);
                  }
                  await refreshSelf();
                  setState(() {});
                },
                    borderRadius: BorderRadius.circular(11),
                    backgroundColor: color,
                    icon: MdiIcons.pencil,
                    padding: EdgeInsets.all(5),
                    iconColor: ThemeUtils.textColor()),
              if (hw.editable)
                CustomButtons.materialButton(context, 45, 45, () async {
                  await hw.delete();
                  await refreshSelf();

                  setState(() {});
                },
                    padding: EdgeInsets.all(5),
                    borderRadius: BorderRadius.circular(11),
                    backgroundColor: color,
                    icon: MdiIcons.trashCan,
                    iconColor: ThemeUtils.textColor()),
              if (hw.toReturn ?? false)
                Expanded(
                  child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: (hw.toReturn ?? false)
                          ? Expanded(
                              child: CustomButtons.materialButton(
                                context,
                                null,
                                45,
                                () {
                                  CustomDialogs.showUnimplementedSnackBar(context);
                                },
                                backgroundColor: color,
                                label: "RENDRE MON DEVOIR",
                                icon: MdiIcons.fileMoveOutline,
                                borderRadius: BorderRadius.circular(11),
                                padding:
                                    EdgeInsets.symmetric(horizontal: 5, vertical: screenSize.size.height / 10 * 0.12),
                                textStyle: TextStyle(
                                    fontFamily: "Asap", fontWeight: FontWeight.w600, color: ThemeUtils.textColor()),
                              ),
                            )
                          : Container()),
                ),
            ],
          ),
        ],
      ),
    );
  }

  buildHeader(Homework hw, Color color, int page) {
    var screenSize = MediaQuery.of(context);

    return Column(
      children: [
        Container(
            height: screenSize.size.height / 10 * 0.8,
            color: color,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Visibility(
                  visible: page != 0,
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  child: IconButton(
                      icon: Icon(
                        MdiIcons.chevronLeft,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        pageView.previousPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      }),
                ),
                Expanded(
                    child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 11,
                      child: AutoSizeText(hw.discipline ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "Asap", color: Colors.white)),
                    ),
                    if (hw.teacherName != null && hw.teacherName != "")
                      Flexible(
                        flex: 9,
                        child: AutoSizeText(
                          hw.teacherName?.trimLeft() ?? "",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontFamily: "Asap", color: Colors.white60),
                        ),
                      ),
                  ],
                )),
                Visibility(
                  visible: page != widget.homework.length - 1,
                  maintainAnimation: true,
                  maintainState: true,
                  maintainSize: true,
                  child: IconButton(
                      icon: Icon(
                        MdiIcons.chevronRight,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        pageView.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeIn);
                      }),
                )
              ],
            )),
        buildButtons(hw, color),
      ],
    );
  }

  Widget buildNoHomework() {
    var screenSize = MediaQuery.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: screenSize.size.height / 10 * 7.5,
            width: screenSize.size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(fit: BoxFit.fitWidth, image: AssetImage('assets/images/noHomework.png')),
                Text(
                  "Pas de devoirs pour cette journée.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Asap",
                    color: ThemeUtils.textColor(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  buildPage(Homework hw) {
    var screenSize = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ChangeNotifierProvider<ApplicationSystem>.value(
            value: appSys,
            child: Consumer<ApplicationSystem>(builder: (context, model, child) {
              return Container(
                  color: pageColor(appSys),
                  padding: EdgeInsets.symmetric(
                      vertical: screenSize.size.height / 10 * 0.2, horizontal: screenSize.size.width / 5 * 0.3),
                  child: buildText(hw));
            }),
          ),
        ],
      ),
    );
  }

  buildText(Homework hw) {
    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (context, model, child) {
        return HtmlWidget(htmlColors(linkify(hw.rawContent ?? "")),
            textStyle: TextStyle(
                color: ThemeUtils.textColor(),
                fontFamily: "Asap",
                fontSize: (model.settings!["user"]["homeworkPage"]["fontSize"] ?? 11).toDouble(),
                backgroundColor: Colors.transparent),
            customStylesBuilder: (element) {
              if (element.attributes['style'] != null && element.attributes['style']!.contains("background")) {
                element.attributes['style'] = "";
                if (ThemeUtils.isThemeDark) {
                  return {'background': '#CF7545', 'color': 'white'};
                } else {
                  return {'background': '#F9DDA7', 'color': 'black'};
                }
              }
              return null;
            },
            hyperlinkColor: Colors.blueAccent,
            customWidgetBuilder: (element) {
              if (element.attributes['class'] == 'math-tex') {
                try {
                  return Container(
                      child: TeXView(
                    child: TeXViewDocument(element.text,
                        style: TeXViewStyle.fromCSS(
                            """background-color: #${(ThemeUtils.isThemeDark ? ThemeUtils.darken(Theme.of(context).primaryColorDark, forceAmount: 0.1) : ThemeUtils.darken(Theme.of(context).primaryColor, forceAmount: 0.03)).toCSSColor()}; color: #${ThemeUtils.textColor().toCSSColor()}""")),
                  ));
                } catch (e) {
                  return Container();
                }
              }

              return null;
            },
            onTapUrl: (url) async {
              if (await canLaunch(url)) {
                await launch(url);
              } else {
                throw "Unable to launch url";
              }
            });
      }),
    );
  }

//Get monochromatic colors or not
  Future<Color> getBackgroundColor(double offset) async {
    if (offset.toInt() + 1 < widget.homework.length) {
      //Current background color
      Color? current = widget.homework[offset.toInt()].editable
          ? Color(0xff7DD3FC)
          : Color(await getColor(widget.homework[offset.toInt()].disciplineCode));
      Color? next = widget.homework[offset.toInt() + 1].editable
          ? Color(0xff7DD3FC)
          : Color(await getColor(widget.homework[offset.toInt() + 1].disciplineCode));

      return Color.lerp(current, next, offset - offset.toInt()) ?? Colors.white;
    } else {
      return widget.homework.last.editable
          ? Color(0xff7DD3FC)
          : Color(await getColor(widget.homework.last.disciplineCode));
    }
  }

  double getPageIndex(PageController model) {
    if ((((model.hasClients) ? (model.page ?? widget.defaultPage) : widget.defaultPage) + 1) <=
        (widget.homework.length)) {
      return ((model.hasClients) ? (model.page ?? widget.defaultPage) : widget.defaultPage).toDouble();
    } else {
      return (widget.homework.length - 1).toDouble();
    }
  }

  htmlColors(String? html) {
    if (!(appSys.settings!["user"]["homeworkPage"]["forceMonochromeContent"] ?? true)) {
      return html;
    }
    String color = ThemeUtils.isThemeDark ? "white" : "black";
    String finalHTML = html!.replaceAll("color", color);
    return finalHTML;
  }

  @override
  void initState() {
    super.initState();
    pageView = PageController(initialPage: widget.defaultPage);
    refreshSelf();
  }

  pageColor(ApplicationSystem _appSys) {
    if (_appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] == null ||
        _appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] == 0 ||
        ThemeUtils.isThemeDark && _appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] == 2) {
      return Theme.of(context).primaryColorDark;
    }
    if (_appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] == 1) {
      return ThemeUtils.textColor(revert: true);
    }
    if (_appSys.settings!["user"]["homeworkPage"]["pageColorVariant"] == 2) {
      return Color(0xfff2e7bf);
    }
  }

  Future<void> refreshSelf({bool force = false}) async {
    List<Homework>? hw =
        await appSys.api?.getHomeworkFor(widget.homework[getPageIndex(pageView).round()].date, forceReload: force);
    if (widget.homework[getPageIndex(pageView).round()].date != null && hw != null) {
      if (!widget.disableGlobalRefresh &&
          hw.where((element) => element.id == widget.homework[getPageIndex(pageView).round()].id).isNotEmpty) {
        widget.homework[getPageIndex(pageView).round()] =
            hw.firstWhere((element) => element.id == widget.homework[getPageIndex(pageView).round()].id);
      } else {
        widget.homework = hw;
      }

      setState(() {});
    }
  }
}
