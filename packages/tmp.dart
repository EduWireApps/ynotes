import 'ecole_directe_client/ecole_directe_client.dart';

const String username = 'aaa';
const String password = 'aaa';

Future<void> main() async {
  final client = EcoleDirecteClient();
  final res = await client.login(username: username, password: password);
  print(res.data);
  print(res.error);
}
