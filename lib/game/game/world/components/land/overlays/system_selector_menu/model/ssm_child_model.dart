import 'package:growgreen/game/game/world/components/land/overlays/system_selector_menu/enum/component_id.dart';

class SsmChildModel {
  final ComponentId componentId;
  final String image;
  final String shortName;
  final bool editable;

  const SsmChildModel({
    this.componentId = ComponentId.none,
    required this.shortName,
    required this.image,
    this.editable = true,
  });
}
