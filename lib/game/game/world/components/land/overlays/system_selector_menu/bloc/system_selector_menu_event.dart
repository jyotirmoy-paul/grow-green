part of 'system_selector_menu_bloc.dart';

sealed class SystemSelectorMenuEvent extends Equatable {
  const SystemSelectorMenuEvent();

  @override
  List<Object> get props => [];
}

/// view components in a particular system
class SystemSelectorMenuViewComponentsEvent extends SystemSelectorMenuEvent {
  final bool editable;

  const SystemSelectorMenuViewComponentsEvent({
    required this.editable,
  });

  @override
  List<Object> get props => [editable];
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
  final List<Content<TreeType>> trees;

  const SystemSelectorMenuChooseTreesEvent({
    required this.trees,
  });

  @override
  List<Object> get props => [trees];
}

/// choose crops for a system
class SystemSelectorMenuChooseCropsEvent extends SystemSelectorMenuEvent {
  final Content<CropType> crop;

  const SystemSelectorMenuChooseCropsEvent({
    required this.crop,
  });

  @override
  List<Object> get props => [crop];
}

/// choose fertilizer for a system
class SystemSelectorMenuChooseFertilizerEvent extends SystemSelectorMenuEvent {
  final Content<FertilizerType> fertilizer;

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
