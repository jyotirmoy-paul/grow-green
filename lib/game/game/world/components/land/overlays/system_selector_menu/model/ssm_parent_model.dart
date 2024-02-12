import 'package:equatable/equatable.dart';

class SsmParentModel extends Equatable {
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

  @override
  List<Object?> get props => [
        image,
        name,
        description,
        bulletPoints,
      ];
}
