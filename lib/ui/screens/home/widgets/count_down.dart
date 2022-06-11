import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/globals.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

String? _emoji;
String? _text;

const List<String> _texts = [
  "Temps calme",
  "Pas de cours, on révise ?",
  "C'est la sieste (ou pas)",
  "Il n'y a jamais vraiment rien à faire",
  "Il fait beau dehors ?",
  "Flûte, le cours de maths est fini",
  "Après l'effort le réconfort",
  "Alors, ça se la coule douce ?"
];
const List<String> _emojis = ["😊", "😎", "😴", "👌", "🌞", "📚", "💪", "💤"];
Random get _random => Random();
String _getRandomElement(List<String> list) => list[_random.nextInt(list.length)];

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
  Duration timeDifference(DateTime date) => date.difference(now);

  /// Checks if a date respects the condition. Those conditions are:
  /// - the event is no more than 1 hour in the future
  /// - the event is no more than 10 minutes in the past
  bool condition(DateTime date) => timeDifference(date).inSeconds < 5400 && timeDifference(date).inSeconds > (-10 * 60);

  @override
  void initState() {
    super.initState();
    _text = _getRandomElement(_texts);
    _emoji = _getRandomElement(_emojis);
    // We fetch the events of the day.
    WidgetsBinding.instance?.addPostFrameCallback((_) {
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
    _emoji = null;
    _text = null;
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
    return _CountDownContent(
      event: event,
      time: timeDifference(event?.start! ?? DateTime.now()),
    );
  }
}

class _CountDownContent extends StatelessWidget {
  final AgendaEvent? event;
  final Duration time;

  const _CountDownContent({Key? key, required this.event, required this.time}) : super(key: key);

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
                  event == null
                      ? Text(
                          _emoji ?? "",
                          style: TextStyle(fontSize: YScale.s14),
                        )
                      : Stack(
                          children: [
                            SizedBox(
                              width: YScale.s14,
                              height: YScale.s14,
                              child: CircularProgressIndicator(
                                value: time.inSeconds >= 0
                                    ? 1.0 - 1.0 * time.inSeconds / 5400
                                    : 1.0 - 1.0 * (5400 - time.inSeconds.abs()) / 5400,
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
                        Text(event == null ? "Pas de cours d'ici 1h30" : "Prochain cours", style: theme.texts.body2),
                        event == null
                            ? Text(
                                _text ?? "",
                                style: theme.texts.body1
                                    .copyWith(color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                              )
                            : RichText(
                                text: TextSpan(
                                    text: event!.name,
                                    style: theme.texts.body1.copyWith(
                                        color: theme.colors.foregroundColor, fontWeight: YFontWeight.semibold),
                                    children: event!.location != null || event!.location == ""
                                        ? [
                                            const TextSpan(
                                                text: " en ", style: TextStyle(fontWeight: YFontWeight.normal)),
                                            TextSpan(text: event!.location),
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
