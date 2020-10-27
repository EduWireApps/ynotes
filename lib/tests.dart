
enum appEnvs { prod, beta, dev }

///Here are some tests values, as mocking variables or beta app
///To pass arguments use `flutter run --dart-define="var=value"`
class Tests {
  //Publishing vars
  static const env = String.fromEnvironment("ENV");
  static const testVersion = String.fromEnvironment("TESTVERSION", defaultValue: "final");

  //Test vars
  static const gradeMockUrl = String.fromEnvironment("GRADEMOCKURL");

  appEnvs get globalAppEnv {
    if (env != null) {
      for (appEnvs appEnv in appEnvs.values) {
        if (appEnv.toString().split('.').last == env) {
          return appEnv;
        }
      }
    } else {
      return appEnvs.prod;
    }
  }
}
