import 'dart:ui' show VoidCallback;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../enums/system_type.dart';
import '../../../../../../grow_green_game.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../components/farm/components/system/enum/growable.dart';
import '../../../components/farm/components/system/model/qty.dart';
import '../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../components/farm/farm.dart';
import '../../../components/farm/model/content.dart';
import '../../../components/farm/model/farm_content.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../../bill_menu/bill_menu.dart';
import '../../component_selector_menu/component_selector_menu.dart';
import '../enum/component_id.dart';
import '../model/ssm_child_model.dart';
import '../model/ssm_parent_model.dart';

part 'system_selector_menu_event.dart';
part 'system_selector_menu_state.dart';

class SystemSelectorMenuBloc extends Bloc<SystemSelectorMenuEvent, SystemSelectorMenuState> {
  static const tag = 'SystemSelectorMenuBloc';

  final GrowGreenGame game;

  /// call back can be set by host widget
  VoidCallback? onCloseMenu;
  VoidCallback? onChildShow;

  /// systems
  final List<FarmSystem> _farmSystems;
  final List<SsmParentModel> _systemParents = [];
  final List<SsmChildModel> _systemChildren = [];

  late Farm _farm;
  int _lastChoosenSystemIndex = 0;

  SsmParentModel _getParentModelFromSystem(FarmSystem farmSystem) {
    switch (farmSystem.farmSystemType) {
      case FarmSystemType.monoculture:
        final system = farmSystem as MonocultureSystem;
        return SsmParentModel(
          image: '',
          name: system.fertilizer.type.name,
          description: '${system.fertilizer.type.name} Descrition! What is it?',
          bulletPoints: [
            system.crop.type.name,
            system.fertilizer.type.name,
            'Estimated setup price: ${system.estimatedSetupCost}',
          ],
        );

      case FarmSystemType.agroforestry:
        final system = farmSystem as AgroforestrySystem;
        return SsmParentModel(
          image: '',
          name: farmSystem.agroforestryType.name,
          description: '${system.agroforestryType.name} Descrition! What is it?',
          bulletPoints: [
            system.crop.type.name,
            system.trees.fold('', (previousValue, element) => '$previousValue ${element.type.name},'),
            'Estimated setup price: ${system.estimatedSetupCost}',
          ],
        );
    }
  }

  SsmChildModel _getChildModelFromSystem(FarmSystem farmSystem) {
    switch (farmSystem.farmSystemType) {
      case FarmSystemType.monoculture:
        final system = farmSystem as MonocultureSystem;
        return SsmChildModel(
          shortName: system.fertilizer.type.name,
          image: '',
        );

      case FarmSystemType.agroforestry:
        final system = farmSystem as AgroforestrySystem;
        return SsmChildModel(
          shortName: system.agroforestryType.name,
          image: '',
        );
    }
  }

  FarmSystem _getFarmSystemFromContent(FarmContent content) {
    /// TODO: revisit this method to fix the null assertions
    if (content.systemType == FarmSystemType.monoculture) {
      return MonocultureSystem(
        fertilizer: content.fertilizer!,
        crop: content.crop!,
      );
    } else {
      return AgroforestrySystem(
        agroforestryType: content.systemType as AgroforestryType,
        trees: content.trees ?? const [],
        crop: content.crop ?? Content.empty(CropType.bajra),
      );
    }
  }

  FarmContent _getFarmContentFromSystem(FarmSystem farmSystem) {
    Content<CropType>? crop;
    List<Content<TreeType>>? trees;
    Content<FertilizerType>? fertilizer;
    late SystemType systemType;

    if (farmSystem.farmSystemType == FarmSystemType.monoculture) {
      final system = farmSystem as MonocultureSystem;

      crop = system.crop;
      fertilizer = system.fertilizer;
      systemType = FarmSystemType.monoculture;
    } else {
      final system = farmSystem as AgroforestrySystem;

      crop = system.crop;
      trees = system.trees;
      systemType = system.agroforestryType;
    }

    return FarmContent(
      crop: crop,
      trees: trees,
      fertilizer: fertilizer,
      systemType: systemType,
    );
  }

  void _initSystems() {
    for (final system in _farmSystems) {
      _systemChildren.add(_getChildModelFromSystem(system));
      _systemParents.add(_getParentModelFromSystem(system));
    }
  }

