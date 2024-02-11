class SsmParentModel {
  final String image;
  final String name;
  final String description;
  final List<String> bulletPoints;

  const SsmParentModel({
    required this.image,
    required this.name,
    required this.description,
    required this.bulletPoints,
  });

  factory SsmParentModel.empty() {
    return const SsmParentModel(
      image: '',
      name: '',
      description: '',
      bulletPoints: [],
    );
  }
}
