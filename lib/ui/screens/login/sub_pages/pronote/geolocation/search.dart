import 'dart:async';

import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core_new/controllers.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoginPronoteGeolocationSearchPage extends StatefulWidget {
  const LoginPronoteGeolocationSearchPage({Key? key}) : super(key: key);

  @override
  _LoginPronoteGeolocationSearchPageState createState() => _LoginPronoteGeolocationSearchPageState();
}

class _LoginPronoteGeolocationSearchPageState extends State<LoginPronoteGeolocationSearchPage> {
  PronoteGeolocationController? geolocationController;
  String _location = "";
  List<OSMLocation> _locations = [];
  Timer? _debounce;

  List<Widget> get children {
    List<Widget> _els = [];
    final int _length = _locations.length;

    for (int i = 0; i < _length + _length - 1; i++) {
      _els.add(i % 2 == 0 ? _LocationTile(_locations[i ~/ 2]) : const YDivider());
    }

    return _els;
  }

  Future<void> fetchLocations() async {
    final List<OSMLocation> _locations = await geolocationController!.locateNearPlaces(_location);
    setState(() {
      this._locations = _locations;
    });
  }

  _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) {
        setState(() {
          _location = value;
        });
        fetchLocations();
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    geolocationController ??= AppRouter.getArgs<PronoteGeolocationController>(context);
    return YPage(
        appBar: YAppBar(title: LoginContent.pronote.geolocation.search.title),
        body: Column(
          children: [
            Padding(
              padding: YPadding.p(YScale.s2),
              child: YFormField(
                  type: YFormFieldInputType.text,
                  label: LoginContent.pronote.geolocation.search.search,
                  properties: YFormFieldProperties(textInputAction: TextInputAction.search),
                  onChanged: _onSearchChanged),
            ),
            Padding(
              padding: YPadding.pt(YScale.s4),
              child: _locations.isEmpty
                  ? Text(
                      geolocationController!.status == GeolocationStatus.loading
                          ? LoginContent.pronote.geolocation.search.searching
                          : (_location.isEmpty
                              ? LoginContent.pronote.geolocation.search.empty
                              : LoginContent.pronote.geolocation.noResults),
                      style: theme.texts.body1,
                      textAlign: TextAlign.center,
                    )
                  : Column(children: children),
            )
          ],
        ));
  }
}

class _LocationTile extends StatelessWidget {
  final OSMLocation location;
  const _LocationTile(this.location, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home_work_rounded, color: theme.colors.foregroundLightColor),
      title: Text("${location.name} ", style: theme.texts.body1),
      onTap: () async {
        Navigator.pop(context, location.coordinates);
      },
    );
  }
}
