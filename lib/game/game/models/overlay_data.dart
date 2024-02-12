import '../world/components/land/overlays/system_selector_menu/enum/component_id.dart';
import '../world/components/land/overlays/system_selector_menu/model/component_selection_model.dart';

import '../world/components/land/components/farm/farm.dart';

class OverlayData {
  static const tag = 'OverlayData';

  Farm? _farm;

  set farm(Farm farm) => _farm = farm;
  Farm get farm {
    if (_farm == null) {
      throw Exception('$tag: farm getter invoked with null data. Did you forget to set farm data?');
    }

    return _farm!;
  }

  ComponentSelectionModel componentSelectionModel = ComponentSelectionModel(
    componentId: ComponentId.none,
    componentTappedIndex: -1,
  );
}
