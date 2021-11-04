import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ynotes_packages/components.dart';
import 'package:ynotes_packages/theme.dart';
import 'package:ynotes_packages/utilities.dart';

class SettingsLicensesPage extends StatefulWidget {
  const SettingsLicensesPage({Key? key}) : super(key: key);

  @override
  _SettingsLicensesPageState createState() => _SettingsLicensesPageState();
}

class _SettingsLicensesPageState extends State<SettingsLicensesPage> {
  @override
  Widget build(BuildContext context) {
    final Future<_LicenseData> licenses = LicenseRegistry.licenses
        .fold<_LicenseData>(
          _LicenseData(),
          (_LicenseData prev, LicenseEntry license) => prev..addLicense(license),
        )
        .then((_LicenseData licenseData) => licenseData..sortPackages());
    return YPage(
        appBar: const YAppBar(title: "Licenses"),
        body: FutureBuilder(
            future: licenses,
            builder: (_, AsyncSnapshot<_LicenseData> snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    ...snapshot.data!.packages.asMap().entries.map((entry) {
                      final String packageName = entry.value;
                      final List<int> bindings = snapshot.data!.packageLicenseBindings[packageName]!;
                      return ListTile(
                        title:
                            Text(packageName, style: theme.texts.body1.copyWith(color: theme.colors.foregroundColor)),
                        subtitle: Text("${bindings.length} license${bindings.length > 1 ? 's' : ''}",
                            style: theme.texts.body2),
                        leading: Icon(Icons.library_books_rounded, color: theme.colors.foregroundLightColor),
                        onTap: () {
                          final List<Widget> children = bindings
                              .map((int i) => snapshot.data!.licenses[i])
                              .toList(growable: false)
                              .map((license) => Padding(
                                    padding: YPadding.pb(YScale.s8),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: license.paragraphs
                                          .map((e) => Padding(
                                                padding: YPadding.p(YScale.s2),
                                                child: Text(
                                                  e.text,
                                                  style: theme.texts.body1,
                                                  textAlign: TextAlign.start,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ))
                              .toList();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => YPage(
                                      appBar: YAppBar(title: packageName),
                                      body: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: children,
                                      ))));
                        },
                      );
                    })
                  ],
                );
              }
              return Padding(
                padding: YPadding.p(YScale.s4),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Chargement...", style: theme.texts.body1),
                      YVerticalSpacer(YScale.s2),
                      const SizedBox(width: 250, child: YLinearProgressBar())
                    ],
                  ),
                ),
              );
            }));
  }
}

/// This is a collection of licenses and the packages to which they apply.
/// [packageLicenseBindings] records the m+:n+ relationship between the license
/// and packages as a map of package names to license indexes.
class _LicenseData {
  final List<LicenseEntry> licenses = <LicenseEntry>[];
  final Map<String, List<int>> packageLicenseBindings = <String, List<int>>{};
  final List<String> packages = <String>[];

  // Special treatment for the first package since it should be the package
  // for delivered application.
  String? firstPackage;

  void addLicense(LicenseEntry entry) {
    // Before the license can be added, we must first record the packages to
    // which it belongs.
    for (final String package in entry.packages) {
      _addPackage(package);
      // Bind this license to the package using the next index value. This
      // creates a contract that this license must be inserted at this same
      // index value.
      packageLicenseBindings[package]!.add(licenses.length);
    }
    licenses.add(entry); // Completion of the contract above.
  }

  /// Add a package and initialize package license binding. This is a no-op if
  /// the package has been seen before.
  void _addPackage(String package) {
    if (!packageLicenseBindings.containsKey(package)) {
      packageLicenseBindings[package] = <int>[];
      firstPackage ??= package;
      packages.add(package);
    }
  }

  /// Sort the packages using some comparison method, or by the default manner,
  /// which is to put the application package first, followed by every other
  /// package in case-insensitive alphabetical order.
  void sortPackages([int Function(String a, String b)? compare]) {
    packages.sort(compare ??
        (String a, String b) {
          // Based on how LicenseRegistry currently behaves, the first package
          // returned is the end user application license. This should be
          // presented first in the list. So here we make sure that first package
          // remains at the front regardless of alphabetical sorting.
          if (a == firstPackage) {
            return -1;
          }
          if (b == firstPackage) {
            return 1;
          }
          return a.toLowerCase().compareTo(b.toLowerCase());
        });
  }
}
