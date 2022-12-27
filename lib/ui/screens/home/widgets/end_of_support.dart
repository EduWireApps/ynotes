import 'package:flutter/cupertino.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:ynotes_packages/theme.dart';

class EndOfSupportBanner extends StatefulWidget {
  const EndOfSupportBanner({Key? key}) : super(key: key);

  @override
  State<EndOfSupportBanner> createState() => _EndOfSupportBannerState();
}

class _EndOfSupportBannerState extends State<EndOfSupportBanner> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Cette application n'est pas maintenue. :(",
        style: theme.texts.body1.copyWith(
            color: theme.colors.danger.backgroundColor.withOpacity(0.2)),
      ),
    );
  }
}
