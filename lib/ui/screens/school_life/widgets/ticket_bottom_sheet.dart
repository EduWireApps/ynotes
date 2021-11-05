import 'package:flutter/material.dart';
import 'package:ynotes/core/logic/models_exporter.dart';
import 'package:ynotes/extensions.dart';
import 'package:ynotes_packages/theme.dart';

class TicketBottomSheet extends StatelessWidget {
  final SchoolLifeTicket ticket;
  const TicketBottomSheet({Key? key, required this.ticket}) : super(key: key);

  List<_Element> get elements => [
        _Element(
            icon: Icons.calendar_today_rounded,
            title: "Date",
            subtitle: (ticket.displayDate ?? "Inconnue").capitalize()),
        _Element(icon: Icons.timelapse_rounded, title: "Durée", subtitle: ticket.libelle ?? "Inconnue"),
        _Element(icon: Icons.check_rounded, title: "Justifié", subtitle: (ticket.isJustified ?? false) ? "Oui" : "Non"),
        if (ticket.isJustified ?? false)
          _Element(icon: Icons.quiz_rounded, title: "Motif", subtitle: ticket.motif ?? "Inconnu"),
      ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: elements
          .map((e) => ListTile(
                leading: Icon(e.icon, color: theme.colors.foregroundColor),
                title: Text(e.title, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                subtitle: Text(e.subtitle, style: theme.texts.body1),
              ))
          .toList(),
    );
  }
}

class _Element {
  final IconData icon;
  final String title;
  final String subtitle;

  const _Element({required this.icon, required this.title, required this.subtitle});
}
