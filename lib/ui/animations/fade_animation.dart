import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

enum AniProps { opacity, translateY, translateX }

class FadeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimation(this.delay, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.opacity, Tween<double>(begin: 0, end: 1), const Duration(milliseconds: 500))
      ..add(AniProps.translateY, Tween<double>(begin: -30, end: 0), const Duration(milliseconds: 500), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(AniProps.opacity),
        child: Transform.translate(offset: Offset(0, value.get(AniProps.translateY)), child: child),
      ),
    );
  }
}

class FadeAnimationLeftToRight extends StatelessWidget {
  final double delay;
  final Widget child;

  const FadeAnimationLeftToRight(this.delay, this.child, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<AniProps>()
      ..add(AniProps.translateX, Tween<double>(begin: -230, end: 0), const Duration(milliseconds: 250), Curves.easeOut);

    return PlayAnimation<MultiTweenValues<AniProps>>(
      delay: Duration(milliseconds: (500 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      builder: (context, child, value) =>
          Transform.translate(offset: Offset(value.get(AniProps.translateX), 0), child: child),
    );
  }
}
