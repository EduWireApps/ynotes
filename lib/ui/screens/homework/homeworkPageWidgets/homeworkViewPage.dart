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
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/screens/homework/homeworkPageWidgets/homeworkReaderOptions.dart';

class HomeworkDayViewPage extends StatefulWidget {
  final List<Homework> homework;
  final int defaultPage;
  const HomeworkDayViewPage(this.homework, {Key? key, this.defaultPage = 0}) : super(key: key);
  @override
  _HomeworkPageState createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkDayViewPage> {
  late PageController pageView;
  @override
  Widget build(BuildContext context) {
    String date = "Pas de date !";

    if (widget.homework.first.date != null) {
      date = DateFormat("EEEE dd MMMM", "fr_FR").format(widget.homework.first.date!).toUpperCase();
    }
    return ChangeNotifierProvider<ApplicationSystem>.value(
      value: appSys,
      child: Consumer<ApplicationSystem>(builder: (context, model, child) {
        return Scaffold(
          backgroundColor: pageColor(model),
          appBar: new AppBar(
            title: new Text(
              date,
              style: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.bold),
            ),
            systemOverlayStyle: ThemeUtils.isThemeDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
            brightness: ThemeUtils.isThemeDark ? Brightness.dark : Brightness.light,
            backgroundColor: Theme.of(context).primaryColor,
          ),
          body: Column(
            children: [
              ChangeNotifierProvider<PageController>.value(
                value: pageView,
                child: Consumer<PageController>(builder: (context, model, child) {
                  return FutureBuilder<Color>(
                      future: getBackgroundColor(((model.hasClients)
                          ? (model.page ?? widget.defaultPage.toDouble())
                          : widget.defaultPage.toDouble())),
                      builder: (context, snapshot) {
                        return buildHeader(
                            widget.homework[
                                ((model.hasClients) ? (model.page ?? widget.defaultPage) : widget.defaultPage).round()],
                            ThemeUtils.darken(snapshot.data ?? Colors.white, forceAmount: 0.1),
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
    );
  }

  buildButton(Homework hw, Color color) {
    var screenSize = MediaQuery.of(context);

    return Container(
      color: Theme.of(context).primaryColor,
      width: screenSize.size.width,
      padding: EdgeInsets.symmetric(vertical: screenSize.size.height / 10 * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: (hw.documents ?? []).length > 0
                      ? Container(
                          key: ValueKey<int>(0),
                          child: CustomButtons.materialButton(
                              context, screenSize.size.width / 5 * 0.55, screenSize.size.width / 5 * 0.55, () {},
                              borderRadius: BorderRadius.circular(11),
                              backgroundColor: color,
                              icon: MdiIcons.fileDocumentMultipleOutline,
                              margin: EdgeInsets.zero),
                        )
                      : Container()),
              CustomButtons.materialButton(
                  context, screenSize.size.width / 5 * 0.55, screenSize.size.width / 5 * 0.55, () {},
                  borderRadius: BorderRadius.circular(11), backgroundColor: color, icon: MdiIcons.shareVariantOutline),
              CustomButtons.materialButton(context, screenSize.size.width / 5 * 0.55, screenSize.size.width / 5 * 0.55,
                  () async {
                await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      return HomeworkReaderOptionsBottomSheet();
                    });
                setState(() {});
              }, borderRadius: BorderRadius.circular(11), backgroundColor: color, icon: MdiIcons.eyePlusOutline),
              AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return ScaleTransition(child: child, scale: animation);
                  },
                  child: (hw.toReturn ?? false)
                      ? CustomButtons.materialButton(
                          context,
                          null,
                          screenSize.size.height / 10 * 0.5,
                          () {},
                          backgroundColor: color,
                          label: "RENDRE MON DEVOIR",
                          icon: MdiIcons.fileMoveOutline,
                          borderRadius: BorderRadius.circular(11),
                          padding: EdgeInsets.symmetric(
                              horizontal: screenSize.size.width / 5 * 0.5,
                              vertical: screenSize.size.height / 10 * 0.12),
                          textStyle: TextStyle(fontFamily: "Asap", fontWeight: FontWeight.w600, color: Colors.white),
                        )
                      : Container()),
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
                    Flexible(
                      flex: 9,
                      child: AutoSizeText(
                        hw.teacherName ?? "",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: "Asap", color: Colors.white60),
                      ),
                    ),
                  ],
                )),
                Visibility(
                  visible: page != widget.homework.length-1,
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
        buildButton(hw, color),
      ],
    );
  }

  buildPage(Homework hw) {
    var screenSize = MediaQuery.of(context);

    return FutureBuilder<int>(
        future: getColor(hw.disciplineCode),
        initialData: 0,
        builder: (context, snapshot) {
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
        });
  }

//Get monochromatic colors or not
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

  Future<Color> getBackgroundColor(double offset) async {
    if (offset.toInt() + 1 < widget.homework.length) {
      //Current background color
      Color? current = Color(await getColor(widget.homework[offset.toInt()].disciplineCode));
      Color? next = Color(await getColor(widget.homework[offset.toInt() + 1].disciplineCode));
      ThemeUtils.isThemeDark ? Color(0xff313131) : Colors.white;

      return Color.lerp(current, next, offset - offset.toInt()) ?? Colors.white;
    } else {
      return Color(await getColor(widget.homework.last.disciplineCode));
    }
  }

  htmlColors(String? html) {
    if (!appSys.settings!["user"]["homeworkPage"]["forceMonochromeContent"]) {
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
}
