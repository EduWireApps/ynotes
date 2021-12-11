part of school_api;

class Metadata {
  final String name;
  final bool beta;
  final String imagePath;
  final YTColor color;

  const Metadata({required this.name, this.beta = false, required this.imagePath, required this.color});
}
