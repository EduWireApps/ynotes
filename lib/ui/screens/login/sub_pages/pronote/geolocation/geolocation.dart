import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/pronote/login/geolocation/geolocation_controller.dart';
import 'package:ynotes/core/utils/controller_consumer.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:flutter_map/flutter_map.dart';
import "package:latlong2/latlong.dart";
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteGeolocationPage extends StatefulWidget {
  const LoginPronoteGeolocationPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteGeolocationPageState createState() => _LoginPronoteGeolocationPageState();
}

class _LoginPronoteGeolocationPageState extends State<LoginPronoteGeolocationPage> with TickerProviderStateMixin {
  final PronoteGeolocationController geolocationController = PronoteGeolocationController();
  final MapController mapController = MapController();
  static const double defaultZoomValue = 6.5;
  LatLng? previousPosition;
  // late final animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

  void _animatedMapMove(LatLng destLocation, [double destZoom = defaultZoomValue]) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(begin: mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(begin: mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: mapController.zoom, end: destZoom);

    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    final animationController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    Animation<double> animation = CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn);

    animationController.addListener(() {
      mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)), _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animationController.dispose();
      } else if (status == AnimationStatus.dismissed) {
        animationController.dispose();
      }
    });

    animationController.forward();
  }

  void mapMoveListener() {
    if (geolocationController.coordinates != previousPosition) {
      previousPosition = geolocationController.coordinates;
      if (previousPosition != null) {
        _animatedMapMove(previousPosition!, 13.5);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    geolocationController.addListener(() {
      if (geolocationController.status == GeolocationStatus.error) {
        handleError();
      }
    });
    geolocationController.addListener(mapMoveListener);
  }

  Future<void> handleError() async {
    final GeolocationError error = geolocationController.error!;
    await YDialogs.showInfo(
        context,
        YInfoDialog(
          title: error.title,
          body: Text(error.message, style: theme.texts.body1),
          confirmLabel: "OK",
        ));
    geolocationController.reset();
  }

  @override
  void dispose() {
    geolocationController.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ControllerConsumer<PronoteGeolocationController>(
        controller: geolocationController,
        builder: (context, controller, child) {
          return YPage(
            appBar: YAppBar(
              title: LoginContent.pronote.geolocation.title,
              actions: [
                if (controller.coordinates != null)
                  YButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/login/pronote/geolocation/results",
                            arguments: geolocationController);
                      },
                      text: LoginContent.pronote.geolocation.searchButton,
                      variant: YButtonVariant.text),
              ],
              bottom: controller.status == GeolocationStatus.loading ? const YLinearProgressBar() : null,
            ),
            scrollable: false,
            floatingButtons: [
              YFloatingButton(
                icon: Icons.search_rounded,
                onPressed: () async {
                  final dynamic location = await Navigator.pushNamed(context, "/login/pronote/geolocation/search",
                      arguments: geolocationController) as LatLng?;
                  if (location != null) {
                    geolocationController.updateCoordinates(location);
                  }
                },
                color: YColor.secondary,
              ),
              YFloatingButton(
                  icon: Icons.place,
                  onPressed: () {
                    controller.geolocateSchools();
                  },
                  color: YColor.primary),
            ],
            body: Column(
              children: [
                Expanded(
                    child: FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    center: LatLng(46.71109, 1.7191036),
                    zoom: defaultZoomValue,
                  ),
                  layers: [
                    TileLayerOptions(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                      attributionAlignment: Alignment.bottomLeft,
                      attributionBuilder: (_) =>
                          Text(LoginContent.pronote.geolocation.osmContributors, style: theme.texts.body1),
                    ),
                    MarkerLayerOptions(
                      markers: [
                        if (previousPosition != null)
                          Marker(
                              width: YScale.s12,
                              height: YScale.s12,
                              point: previousPosition!,
                              builder: (ctx) => Icon(
                                    Icons.place,
                                    color: theme.colors.primary.backgroundColor,
                                    size: YScale.s12,
                                  )),
                      ],
                    ),
                  ],
                ))
              ],
            ),
          );
        });
  }
}
