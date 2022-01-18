part of app;

class AppConfig {
  AppConfig._();

  static final shake = _Shake();
  static late GlobalKey<NavigatorState> navigatorKey;
  static final patchNotes = _PatchNotes();
}

class _Shake {
  final String clientID = "iGBaTEc4t0namXSCrwRJLihJPkMPnfco2z4Xoyi3";
  final String clientSecret = "nfzb5JnoGoGVxEi75jejFhyTQL4MyyOC7yCMCYiOmKaykWdoh0kfbY8";
  final bool isSupported = Platform.isAndroid || Platform.isIOS;
}

class _PatchNotes {
  final String thumbnailPath = "assets/documents/patchNotes/thumbnail.png";
  final String textPath = "assets/documents/patchNotes/patchNotes.md";
}
