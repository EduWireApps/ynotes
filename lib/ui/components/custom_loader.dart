import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:ynotes/ui/animations/fade_animation.dart';

class CustomLoader extends StatefulWidget {
  final double width;
  final double height;
  final Color color;

  const CustomLoader(this.width, this.height, this.color, {Key? key}) : super(key: key);
  @override
  _CustomLoaderState createState() => _CustomLoaderState();
}

class _CustomLoaderState extends State<CustomLoader> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: widget.width,
        height: widget.height,
        child: FadeAnimation(
          0.2,
          FlareActor(
            "assets/animations/ynotesLoader.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: "Anime",
            color: widget.color,
          ),
        ));
  }
}
