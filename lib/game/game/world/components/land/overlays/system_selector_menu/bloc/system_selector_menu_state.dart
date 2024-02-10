part of 'system_selector_menu_bloc.dart';

sealed class SystemSelectorMenuState extends Equatable {
  const SystemSelectorMenuState();

  @override
  List<Object> get props => [];
}

final class SystemSelectorMenuInitial extends SystemSelectorMenuState {}

final class SystemSelectorMenuChooseSystem extends SystemSelectorMenuState {
  final int selectedIndex;
  final SsmParentModel parentModel;
  final List<SsmChildModel> childModels;

  const SystemSelectorMenuChooseSystem({
    required this.selectedIndex,
    required this.parentModel,
    required this.childModels,
  });

  @override
  List<Object> get props => [
        selectedIndex,
        parentModel,
        childModels,
      ];
}

final class SystemSelectorMenuViewComponent extends SystemSelectorMenuState {
  final SsmParentModel parentModel;
  final List<SsmChildModel> childModels;

  const SystemSelectorMenuViewComponent({
    required this.parentModel,
    required this.childModels,
  });

  @override
  List<Object> get props => [
        parentModel,
        childModels,
      ];
}

final class SystemSelectorMenuChooseComponent extends SystemSelectorMenuState {
  final SsmParentModel parentModel;
  final List<SsmChildModel> childModels;

  const SystemSelectorMenuChooseComponent({
    required this.parentModel,
    required this.childModels,
  });

  @override
  List<Object> get props => [
        parentModel,
        childModels,
      ];
}
/*

/// choose tree for a system
class SystemSelectorMenuChooseTreesEvent extends SystemSelectorMenuEvent {}

/// choose crops for a system
class SystemSelectorMenuChooseCropsEvent extends SystemSelectorMenuEvent {}

/// choose fertilizer for a system
class SystemSelectorMenuChooseFertilizerEvent extends SystemSelectorMenuEvent {}
*/