import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ynotes/ui/screens/login/content/login_content.dart';
import 'package:ynotes/useful_methods.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class EndOfSupportBanner extends StatefulWidget {
  const EndOfSupportBanner({Key? key}) : super(key: key);

  @override
  State<EndOfSupportBanner> createState() => _EndOfSupportBannerState();
}

class _EndOfSupportBannerState extends State<EndOfSupportBanner> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(YScale.s2),
      child: InkWell(
        onTap: () async {
          await launchURL(Uri.parse("https://ynotes.fr"));
        },
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: theme.colors.danger.backgroundColor, borderRadius: YBorderRadius.xl),
            padding: EdgeInsets.symmetric(vertical: YScale.s1p5, horizontal: YScale.s6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  MdiIcons.alertDecagram,
                  color: theme.colors.backgroundColor,
                ),
                YHorizontalSpacer(YScale.s2),
                Flexible(
                  child: Text(
                    LoginContent.login.endOfSupportFlag,
                    style: theme.texts.body1.copyWith(color: theme.colors.danger.foregroundColor),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