  void setFarm(Farm farm) {
    _farm = farm;
  }

  SystemSelectorMenuBloc({
    required this.game,
  })  : _farmSystems = game.gameController.gameDatastore.systemDatastore.systems,
        super(const SystemSelectorMenuNone()) {
    /// prepare
    _initSystems();

    on<SystemSelectorMenuViewComponentsEvent>(_onViewComponentsEvent);
    on<SystemSelectorMenuContinueEvent>(_onContinueEvent);
    on<SystemSelectorMenuChooseTreesEvent>(_onChooseTreesEvent);
    on<SystemSelectorMenuChooseCropsEvent>(_onChooseCropsEvent);
    on<SystemSelectorMenuChooseFertilizerEvent>(_onChooseFertilizerEvent);
    on<SystemSelectorMenuBackEvent>(_onBack);
    on<SystemSelectorMenuChildTapEvent>(_onChildTapEvent);
    on<SystemSelectorMenuChooseAgroforestrySystemEvent>(_onChooseAgroforestrySystemEvent);
  }

  void _onChildTapEvent(SystemSelectorMenuChildTapEvent event, Emitter<SystemSelectorMenuState> emit) {
    /// If a child is tapped in `SystemSelectorMenuChooseSystem` state,
    /// Or `SystemSelectorMenuNone` state that means we must emit choose system event
    if (state is SystemSelectorMenuChooseSystem || state is SystemSelectorMenuNone || event.chooseSystem) {
      return _onChooseSystemEvent(event.tappedIndex, emit);
    }

    if (state is SystemSelectorMenuChooseComponent) {
      return _onChooseComponentsEvent(
        state: state as SystemSelectorMenuChooseComponent,
        index: event.tappedIndex,
        emit: emit,
      );
    }
  }

  void _onChooseSystemEvent(int index, Emitter<SystemSelectorMenuState> emit) {
    _lastChoosenSystemIndex = index;

    emit(
      SystemSelectorMenuChooseSystem(
        selectedIndex: index,
        parentModel: _systemParents[index],
        childModels: _systemChildren,
      ),
    );
  }

  void _onViewComponentsEvent(SystemSelectorMenuViewComponentsEvent event, Emitter<SystemSelectorMenuState> emit) {
    final farmContent = _farm.farmController.farmContent;
    if (farmContent == null) {
      throw Exception('$tag: _onViewComponentsEvent invoked with null farmContent!');
    }

    Log.d('$tag: _onViewComponentsEvent invoked with farmContent: $farmContent');

    final farmSystem = _getFarmSystemFromContent(farmContent);

    emit(
      SystemSelectorMenuChooseComponent(
        parentModel: _getParentModelFromSystem(farmSystem),
        childModels: _getChildModelOfSystem(farmSystem, event.editableComponents),
        farmSystem: farmSystem,
        alreadyFunctioningFarm: true,
        componentsEditable: event.editableComponents,
      ),
    );
  }

  ComponentId _findTappedChild(int index, List<SsmChildModel> children) {
    final child = children[index];

    if (child.componentId == ComponentId.none) {
      throw Exception(
        '$tag: _findTappedChildChild, child with index, $index do not have any component id set . Did you miss to add the componentId?',
      );
    }

    return child.componentId;
  }

  void _onChooseComponentsEvent({
    required SystemSelectorMenuChooseComponent state,
    required int index,
    required Emitter<SystemSelectorMenuState> emit,
  }) {
    final componentId = _findTappedChild(index, state.childModels);

    /// process componentId tap
    Log.d('$tag: _onChooseComponentsEvent choosen with component id: $componentId');

    if (state.alreadyFunctioningFarm) {
      /// The farm is already functioning, we may need to show options for only editable components
      /// And editing anyting / everything will be restricted
      /// TODO: handle taps here!
    } else {
      /// update game component selection model
      game.gameController.overlayData.componentSelectionModel.update(
        componentId: componentId,
        componentTappedIndex: index,
      );

      /// add overlay if not already added
      if (!game.overlays.isActive(ComponentSelectorMenu.overlayName)) {
        game.overlays.add(ComponentSelectorMenu.overlayName);
      }
    }
  }

