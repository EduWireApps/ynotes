import 'package:flutter/material.dart';
import 'package:ynotes/ui/components/NEW/buttons/legal_link_button.dart';

/// A class that stores shared buttons accross the app
class AppButtons {
  /// A class that stores shared buttons accross the app
  const AppButtons._();

  /// A button that opens a dialog containing the legal links
  static const Widget legalLinks = LegalLinksButton();
}
