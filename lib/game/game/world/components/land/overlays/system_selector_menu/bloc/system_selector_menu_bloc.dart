import 'dart:ui' show VoidCallback;

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../enums/farm_system_type.dart';
import '../../../../../../models/farm_system.dart';
import '../../../components/farm/components/crop/enums/crop_type.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../../../../../../grow_green_game.dart';
import '../model/ssm_child_model.dart';
import '../model/ssm_parent_model.dart';

part 'system_selector_menu_event.dart';
part 'system_selector_menu_state.dart';

class SystemSelectorMenuBloc extends Bloc<SystemSelectorMenuEvent, SystemSelectorMenuState> {
  static const tag = 'SystemSelectorMenuBloc';

  final GrowGreenGame game;

  /// call back can be set by host widget
  VoidCallback? onClose;

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
          name: system.fertilizerType.name,
          description: '${system.fertilizerType.name} Descrition! What is it?',
          bulletPoints: [
            system.crop.name,
            system.fertilizerType.name,
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
            system.crop.name,
            system.tree.fold('', (previousValue, element) => '$previousValue ${element.name},'),
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
          shortName: system.fertilizerType.name,
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

  void _initSystems() {
    for (final system in _farmSystems) {
      _systemChildren.add(_getChildModelFromSystem(system));
      _systemParents.add(_getParentModelFromSystem(system));
    }
  }

  SystemSelectorMenuBloc({
    required this.game,
  })  : _farmSystems = game.gameController.gameDatastore.systemDatastore.systems,
        super(SystemSelectorMenuInitial()) {
    /// prepare
    _initSystems();

    on<SystemSelectorMenuChooseSystemEvent>(_onChooseSystemEvent);
    on<SystemSelectorMenuViewComponentsEvent>(_onViewComponentsEvent);
    on<SystemSelectorMenuChooseComponentsEvent>(_onChooseComponentsEvent);
    on<SystemSelectorMenuContinueEvent>(_onContinueEvent);
    on<SystemSelectorMenuChooseTreesEvent>(_onChooseTreesEvent);
    on<SystemSelectorMenuChooseCropsEvent>(_onChooseCropsEvent);
    on<SystemSelectorMenuChooseFertilizerEvent>(_onChooseFertilizerEvent);
    on<SystemSelectorMenuBackEvent>(_onBack);
  }

  void _onChooseSystemEvent(SystemSelectorMenuChooseSystemEvent event, Emitter<SystemSelectorMenuState> emit) {
    _lastChoosenSystemIndex = event.selectedSystemIndex;

    emit(
      SystemSelectorMenuChooseSystem(
        selectedIndex: event.selectedSystemIndex,
        parentModel: _systemParents[event.selectedSystemIndex],
        childModels: _systemChildren,
      ),
    );
  }

  void _onViewComponentsEvent(SystemSelectorMenuViewComponentsEvent event, Emitter<SystemSelectorMenuState> emit) {}

  void _onChooseComponentsEvent(SystemSelectorMenuChooseComponentsEvent event, Emitter<SystemSelectorMenuState> emit) {}

  List<SsmChildModel> _getChildrenOfSystem(FarmSystem farmSystem) {
    switch (farmSystem.farmSystemType) {
      case FarmSystemType.monoculture:
        final system = farmSystem as MonocultureSystem;
        return [
          SsmChildModel(
            shortName: system.crop.name,
            image: '',
          ),
          SsmChildModel(
            shortName: system.fertilizerType.name,
            image: '',
            tappable: false,
          ),
        ];

      case FarmSystemType.agroforestry:
        final system = farmSystem as AgroforestrySystem;
        return [
          SsmChildModel(
            shortName: system.agroforestryType.name,
            image: '',
            tappable: false,
          ),
          SsmChildModel(
            shortName: system.crop.name,
            image: '',
          ),
          SsmChildModel<TreeType>(
            shortName: 'Trees',
            image: '',
            tappable: false,
            children: system.tree,
          ),
        ];
    }
  }

  void _onBack(SystemSelectorMenuBackEvent event, Emitter<SystemSelectorMenuState> emit) {
    if (state is SystemSelectorMenuChooseSystem) {
      /// close
      onClose?.call();
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

  void _onContinueEvent(SystemSelectorMenuContinueEvent event, Emitter<SystemSelectorMenuState> emit) {
    final currentState = state;

    if (currentState is SystemSelectorMenuChooseSystem) {
      final system = _farmSystems[currentState.selectedIndex];

      return emit(
        SystemSelectorMenuChooseComponent(
          parentModel: _getParentModelFromSystem(system),
          childModels: _getChildrenOfSystem(system),
          farmSystem: system,
        ),
      );
    }

    if (currentState is SystemSelectorMenuChooseComponent) {
      /// TODO: we have to initialize farm
    }
  }

  void _onChooseTreesEvent(SystemSelectorMenuChooseTreesEvent event, Emitter<SystemSelectorMenuState> emit) {
    // if (state is! SystemSelectorMenuChooseComponent) {
    //   throw Exception('$tag: _onChooseTreesEvent invoked with wrong current state: $state');
    // }

    // final currentState = state as SystemSelectorMenuChooseComponent;
    // final farmSystem = currentState.farmSystem;

    // if (farmSystem is! AgroforestrySystem) {
    //   throw Exception('$tag: _onChooseTreesEvent invoked with wrong farm system: $farmSystem');
    // }

    // final newFarmSystem = farmSystem.copyWith(tree: event.trees);

    // SystemSelectorMenuChooseComponent(
    //       parentModel: _getParentModelFromSystem(newFarmSystem),
    //       childModels: _getChildrenOfSystem(newFarmSystem),
    //       farmSystem: newFarmSystem,
    //     ),
  }

  void _onChooseCropsEvent(SystemSelectorMenuChooseCropsEvent event, Emitter<SystemSelectorMenuState> emit) {}

  void _onChooseFertilizerEvent(SystemSelectorMenuChooseFertilizerEvent event, Emitter<SystemSelectorMenuState> emit) {}
}
