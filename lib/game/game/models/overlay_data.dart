import '../world/components/land/components/farm/farm.dart';
import '../world/components/land/components/farm/model/farm_content.dart';
import '../world/components/land/overlays/bill_menu/enums/bill_state.dart';
import '../world/components/land/overlays/system_selector_menu/enum/component_id.dart';
import '../world/components/land/overlays/system_selector_menu/model/component_selection_model.dart';

class OverlayData {
  static const tag = 'OverlayData';

  /// farm
  Farm? _farm;

  set farm(Farm farm) => _farm = farm;
  Farm get farm {
    if (_farm == null) {
      throw Exception('$tag: farm getter invoked with null data. Did you forget to set farm data?');
    }

    return _farm!;
  }

  /// component selection model
  ComponentSelectionModel componentSelectionModel = ComponentSelectionModel(
    componentId: ComponentId.none,
    componentTappedIndex: -1,
  );

  /// farm content
  FarmContent? _farmContent;

  set farmContent(FarmContent farmContent) => _farmContent = farmContent;
  FarmContent get farmContent {
    if (_farmContent == null) {
      throw Exception('$tag: farmContent getter invoked with null data. Did you forget to set the farmContent data?');
    }

    return _farmContent!;
  }

  /// bill state - by default state is purchase everything!
  BillState billState = BillState.purchaseEverything;

  /// stay on system selector menu boolean
  bool stayOnSystemSelectorMenu = false;
}
