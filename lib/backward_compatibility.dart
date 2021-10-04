import 'package:ynotes/core/utils/kvs.dart';

/// A function that migrates things from an implementation to another
Future<void> backwardCompatibility() async {
  // from 0.12 to 0.13 => change apiType values
  await _fromV12ToV13();
}

Future<void> _fromV12ToV13() async {
  final String? appAccount = await KVS.read(key: "appAccount");
  if (appAccount != null && appAccount.isNotEmpty) {
    String? newAppAccount;
    if (appAccount.contains('"apiType":"Pronote"')) {
      newAppAccount = appAccount.replaceAll('"apiType":"Pronote"', '"apiType":"pronote"');
    } else if (appAccount.contains('"apiType":"EcoleDirecte"')) {
      newAppAccount = appAccount.replaceAll('"apiType":"EcoleDirecte"', '"apiType":"ecoleDirecte"');
    }
    if (newAppAccount != null) {
      await KVS.write(key: "appAccount", value: newAppAccount);
    }
  }
}
