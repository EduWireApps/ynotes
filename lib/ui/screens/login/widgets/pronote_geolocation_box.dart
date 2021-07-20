import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:sizer/sizer.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/core/logic/pronote/schools_controller.dart';
import 'package:ynotes/ui/components/column_generator.dart';
import 'package:ynotes/ui/screens/login/content/loginTextContent.dart';
import 'package:ynotes/ui/screens/login/widgets/login_text_field.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/components.dart';

class PronoteGeolocationBox extends StatefulWidget {
  final Function callback;

  const PronoteGeolocationBox({Key? key, required this.callback}) : super(key: key);

  @override
  _PronoteGeolocationBoxState createState() => _PronoteGeolocationBoxState();
}

class _PronoteGeolocationBoxState extends State<PronoteGeolocationBox> {
  PronoteSchoolsController pronoteSchoolsCon = PronoteSchoolsController();
  Artboard? _riveArtboard;
  RiveAnimationController? controller;
  PronoteSchool? selectedSchool;
  late TextEditingController searchCon;
  PronoteSpace? space;
  Widget? loadingWidget;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11, vertical: 1.1.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11), color: theme.colors.neutral.shade300),
      child: Column(
        children: [
          ChangeNotifierProvider<PronoteSchoolsController>.value(
            value: pronoteSchoolsCon,
            child: Consumer<PronoteSchoolsController>(builder: (context, _model, child) {
              return Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 200),
                      transitionBuilder: (Widget child, Animation<double> animation) {
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: getView(_model),
                    )
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildError(String? error) {
    return Column(
      key: ValueKey<int>(1),
      children: [
        Text(
          LoginPageTextContent.pronote.geolocation.error + "\n $error",
          style: TextStyle(
              fontFamily: "Asap",
              color: theme.colors.neutral.shade500,
              fontWeight: FontWeight.bold,
              fontSize: 12.5.sp.clamp(0, 19)),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 10,
        ),
        YButton(
          onPressed: () async {
            await pronoteSchoolsCon.reset();
          },
          text: 'Recommencer',
          type: YColor.primary,
        )
      ],
    );
  }

  Widget buildGeolocating() {
    var screenSize = MediaQuery.of(context);

    return Column(
      key: ValueKey<int>(0),
      children: [
        Container(
          height: screenSize.size.height / 10 * 2.5,
          child: _riveArtboard == null ? const SizedBox() : Rive(artboard: _riveArtboard!),
        ),
        Text(
          pronoteSchoolsCon.geolocating
              ? LoginPageTextContent.pronote.geolocation.geolocatingDescription
              : LoginPageTextContent.pronote.geolocation.statusSearchingDescription,
          style: TextStyle(
            fontFamily: "Asap",
            color: theme.colors.neutral.shade400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildSchools(List? schools) {
    var screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width / 5 * 4,
      child: Column(
        children: [
          LoginTextField(
            label: "Chercher une école",
            controller: searchCon,
          ),
          SizedBox(height: screenSize.size.height / 10 * 0.1),
          Container(
              height: 30.h,
              child: filterSchools(schools as List<PronoteSchool>?).length != 0
                  ? ListView.builder(
                      itemCount: filterSchools(schools).length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return buildSchoolTile(context, filterSchools(schools)[index]);
                      },
                    )
                  : buildError(LoginPageTextContent.pronote.geolocation.noData)),
          SizedBox(height: screenSize.size.height / 10 * 0.3),
        ],
      ),
    );
  }

  Widget buildSchoolTile(BuildContext context, PronoteSchool school) {
    late String distance;
    if (school.coordinates!.length > 2) {
      try {
        double val = double.tryParse(school.coordinates![2])! / 1000;
        distance = "à " + val.toStringAsPrecision(2) + " kilomètres";
      } catch (e) {
        distance = "(distance non définie)";
      }
    }
    return GestureDetector(
      onTap: () async {
        pronoteSchoolsCon.chosenSchool = school;

        await pronoteSchoolsCon.getSpaces();
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: school.postalCode,
                      style: TextStyle(
                          color: theme.colors.neutral.shade400,
                          fontFamily: "Asap",
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                      children: [
                        TextSpan(
                          text: " " + distance,
                          style: TextStyle(
                              color: theme.colors.neutral.shade400,
                              fontFamily: "Asap",
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                      ]),
                ),
                Text(
                  school.name ?? "",
                  style: TextStyle(
                    fontFamily: "Asap",
                    fontWeight: FontWeight.bold,
                    color: theme.colors.neutral.shade500,
                  ),
                ),
                Divider(
                  color: theme.colors.neutral.shade200,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSpaceTile(BuildContext context, PronoteSpace space) {
    return GestureDetector(
      onTap: () async {
        widget.callback(space.url);
      },
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  space.name ?? "",
                  style: TextStyle(
                      fontFamily: "Asap",
                      fontWeight: FontWeight.bold,
                      color: theme.colors.neutral.shade500,
                      fontSize: 15.sp.clamp(0, 19)),
                ),
                Divider(
                  color: theme.colors.neutral.shade200,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStatusRequest(List<PronoteSpace>? spaces) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 0.2.h),
        child: spaces != null && (spaces.length != 0)
            ? Column(
                children: [
                  Text(
                    LoginPageTextContent.pronote.geolocation.statusLabel,
                    style: TextStyle(
                        fontFamily: "Asap",
                        fontWeight: FontWeight.bold,
                        color: theme.colors.neutral.shade500,
                        fontSize: 21),
                  ),
                  Text(
                    LoginPageTextContent.pronote.geolocation.statusDescription,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontFamily: "Asap",
                        fontWeight: FontWeight.bold,
                        color: theme.colors.neutral.shade400,
                        fontSize: 15),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ColumnBuilder(
                    itemCount: spaces.length,
                    itemBuilder: (context, index) {
                      return buildSpaceTile(context, spaces[index]);
                    },
                  ),
                ],
              )
            : buildError(LoginPageTextContent.pronote.geolocation.noData));
  }

  filterSchools(List<PronoteSchool>? schools) {
    if (schools != null && schools.length != 0) {
      return schools.where((element) => element.name!.toUpperCase().contains(searchCon.text.toUpperCase())).toList();
    }
    return schools;
  }

  getView(PronoteSchoolsController model) {
    if (((model.school != null && model.spaces == null && !model.geolocating) || model.geolocating) &&
        model.error == null) {
      return buildGeolocating();
    } else if (model.school != null) {
      return (model.error != null ? buildError(model.error) : buildStatusRequest(model.spaces));
    } else {
      return (model.error != null ? buildError(model.error) : buildSchools(model.schools));
    }
  }

  @override
  void initState() {
    super.initState();
    searchCon = TextEditingController();
    searchCon.addListener(() {
      setState(() {});
    });
    pronoteSchoolsCon.geolocateSchools();
    rootBundle.load('assets/animations/geolocating.riv').then(
      (data) async {
        final file = RiveFile.import(data);

        // Load the RiveFile from the binary data.

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard.We store a reference to it so we can toggle playback.
        artboard.addController(controller = SimpleAnimation('Locating'));
        setState(() => _riveArtboard = artboard);
      },
    );
  }
}
