part of 'system_selector_menu_bloc.dart';

sealed class SystemSelectorMenuEvent extends Equatable {
  const SystemSelectorMenuEvent();

  @override
  List<Object> get props => [];
}

/// choose agriculture system
class SystemSelectorMenuChooseSystemEvent extends SystemSelectorMenuEvent {}

/// view components in a particular system
class SystemSelectorMenuViewComponentsEvent extends SystemSelectorMenuEvent {}

/// choose components in a particular system
class SystemSelectorMenuChooseComponentsEvent extends SystemSelectorMenuEvent {}

/// choose tree for a system
class SystemSelectorMenuChooseTreesEvent extends SystemSelectorMenuEvent {}

/// choose crops for a system
class SystemSelectorMenuChooseCropsEvent extends SystemSelectorMenuEvent {}

/// choose fertilizer for a system
class SystemSelectorMenuChooseFertilizerEvent extends SystemSelectorMenuEvent {}