  List<SsmChildModel> _getChildModelOfSystem(
    FarmSystem farmSystem, [
    List<ComponentId> editableComponents = const [],
  ]) {
    switch (farmSystem.farmSystemType) {
      case FarmSystemType.monoculture:
        final system = farmSystem as MonocultureSystem;
        return [
          SsmChildModel(
            componentId: ComponentId.crop,
            shortName: system.crop.type.name,
            image: '',
            editable: false,
          ),
          SsmChildModel(
            componentId: ComponentId.fertilizer,
            shortName: system.fertilizer.type.name,
            image: '',
            editable: false,
          ),
        ];

      case FarmSystemType.agroforestry:
        final system = farmSystem as AgroforestrySystem;
        return [
          ...system.trees.map(
            (t) {
              return SsmChildModel(
                componentId: ComponentId.trees,
                shortName: t.type.name,
                image: '',
                editable: editableComponents.contains(ComponentId.trees),
              );
            },
          ),
          SsmChildModel(
            componentId: ComponentId.agroforestryLayout,
            shortName: system.agroforestryType.name,
            image: '',
            editable: false,
          ),
          SsmChildModel(
            componentId: ComponentId.crop,
            shortName: system.crop.isEmpty ? 'No Crops!' : system.crop.type.name,
            image: '',
            editable: editableComponents.contains(ComponentId.crop),
          ),
        ];
    }
  }

  void _onBack(SystemSelectorMenuBackEvent event, Emitter<SystemSelectorMenuState> emit) {
    final currentState = state;

    if (currentState is SystemSelectorMenuChooseSystem) {
      /// close
      onCloseMenu?.call();
    } else if (currentState is SystemSelectorMenuChooseComponent) {
      /// If the current state is view only, we can close the menu
      if (currentState.alreadyFunctioningFarm) {
        /// close menu
        return onCloseMenu?.call();
      }

      /// go back to choose system
      emit(
        SystemSelectorMenuChooseSystem(
          selectedIndex: _lastChoosenSystemIndex,
          parentModel: _systemParents[_lastChoosenSystemIndex],
          childModels: _systemChildren,
        ),
      );
    }
  }

  void closeComponentSelection() {
    game.gameController.overlayData.componentSelectionModel.update(
      componentId: ComponentId.none,
      componentTappedIndex: -1,
    );
  }

  void onOutsideWorldTap() {
    closeComponentSelection();
  }

  void _onContinueEvent(SystemSelectorMenuContinueEvent event, Emitter<SystemSelectorMenuState> emit) async {
    final currentState = state;

    if (currentState is SystemSelectorMenuChooseSystem) {
      final system = _farmSystems[currentState.selectedIndex];

      emit(
        SystemSelectorMenuChooseComponent(
          parentModel: _getParentModelFromSystem(system),
          childModels: _getChildModelOfSystem(system),
          farmSystem: system,
        ),
      );

      return onChildShow?.call();
    }

    if (currentState is SystemSelectorMenuChooseComponent) {
      /// If the farm is already functioning, only diff items price would be shown!
      /// And any items (tree) sold, the price would get credited to the user!
      if (currentState.alreadyFunctioningFarm) {
        /// TODO: handle next tap
        return onChildShow?.call();
      }

      /// set data to farm content
      game.gameController.overlayData.farmContent = _getFarmContentFromSystem(
        currentState.farmSystem,
      );

      /// show bill menu
      game.overlays.add(BillMenu.overlayName);

      /// wait until overlay is closed
      while (true) {
        await Future.delayed(const Duration(milliseconds: 1));
        if (!game.overlays.isActive(BillMenu.overlayName)) {
          break;
        }
      }

      if (game.gameController.overlayData.stayOnSystemSelectorMenu) {
        return onChildShow?.call();
      } else {
        return onCloseMenu?.call();
      }
    }
  }

  void _onChooseTreesEvent(SystemSelectorMenuChooseTreesEvent event, Emitter<SystemSelectorMenuState> emit) {
    if (state is! SystemSelectorMenuChooseComponent) {
      throw Exception('$tag: _onChooseTreesEvent invoked with wrong current state: $state');
    }

    final currentState = state as SystemSelectorMenuChooseComponent;
    final farmSystem = currentState.farmSystem;

    if (farmSystem is! AgroforestrySystem) {
      throw Exception('$tag: _onChooseTreesEvent invoked with wrong farm system: $farmSystem');
    }

    final existingTrees = farmSystem.trees;
    existingTrees[event.componentTappedIndex] = Content(
      type: event.tree,
      qty: QtyCalculator.getNumOfSaplingsFor(farmSystem.agroforestryType),
    );

    final newFarmSystem = farmSystem.copyWith(
      trees: List.from(existingTrees),
    );

    emit(
      SystemSelectorMenuChooseComponent(
        parentModel: _getParentModelFromSystem(newFarmSystem),
        childModels: _getChildModelOfSystem(newFarmSystem),
        farmSystem: newFarmSystem,
      ),
    );
  }

