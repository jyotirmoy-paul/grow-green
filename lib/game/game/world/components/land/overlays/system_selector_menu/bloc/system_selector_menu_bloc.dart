import 'dart:ui' show VoidCallback;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../component_selector_menu/component_selector_menu.dart';

import '../../../../../../../../services/log/log.dart';
import '../../../../../../enums/agroforestry_type.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../grow_green_game.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../components/farm/model/content.dart';
import '../../../components/farm/model/farm_content.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
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

  /// systems
  final List<FarmSystem> _farmSystems;
  final List<SsmParentModel> _systemParents = [];
  final List<SsmChildModel> _systemChildren = [];

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

  FarmContent _getFarmContentFromSystem(FarmSystem farmSystem) {
    Content<CropType>? crop;
    List<Content<TreeType>>? trees;
    Content<FertilizerType>? fertilizer;
    AgroforestryType? agroforestryType;

    if (farmSystem.farmSystemType == FarmSystemType.monoculture) {
      final system = farmSystem as MonocultureSystem;

      crop = system.crop;
      fertilizer = system.fertilizer;
    } else {
      final system = farmSystem as AgroforestrySystem;

      crop = system.crop;
      trees = system.trees;
      agroforestryType = system.agroforestryType;
    }

    return FarmContent(
      crop: crop,
      trees: trees,
      fertilizer: fertilizer,
      agroforestryType: agroforestryType,
    );
  }

  void _initSystems() {
    for (final system in _farmSystems) {
      _systemChildren.add(_getChildModelFromSystem(system));
      _systemParents.add(_getParentModelFromSystem(system));
    }
  }

  SystemSelectorMenuBloc({
    required this.game,
  })  : _farmSystems = game.gameController.gameDatastore.systemDatastore.systems,
        super(const SystemSelectorMenuInitial()) {
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
    if (state is SystemSelectorMenuChooseSystem || state is SystemSelectorMenuInitial || event.chooseSystem) {
      return _onChooseSystemEvent(event.tappedIndex, emit);
    }

    if (state is SystemSelectorMenuChooseComponent) {
      _onChooseComponentsEvent(event.tappedIndex, emit);
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
    /// TODO: create farm system from farmcontroller's content to show user the current composition
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

  void _onChooseComponentsEvent(int index, Emitter<SystemSelectorMenuState> emit) {
    if (state is! SystemSelectorMenuChooseComponent) {
      throw Exception('$tag: _onChooseComponentsEvent invoked with wrong current state: $state');
    }

    final currentState = state as SystemSelectorMenuChooseComponent;
    final componentId = _findTappedChild(index, currentState.childModels);

    /// process componentId tap
    Log.d('$tag: _onChooseComponentsEvent choosen with component id: $componentId');

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

  List<SsmChildModel> _getChildModelOfSystem(FarmSystem farmSystem) {
    switch (farmSystem.farmSystemType) {
      case FarmSystemType.monoculture:
        final system = farmSystem as MonocultureSystem;
        return [
          SsmChildModel(
            componentId: ComponentId.crop,
            shortName: system.crop.type.name,
            image: '',
          ),
          SsmChildModel(
            componentId: ComponentId.fertilizer,
            shortName: system.fertilizer.type.name,
            image: '',
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
              );
            },
          ),
          SsmChildModel(
            componentId: ComponentId.agroforestryLayout,
            shortName: system.agroforestryType.name,
            image: '',
          ),
          SsmChildModel(
            componentId: ComponentId.crop,
            shortName: system.crop.type.name,
            image: '',
          ),
        ];
    }
  }

  void _onBack(SystemSelectorMenuBackEvent event, Emitter<SystemSelectorMenuState> emit) {
    if (state is SystemSelectorMenuChooseSystem) {
      /// close
      onCloseMenu?.call();
    } else if (state is SystemSelectorMenuChooseComponent) {
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

  void _onContinueEvent(SystemSelectorMenuContinueEvent event, Emitter<SystemSelectorMenuState> emit) {
    final currentState = state;

    if (currentState is SystemSelectorMenuChooseSystem) {
      final system = _farmSystems[currentState.selectedIndex];

      return emit(
        SystemSelectorMenuChooseComponent(
          parentModel: _getParentModelFromSystem(system),
          childModels: _getChildModelOfSystem(system),
          farmSystem: system,
        ),
      );
    }

    if (currentState is SystemSelectorMenuChooseComponent) {
      final farm = game.gameController.overlayData.farm;

      /// initialize farm with system
      farm.farmController.updateFarmComposition(
        farmContent: _getFarmContentFromSystem(currentState.farmSystem),
      );

      /// close
      onCloseMenu?.call();

      return;
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

    final newFarmSystem = farmSystem.copyWith(trees: event.trees);

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
      newFarmSystem = farmSystem.copyWith(crop: event.crop);
    } else if (farmSystem is MonocultureSystem) {
      newFarmSystem = farmSystem.copyWith(crop: event.crop);
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
      newFarmSystem = farmSystem.copyWith(fertilizer: event.fertilizer);
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
      newFarmSystem = farmSystem.copyWith(agroforestryType: event.agroforestryType);
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
