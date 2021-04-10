import 'package:flutter/material.dart';

class Expandables extends StatefulWidget {
  ///The expandable topChild widget
  final Widget topChild;

  ///The expandable bottomChild widget
  final Widget bottomChild;

  ///The top expandable color
  final Color topExpandableColor;

  ///The bottom expandable color
  final Color bottomExpandableColor;

  ///The top expandable border radius (default to 11)
  final double topExpandableBorderRadius;

  ///The bottom expandable border radius (default to 11)
  final double bottomExpandableBorderRadius;

  ///Expandables max height
  double maxHeight;

  ///Expandables min height
  double minHeight;

  ///Space between expandables
  double spaceBetween;

  ///Width
  double width;

  ///Shadow color
  final Color expandablesShadowColor;

  ///Defines if top widget is firstly expanded
  final bool topIsExpanded;

//Milliseconds animation (expanding or collapsing) duration
  final int animationDuration;
  final Function(
          double topWidgetPercentExpansion, double bottomWidgetPercentExpansion)
      onDragUpdate;
  Expandables(this.topChild, this.bottomChild,
      {this.topExpandableColor,
      this.bottomExpandableColor,
      this.onDragUpdate,
      this.topExpandableBorderRadius = 11,
      this.bottomExpandableBorderRadius = 11,
      this.maxHeight,
      this.minHeight,
      this.spaceBetween,
      this.expandablesShadowColor,
      this.animationDuration = 250,
      this.width,
      this.topIsExpanded = true});
  @override
  _ExpandablesState createState() => _ExpandablesState();
}

