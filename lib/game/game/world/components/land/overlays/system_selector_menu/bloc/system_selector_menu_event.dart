part of 'system_selector_menu_bloc.dart';

sealed class SystemSelectorMenuEvent extends Equatable {
  const SystemSelectorMenuEvent();

  @override
  List<Object> get props => [];
}

/// view components in a particular system
class SystemSelectorMenuViewComponentsEvent extends SystemSelectorMenuEvent {
  final List<ComponentId> editableComponents;
  final bool cropsWaiting;

  const SystemSelectorMenuViewComponentsEvent({
    this.editableComponents = const [],
    this.cropsWaiting = false,
  });

  @override
  List<Object> get props => [
        editableComponents,
        cropsWaiting,
      ];
}

class SystemSelectorMenuContinueEvent extends SystemSelectorMenuEvent {
  const SystemSelectorMenuContinueEvent();
}

class SystemSelectorMenuBackEvent extends SystemSelectorMenuEvent {
  const SystemSelectorMenuBackEvent();
}

/// child tap event
class SystemSelectorMenuChildTapEvent extends SystemSelectorMenuEvent {
  final int tappedIndex;
  final bool chooseSystem;

  const SystemSelectorMenuChildTapEvent({
    required this.tappedIndex,
    this.chooseSystem = false,
  });

  @override
  List<Object> get props => [
        tappedIndex,
        chooseSystem,
      ];
}

/// choose tree for a system
class SystemSelectorMenuChooseTreesEvent extends SystemSelectorMenuEvent {
  final TreeType tree;
  final int componentTappedIndex;

  const SystemSelectorMenuChooseTreesEvent({
    required this.tree,
    required this.componentTappedIndex,
  });

  @override
  List<Object> get props => [
        tree,
        componentTappedIndex,
      ];
}

/// choose crops for a system
class SystemSelectorMenuChooseCropsEvent extends SystemSelectorMenuEvent {
  final CropType crop;

  const SystemSelectorMenuChooseCropsEvent({
    required this.crop,
  });

  @override
  List<Object> get props => [crop];
}

/// choose fertilizer for a system
class SystemSelectorMenuChooseFertilizerEvent extends SystemSelectorMenuEvent {
  final FertilizerType fertilizer;

  const SystemSelectorMenuChooseFertilizerEvent({
    required this.fertilizer,
  });

  @override
  List<Object> get props => [fertilizer];
}

/// choose agroforestry setup for a system
class SystemSelectorMenuChooseAgroforestrySystemEvent extends SystemSelectorMenuEvent {
  final AgroforestryType agroforestryType;

  const SystemSelectorMenuChooseAgroforestrySystemEvent({
    required this.agroforestryType,
  });

  @override
  List<Object> get props => [agroforestryType];
}