  void _onChooseCropsEvent(SystemSelectorMenuChooseCropsEvent event, Emitter<SystemSelectorMenuState> emit) {
    if (state is! SystemSelectorMenuChooseComponent) {
      throw Exception('$tag: _onChooseCropsEvent invoked with wrong current state: $state');
    }

    final currentState = state as SystemSelectorMenuChooseComponent;
    final farmSystem = currentState.farmSystem;

    late FarmSystem newFarmSystem;

    if (farmSystem is AgroforestrySystem) {
      newFarmSystem = farmSystem.copyWith(
        crop: Content(
          type: event.crop,
          qty: QtyCalculator.getSeedQtyRequireFor(
            systemType: farmSystem.agroforestryType,
            cropType: event.crop,
          ),
        ),
      );
    } else if (farmSystem is MonocultureSystem) {
      newFarmSystem = farmSystem.copyWith(
        crop: Content(
          type: event.crop,
          qty: QtyCalculator.getSeedQtyRequireFor(
            systemType: farmSystem.farmSystemType,
            cropType: event.crop,
          ),
        ),
      );
    }

    emit(
      SystemSelectorMenuChooseComponent(
        parentModel: _getParentModelFromSystem(newFarmSystem),
        childModels: _getChildModelOfSystem(newFarmSystem),
        farmSystem: newFarmSystem,
      ),
    );
  }

  void _onChooseFertilizerEvent(SystemSelectorMenuChooseFertilizerEvent event, Emitter<SystemSelectorMenuState> emit) {
    if (state is! SystemSelectorMenuChooseComponent) {
      throw Exception('$tag: _onChooseFertilizerEvent invoked with wrong current state: $state');
    }

    final currentState = state as SystemSelectorMenuChooseComponent;
    final farmSystem = currentState.farmSystem;

    FarmSystem? newFarmSystem;

    if (farmSystem is MonocultureSystem) {
      newFarmSystem = farmSystem.copyWith(
        fertilizer: Content(
          type: event.fertilizer,
          qty: const Qty(value: 100, scale: Scale.kg),
        ),
      );
    }

    if (newFarmSystem == null) return;

    emit(
      SystemSelectorMenuChooseComponent(
        parentModel: _getParentModelFromSystem(newFarmSystem),
        childModels: _getChildModelOfSystem(newFarmSystem),
        farmSystem: newFarmSystem,
      ),
    );
  }

  void _onChooseAgroforestrySystemEvent(
    SystemSelectorMenuChooseAgroforestrySystemEvent event,
    Emitter<SystemSelectorMenuState> emit,
  ) {
    if (state is! SystemSelectorMenuChooseComponent) {
      throw Exception('$tag: _onChooseAgroforestrySystemEvent invoked with wrong current state: $state');
    }

    final currentState = state as SystemSelectorMenuChooseComponent;
    final farmSystem = currentState.farmSystem;

    FarmSystem? newFarmSystem;

    if (farmSystem is AgroforestrySystem) {
      newFarmSystem = farmSystem.copyWith(
        /// update agroforestry system
        agroforestryType: event.agroforestryType,

        /// update trees quantity changes
        trees: farmSystem.trees.map<Content<TreeType>>((existingTree) {
          return Content(type: existingTree.type, qty: QtyCalculator.getNumOfSaplingsFor(event.agroforestryType));
        }).toList(),

        /// update crop quantity changes
        crop: Content(
          type: farmSystem.crop.type,
          qty: QtyCalculator.getSeedQtyRequireFor(systemType: event.agroforestryType, cropType: farmSystem.crop.type),
        ),
      );
    }

    if (newFarmSystem == null) return;

    emit(
      SystemSelectorMenuChooseComponent(
        parentModel: _getParentModelFromSystem(newFarmSystem),
        childModels: _getChildModelOfSystem(newFarmSystem),
        farmSystem: newFarmSystem,
      ),
    );
  }
}
