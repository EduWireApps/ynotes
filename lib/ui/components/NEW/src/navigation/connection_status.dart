part of components;

class _ConnectionStatus extends StatefulWidget {
  final Widget child;
  const _ConnectionStatus({Key? key, required this.child}) : super(key: key);

  @override
  __ConnectionStatusState createState() => __ConnectionStatusState();
}

class __ConnectionStatusState extends State<_ConnectionStatus> with TickerProviderStateMixin {
  late final Animation<double> _animation;
  late final AnimationController _controller;
  final Duration _duration = const Duration(milliseconds: 600);

  AuthStatus get _status => schoolApi.authModule.status;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _duration,
      vsync: this,
      value: _status == AuthStatus.authenticated ? 1 : null,
    );
    _animation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn)),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final double paddingTop = MediaQuery.of(context).padding.top;
    final double height = YScale.s8;
    return ControllerConsumer<AuthModule>(
        controller: schoolApi.authModule,
        builder: (context, module, _) {
          if (_status == AuthStatus.authenticated) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          return Stack(
            children: [
              AnimatedPositioned(
                duration: _duration,
                top: height * _animation.value,
                left: 0,
                right: 0,
                bottom: 0,
                child: widget.child,
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, _) => InkWell(
                        onTap: () => Navigator.pushNamed(context, "/settings/account"),
                        child: Ink(
                            child: AnimatedContainer(
                                duration: _duration,
                                color: module.color.backgroundColor,
                                height: (height + paddingTop) * _animation.value,
                                child: Padding(
                                  padding: YPadding.pt(paddingTop),
                                  child: AnimatedOpacity(
                                    duration: _duration,
                                    opacity: _animation.value,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(width: YScale.s5, child: FittedBox(child: module.icon)),
                                        YHorizontalSpacer(YScale.s2),
                                        RichText(
                                            text: TextSpan(
                                                text: "${module.details} ",
                                                style: theme.texts.body1.copyWith(color: module.color.foregroundColor),
                                                children: [
                                              if (_status != AuthStatus.authenticated)
                                                const TextSpan(
                                                    text: "Voir", style: TextStyle(fontWeight: YFontWeight.semibold))
                                            ])),
                                      ],
                                    ),
                                  ),
                                ))))),
              ),
            ],
          );
        });
  }
}
