part of 'system_selector_menu_bloc.dart';

sealed class SystemSelectorMenuEvent extends Equatable {
  const SystemSelectorMenuEvent();

  @override
  List<Object> get props => [];
}

/// choose agriculture system
class SystemSelectorMenuChooseSystemEvent extends SystemSelectorMenuEvent {
  final int selectedSystemIndex;

  const SystemSelectorMenuChooseSystemEvent({
    required this.selectedSystemIndex,
  });

  @override
  List<Object> get props => [
        selectedSystemIndex,
      ];
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

/// choose components in a particular system
class SystemSelectorMenuChooseComponentsEvent extends SystemSelectorMenuEvent {
  final FarmSystem farmSystem;

  const SystemSelectorMenuChooseComponentsEvent({
    required this.farmSystem,
  });

  @override
  List<Object> get props => [farmSystem];
}

class SystemSelectorMenuContinueEvent extends SystemSelectorMenuEvent {
  const SystemSelectorMenuContinueEvent();
}

class SystemSelectorMenuBackEvent extends SystemSelectorMenuEvent {
  const SystemSelectorMenuBackEvent();
}

/// choose tree for a system
class SystemSelectorMenuChooseTreesEvent extends SystemSelectorMenuEvent {
  final List<TreeType> trees;

  const SystemSelectorMenuChooseTreesEvent({
    required this.trees,
  });

  @override
  List<Object> get props => [trees];
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
