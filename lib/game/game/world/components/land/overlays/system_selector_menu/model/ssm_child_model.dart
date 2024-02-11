class SsmChildModel<T> {
  final String image;
  final String shortName;
  final bool tappable;
  final List<T> children;

  const SsmChildModel({
    required this.shortName,
    required this.image,
    this.tappable = true,
    this.children = const [],
  });
}
