import 'dart:async';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

/// A class that manages the next lesson's countdown
class CountDown extends StatefulWidget {
  /// A class that manages the next lesson's countdown
  const CountDown({Key? key}) : super(key: key);

  @override
  _CountDownState createState() => _CountDownState();
}

class _CountDownState extends State<CountDown> {
  /// All the events of the day. Initialized in [init].
  List<AgendaEvent> events = [];

  /// The timer to refresh the countdown each second. Initialized in [initState].
  late final Timer timer;

  /// The nearest event from [now]. Based on [condition].
  AgendaEvent? get event => events.firstWhereOrNull((event) => condition(event.start!));

  /// Now obvoiusly.
  DateTime now = DateTime.now();

  /// The difference between [date] and [now].
  Duration time(DateTime date) => date.difference(now);

  /// Checks if a date respects the condition. Those conditions are:
  /// - the event is no more than 1 hour in the future
  /// - the event is no more than 10 minutes in the past
  bool condition(DateTime date) => time(date).inSeconds < 3600 && time(date).inSeconds > (-10 * 60);

  @override
  void initState() {
    super.initState();
    // We fetch the events of the day.
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      init();
    });
    // We refresh the countdown every second.
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  /// Initializes the events of the day.
  Future<void> init() async {
    // The events are fetchde and sorted by date (ascending).
    final List<AgendaEvent> fetchedEvents = ((await appSys.api!.getEvents(now, forceReload: false))
            ?.where((event) => event.isLesson ?? false)
            .toList() ??
        [])
      ..sort((a, b) => a.start!.compareTo(b.start!));
    setState(() {
      events = fetchedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    return (event != null && condition(event!.start!))
        ? _CountDownContent(
            event: event!,
            remainingTime: time(event!.start!),
          )
        : Container();
  }
}

class _CountDownContent extends StatefulWidget {
  final AgendaEvent event;
  final Duration remainingTime;

  const _CountDownContent({Key? key, required this.event, required this.remainingTime}) : super(key: key);

  @override
  __CountDownContentState createState() => __CountDownContentState();
}

class __CountDownContentState extends State<_CountDownContent> {
  Duration get time => widget.remainingTime;

  YTColor get color {
    if (time.inSeconds < 60) {
      return theme.colors.danger;
    } else if (time.inSeconds < (5 * 60)) {
      return theme.colors.warning;
    }
    return theme.colors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, '/agenda'),
          child: Ink(
              width: double.infinity,
              padding: YPadding.p(YScale.s4),
              child: Row(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        width: YScale.s14,
                        height: YScale.s14,
                        child: CircularProgressIndicator(
                          value: time.inSeconds >= 0
                              ? 1.0 - 1.0 * time.inSeconds / 3600
                              : 1.0 - 1.0 * (3600 - time.inSeconds.abs()) / 3600,
                          color: color.backgroundColor,
                          backgroundColor: color.lightColor,
                          strokeWidth: YScale.s1,
                        ),
                      ),
                      Positioned.fill(
                          child: Center(
                        child: Text(
                            "${time.inMinutes.abs().toString().padLeft(2, '0')}:${(time.inSeconds.abs() - (time.inMinutes.abs() * 60)).toString().padLeft(2, '0')}",
                            style: theme.texts.body1.copyWith(fontSize: YFontSize.base)),
                      ))
                    ],
                  ),
                  YHorizontalSpacer(YScale.s6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Prochain cours", style: theme.texts.body2),
                        RichText(
                            text: TextSpan(
                                text: widget.event.name,
                                style: theme.texts.body1
                                    .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                                children: widget.event.location != null
                                    ? [
                                        const TextSpan(text: " en ", style: TextStyle(fontWeight: YFontWeight.normal)),
                                        TextSpan(text: widget.event.location),
                                      ]
                                    : null)),
                      ],
                    ),
                  ),
                ],
              )),
        ),
        const YDivider()
      ],
    );
  }
}