class _ExpandablesState extends State<Expandables>
    with TickerProviderStateMixin {
  void initState() {
    super.initState();
    expandingAnimationController = AnimationController(
        duration: Duration(milliseconds: widget.animationDuration),
        vsync: this);
    expandingAnimationController.addListener(() {
      widget.onDragUpdate(
          topWidgetPercentExpansion, bottomWidgetPercentExpansion);
    });
    expandBottomWidget = Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: expandingAnimationController,
            curve: Curves.easeInQuad,
            reverseCurve: Curves.easeInQuad));
    if (!widget.topIsExpanded) {
      bottomWidgetPercentExpansion = 100;
      topWidgetPercentExpansion = 0;
    }
  }

  void dispose() {
    super.dispose();
    expandingAnimationController.dispose();
  }

  double minPercentDragged = 80;
  double topWidgetPercentExpansion = 100.0;
  double bottomWidgetPercentExpansion = 0.0;

  double velocityToExpand = 800;
  Animation<double> expandBottomWidget;
  AnimationController expandingAnimationController;

  animateBottomWidgetToMin() {
    setState(() {
      expandingAnimationController.value = bottomWidgetPercentExpansion / 100;
    });

    expandingAnimationController.reverse().then((value) {
      setState(() {
        topWidgetPercentExpansion = 100;
        bottomWidgetPercentExpansion = 0;
      });
      widget.onDragUpdate(100, 0);
    });

    this
        .widget
        .onDragUpdate(topWidgetPercentExpansion, bottomWidgetPercentExpansion);
  }

  animateBottomWidgetToMax() {
    setState(() {
      expandingAnimationController.value = bottomWidgetPercentExpansion / 100;
    });

    expandingAnimationController.forward().then((value) {
      setState(() {
        topWidgetPercentExpansion = 0;
        bottomWidgetPercentExpansion = 100;
      });
      widget.onDragUpdate(0, 100);
    });
  }

  handleTopWidgetDragUpdate(DragUpdateDetails details) {
    double rootContainerHeight =
        widget.maxHeight + widget.minHeight + widget.spaceBetween;
    double dyPosition = details.localPosition.dy;
    //If dragging to the top

    if (dyPosition > 0) {
      if (topWidgetPercentExpansion < 100 &&
          details.localPosition.dy.abs() * 100 / rootContainerHeight < 100) {
        setState(() {
          topWidgetPercentExpansion =
              details.localPosition.dy.abs() * 100 / rootContainerHeight;
          bottomWidgetPercentExpansion = -(topWidgetPercentExpansion) + 100;
        });
        if (widget.onDragUpdate != null) {
          widget.onDragUpdate(
              topWidgetPercentExpansion, bottomWidgetPercentExpansion);
        }
      }
    } else {}
  }

  handleTopWidgetDragEnd(DragEndDetails details) {
    if (topWidgetPercentExpansion < minPercentDragged &&
        !expandingAnimationController.isAnimating) {
      //if dragged fastly
      if (details.primaryVelocity > velocityToExpand) {
        animateBottomWidgetToMin();
      }
      //if dragged slowly
      else {
        animateBottomWidgetToMax();
      }
    } else {
      animateBottomWidgetToMin();
    }
  }

  handleBottomWidgetDragUpdate(DragUpdateDetails details) {
    double rootContainerHeight =
        widget.maxHeight + widget.minHeight + widget.spaceBetween;
    double dyPosition = details.localPosition.dy;
    //If dragging to the top

    if (dyPosition < 0) {
      if (bottomWidgetPercentExpansion < 100 &&
          details.localPosition.dy.abs() * 100 / rootContainerHeight < 100) {
        setState(() {
          bottomWidgetPercentExpansion =
              details.localPosition.dy.abs() * 100 / rootContainerHeight;
          topWidgetPercentExpansion = -(bottomWidgetPercentExpansion) + 100;
        });
        if (widget.onDragUpdate != null) {
          widget.onDragUpdate(
              topWidgetPercentExpansion, bottomWidgetPercentExpansion);
        }
      }
    } else {}
  }

  handleBottomWidgetDragEnd(DragEndDetails details) {
    if (bottomWidgetPercentExpansion < minPercentDragged &&
        !expandingAnimationController.isAnimating) {
      //if dragged fastly
      if (details.primaryVelocity < velocityToExpand) {
        animateBottomWidgetToMax();
      }
      //if dragged slowly
      else {
        animateBottomWidgetToMin();
      }
    } else {
      animateBottomWidgetToMax();
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData screenSize = MediaQuery.of(context);
    if (widget.maxHeight == null) {
      widget.maxHeight = screenSize.size.height / 10 * 7;
    }
    if (widget.minHeight == null) {
      widget.minHeight = screenSize.size.height / 10 * 1;
    }
    if (widget.spaceBetween == null) {
      widget.spaceBetween = screenSize.size.height / 10 * 0.3;
    }
    if (widget.width == null) {
      widget.width = screenSize.size.width / 5 * 4.7;
    }
    return AnimatedBuilder(
        animation: expandingAnimationController,
        builder: (context, child) {
          if (expandingAnimationController.isAnimating) {
            bottomWidgetPercentExpansion =
                expandingAnimationController.value * 100;
            topWidgetPercentExpansion =
                (-expandingAnimationController.value + 1) * 100;
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                onVerticalDragUpdate: handleTopWidgetDragUpdate,
                onVerticalDragEnd: handleTopWidgetDragEnd,
                onTap: () {
                  animateBottomWidgetToMin();
                },
                child: Card(
                    margin: EdgeInsets.zero,
                    shadowColor: widget.expandablesShadowColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            widget.topExpandableBorderRadius)),
                    color: widget.topExpandableColor ??
                        Theme.of(context).primaryColor,
                    child: Container(
                      padding: EdgeInsets.zero,
                      width: widget.width,
                      height: widget.minHeight +
                          (widget.maxHeight - widget.minHeight) *
                              topWidgetPercentExpansion /
                              100,
                      child: widget.topChild,
                    )),
              ),
              GestureDetector(
                onVerticalDragUpdate: handleBottomWidgetDragUpdate,
                onVerticalDragEnd: handleBottomWidgetDragEnd,
                onTap: () {
                  animateBottomWidgetToMax();
                },
                child: Card(
                    shadowColor: widget.expandablesShadowColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            widget.bottomExpandableBorderRadius)),
                    margin: EdgeInsets.only(top: widget.spaceBetween),
                    color: widget.bottomExpandableColor ??
                        Theme.of(context).primaryColor,
                    child: Container(
                      width: widget.width,
                      height: widget.minHeight +
                          (widget.maxHeight - widget.minHeight) *
                              bottomWidgetPercentExpansion /
                              100,
                      child: widget.bottomChild,
                    )),
              ),
            ],
          );
        });
  }
}
