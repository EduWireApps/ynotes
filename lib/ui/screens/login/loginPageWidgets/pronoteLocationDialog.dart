import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:ynotes/core/logic/modelsExporter.dart';
import 'package:ynotes/core/logic/pronote/schoolsController.dart';
import 'package:ynotes/core/utils/themeUtils.dart';
import 'package:ynotes/ui/components/buttons.dart';
import 'package:ynotes/ui/components/textField.dart';

class PronoteGeolocationDialog extends StatefulWidget {
  @override
  _PronoteGeolocationDialogState createState() =>
      _PronoteGeolocationDialogState();
}

class _PronoteGeolocationDialogState extends State<PronoteGeolocationDialog> {
  PronoteSchoolsController pronoteSchoolsCon = PronoteSchoolsController();

  Artboard? _riveArtboard;
  RiveAnimationController? controller;
  PronoteSchool? selectedSchool;
  TextEditingController? searchCon;
  PronoteSpace? space;
  Widget? loadingWidget;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      insetPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: ChangeNotifierProvider<PronoteSchoolsController>.value(
          value: pronoteSchoolsCon,
          child: Consumer<PronoteSchoolsController>(
              builder: (context, _model, child) {
            return Container(
              height: screenSize.size.height / 10 * 7,
              width: screenSize.size.width / 5 * 4,
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(18)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return ScaleTransition(child: child, scale: animation);
                    },
                    child: getView(_model),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildError(String? error) {
    var screenSize = MediaQuery.of(context);

    return Column(
      key: ValueKey<int>(1),
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(18)),
          height: screenSize.size.height / 10 * 1.5,
          child: FittedBox(
            child: Icon(
              Icons.error,
              color: Colors.red,
            ),
          ),
        ),
        Text(
          "Hum... quelque chose ne s'est pas passé comme prévu ! \n $error",
          style: TextStyle(fontFamily: "Asap", color: Colors.black),
          textAlign: TextAlign.center,
        ),
        Container(
          margin: EdgeInsets.only(top: screenSize.size.height / 10 * 0.1),
          child: CustomButtons.materialButton(context, null, null, () async {
            await pronoteSchoolsCon.reset();
          }, label: "Recommencer"),
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
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(18)),
          height: screenSize.size.height / 10 * 2.5,
          child: _riveArtboard == null
              ? const SizedBox()
              : Rive(artboard: _riveArtboard!),
        ),
        Text(
          pronoteSchoolsCon.geolocating
              ? "Géolocalisation des établissements à proximité..."
              : "Recherche des status disponibles",
          style: TextStyle(fontFamily: "Asap", color: Colors.black),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget buildNoSchoolFound() {
    return Container(
      child: Center(
        child: Text(
          "Aucun établissement trouvé...",
          style: TextStyle(fontFamily: "Asap"),
        ),
      ),
    );
  }

  Widget buildSchools(List? schools) {
    var screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width / 5 * 4,
      child: Column(
        children: [
          Text(
            "Choisissez votre école :",
            style: TextStyle(fontFamily: "Asap"),
          ),
          SizedBox(height: screenSize.size.height / 10 * 0.1),
          CustomTextField(
              searchCon, "Chercher une école", false, Icons.search, false),
          SizedBox(height: screenSize.size.height / 10 * 0.1),
          Container(
              height: screenSize.size.height / 10 * 5,
              child: filterSchools(schools as List<PronoteSchool>?).length != 0
                  ? ListView.builder(
                      itemCount: filterSchools(schools).length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return slidingSchool(
                            context, filterSchools(schools)[index]);
                      },
                    )
                  : buildNoSchoolFound()),
          SizedBox(height: screenSize.size.height / 10 * 0.3),
          Container(
            height: screenSize.size.height / 10 * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButtons.materialButton(context, null, null, () {
                    Navigator.of(context).pop();
                  },
                      label: "Quitter",
                      backgroundColor: Colors.orange,
                      textColor: Colors.white),
                ),
                Expanded(
                  child: CustomButtons.materialButton(
                      context,
                      null,
                      null,
                      selectedSchool != null
                          ? () async {
                              pronoteSchoolsCon.chosenSchool = selectedSchool;
                              await pronoteSchoolsCon.getSpaces();
                            }
                          : null,
                      label: "Continuer",
                      backgroundColor:
                          selectedSchool != null ? Colors.green : Colors.grey,
                      textColor: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildStatusRequest(List<PronoteSpace>? spaces) {
    var screenSize = MediaQuery.of(context);

    return Container(
      width: screenSize.size.width / 5 * 4,
      child: Column(
        children: [
          Text(
            "Choisissez votre statut :",
            style: TextStyle(fontFamily: "Asap"),
          ),
          Container(
            height: screenSize.size.height / 10 * 5,
            child: AnimatedList(
              initialItemCount: spaces != null ? spaces.length : 0,
              itemBuilder: (context, index, animation) {
                return slidingSpace(context, spaces![index], animation);
              },
            ),
          ),
          SizedBox(height: screenSize.size.height / 10 * 0.3),
          Container(
            height: screenSize.size.height / 10 * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomButtons.materialButton(context, null, null, () {
                    Navigator.of(context).pop();
                  },
                      label: "Quitter",
                      backgroundColor: Colors.orange,
                      textColor: Colors.white),
                ),
                Expanded(
                  child: CustomButtons.materialButton(
                      context,
                      null,
                      null,
                      space != null
                          ? () {
                              Navigator.of(context).pop(space);
                            }
                          : null,
                      label: "Continuer",
                      backgroundColor:
                          space != null ? Colors.green : Colors.grey,
                      textColor: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  filterSchools(List<PronoteSchool>? schools) {
    if (schools != null && schools.length != 0) {
      return schools
          .where((element) => element.name!
              .toUpperCase()
              .contains(searchCon!.text.toUpperCase()))
          .toList();
    }
    return schools;
  }

  getView(PronoteSchoolsController model) {
    if (((model.school != null && model.spaces == null && !model.geolocating) ||
            model.geolocating) &&
        model.error == null) {
      return buildGeolocating();
    } else if (model.school != null) {
      return (model.error != null
          ? buildError(model.error)
          : buildStatusRequest(model.spaces));
    } else {
      return (model.error != null
          ? buildError(model.error)
          : buildSchools(model.schools));
    }
  }

  @override
  void initState() {
    super.initState();
    searchCon = TextEditingController();

    searchCon!.addListener(() {
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

  Widget slidingSchool(BuildContext context, PronoteSchool school) {
    var screenSize = MediaQuery.of(context);
    late String distance;
    if (school.coordinates!.length > 2) {
      try {
        double val = double.tryParse(school.coordinates![2])! / 1000;
        distance = "à " + val.toStringAsPrecision(2) + " kilomètres";
      } catch (e) {
        distance = "(distance non définie)";
      }
    }
    return SizedBox(
      // Actual widget to display
      height: screenSize.size.height / 10 * 0.9,
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedSchool = school;
          });
        },
        child: Card(
          color: Theme.of(context).primaryColorDark,
          child: Row(
            children: [
              SizedBox(width: screenSize.size.width / 10 * 0.1),
              Checkbox(
                  side: BorderSide(width: 1, color: Colors.white),
                  fillColor: MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                  shape: CircleBorder(),
                  value: selectedSchool == school,
                  onChanged: (newValue) {
                    setState(() {
                      selectedSchool = school;
                    });
                  }),
              SizedBox(width: screenSize.size.width / 10 * 0.1),
              Expanded(
                child: Wrap(
                  spacing: screenSize.size.width / 5 * 0.05,
                  children: [
                    Text(
                      school.name ?? "",
                      style: TextStyle(
                          fontFamily: "Asap", fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "-",
                    ),
                    Text(
                      school.postalCode ?? "",
                      style: TextStyle(
                          fontFamily: "Asap", fontStyle: FontStyle.italic),
                    ),
                    Text(distance),
                  ],
                ),
              ),
              SizedBox(width: screenSize.size.width / 10 * 0.1),
            ],
          ),
        ),
      ),
    );
  }

  Widget slidingSpace(BuildContext context, PronoteSpace _space, animation) {
    var screenSize = MediaQuery.of(context);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: Offset(0, 0),
      ).animate(animation),
      child: SizedBox(
        // Actual widget to display
        height: screenSize.size.height / 10 * 0.9,
        child: GestureDetector(
          onTap: () {
            setState(() {
              space = _space;
            });
          },
          child: Card(
            color: Theme.of(context).primaryColorDark,
            child: Row(
              children: [
                SizedBox(width: screenSize.size.width / 10 * 0.1),
                Checkbox(
                    side: BorderSide(width: 1, color: Colors.white),
                    fillColor: MaterialStateColor.resolveWith(ThemeUtils.getCheckBoxColor),
                    shape: const CircleBorder(),
                    value: space == _space,
                    onChanged: (newValue) {
                      setState(() {
                        space = _space;
                      });
                    }),
                SizedBox(width: screenSize.size.width / 10 * 0.1),
                Expanded(
                  child: Wrap(
                    spacing: screenSize.size.width / 5 * 0.05,
                    children: [
                      Text(
                        _space.name ?? "",
                        style: TextStyle(
                            fontFamily: "Asap", fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenSize.size.width / 10 * 0.1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
