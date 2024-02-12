import 'package:equatable/equatable.dart';

import '../enum/component_id.dart';

class SsmChildModel extends Equatable {
  final ComponentId componentId;
  final String image;
  final String shortName;

  const SsmChildModel({
    this.componentId = ComponentId.none,
    required this.shortName,
    required this.image,
  });

  @override
  List<Object?> get props => [
        componentId,
        image,
        shortName,
      ];
}
