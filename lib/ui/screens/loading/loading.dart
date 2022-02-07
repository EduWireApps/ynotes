import 'package:flutter/material.dart';
import 'package:ynotes/app/app.dart';
import 'package:ynotes/core/utilities.dart';
import 'package:ynotes/core/services.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.colors.backgroundColor,
      body: FadeAnimation(
        0.2,
        Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
              image: const AssetImage('assets/images/icons/app/AppIcon.png'),
              width: 100,
              color: theme.colors.primary.backgroundColor,
            ),
            YVerticalSpacer(YScale.s12),
            const SizedBox(width: 200, child: YLinearProgressBar()),
            YVerticalSpacer(YScale.s8),
            ChangeNotifierConsumer<SystemServiceStore>(
                controller: SystemService.store,
                builder: (context, store, _) {
                  return Text(
                    "${store.text} ${store.current}/${store.total}",
                    style: theme.texts.body1,
                  );
                }),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // We set the system ui
    UIU.setSystemUIOverlayStyle();
    WidgetsBinding.instance?.addPostFrameCallback((_) => redirect());
  }

  Future<void> redirect() async {
    await SystemService.init(all: false, loading: true);
    await Future.delayed(const Duration(milliseconds: 500));
    final credentials = await schoolApi.authModule.getCredentials();
    final bool hasCredentials = credentials.error == null;
    final String? completedLogin = await KVS.read(key: "agreedTermsAndConfiguredApp");
    // The user is authenticated
    if (hasCredentials) {
      // The user has agreed to the terms and the app is configured
      if (completedLogin != null) {
        if (mounted) {
          schoolApi.fetch();
          Navigator.pushReplacementNamed(context, "/home");
        }
      } else {
        Navigator.pushReplacementNamed(context, "/terms");
      }
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}
