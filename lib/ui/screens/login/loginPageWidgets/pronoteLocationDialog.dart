import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:ynotes/core/logic/pronote/schoolsController.dart';

class PronoteGeolocationDialog extends StatefulWidget {
  @override
  _PronoteGeolocationDialogState createState() => _PronoteGeolocationDialogState();
}

class _PronoteGeolocationDialogState extends State<PronoteGeolocationDialog> {
  PronoteSchoolsController con;
  Artboard _riveArtboard;
  RiveAnimationController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    con = PronoteSchoolsController();
    con.geolocateSchools();
    rootBundle.load('assets/animations/geolocating.riv').then(
      (data) async {
        final file = RiveFile();
        // Load the RiveFile from the binary data.
        if (file.import(data)) {
          // The artboard is the root of the animation and gets drawn in the
          // Rive widget.
          final artboard = file.mainArtboard;
          // Add a controller to play back a known animation on the main/default
          // artboard.We store a reference to it so we can toggle playback.
          artboard.addController(_controller = SimpleAnimation('Locating'));
          setState(() => _riveArtboard = artboard);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context);

    return AlertDialog(
      elevation: 50,
      backgroundColor: Theme.of(context).primaryColor,
      insetPadding: EdgeInsets.all(0),
      content: ChangeNotifierProvider<PronoteSchoolsController>.value(
        value: con,
        child: Consumer<PronoteSchoolsController>(builder: (context, model, child) {
          return Container(
            height: screenSize.size.height / 10 * 7,
            width: screenSize.size.width / 5 * 4,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(18)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(18)),
                  height: screenSize.size.height / 10 * 2.5,
                  child: _riveArtboard == null ? const SizedBox() : Rive(artboard: _riveArtboard),
                ),
                Text(
                  "Géolocalisation des établissements à proximité...",
                  style: TextStyle(fontFamily: "Asap", color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
