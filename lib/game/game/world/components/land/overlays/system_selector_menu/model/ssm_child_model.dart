import 'package:equatable/equatable.dart';

import '../enum/component_id.dart';

class SsmChildModel extends Equatable {
  final ComponentId componentId;
  final String image;
  final String shortName;
  final bool editable;

  const SsmChildModel({
    this.componentId = ComponentId.none,
    required this.shortName,
    required this.image,
    this.editable = false,
  });

  @override
  List<Object?> get props => [
        componentId,
        image,
        shortName,
        editable,
      ];
}
