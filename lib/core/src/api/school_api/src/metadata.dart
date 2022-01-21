part of school_api;

class Metadata {
  final String name;
  final bool beta;
  final String imagePath;
  final YTColor color;
  final bool coloredLogo;
  final Apis api;
  final String loginRoute;

  const Metadata(
      {required this.name,
      this.beta = false,
      required this.imagePath,
      required this.color,
      this.coloredLogo = false,
      required this.api,
      required this.loginRoute});
}
