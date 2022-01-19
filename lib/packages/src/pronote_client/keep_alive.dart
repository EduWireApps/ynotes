part of pronote_client;

class KeepAlive {
  Communication? _connection;

  late bool keepAlive;

  void alive() async {
    while (keepAlive) {
      if (DateTime.now().millisecondsSinceEpoch / 1000 - _connection!.lastPing >= 300) {
        _connection!.post("Presence", data: {
          '_Signature_': {'onglet': 7}
        });
      }
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  void init(PronoteClient client) {
    _connection = client.communication;
    keepAlive = true;
  }
}
