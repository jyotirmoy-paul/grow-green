// part of 'system_selector_menu_bloc.dart';

// sealed class SystemSelectorMenuState extends Equatable {
//   SsmParentModel get parentModel;
//   List<SsmChildModel> get childModels;

//   const SystemSelectorMenuState();

//   @override
//   List<Object> get props => [];
// }

// final class SystemSelectorMenuNone extends SystemSelectorMenuState {
//   const SystemSelectorMenuNone();

//   @override
//   List<SsmChildModel> get childModels => const [];

//   @override
//   SsmParentModel get parentModel => SsmParentModel.empty();
// }

// final class SystemSelectorMenuChooseSystem extends SystemSelectorMenuState {
//   final int selectedIndex;

//   @override
//   final SsmParentModel parentModel;

//   @override
//   final List<SsmChildModel> childModels;

//   const SystemSelectorMenuChooseSystem({
//     required this.selectedIndex,
//     required this.parentModel,
//     required this.childModels,
//   });

//   @override
//   List<Object> get props => [
//         selectedIndex,
//         parentModel,
//         childModels,
//       ];
// }

// final class SystemSelectorMenuViewComponent extends SystemSelectorMenuState {
//   @override
//   final SsmParentModel parentModel;

//   @override
//   final List<SsmChildModel> childModels;

//   const SystemSelectorMenuViewComponent({
//     required this.parentModel,
//     required this.childModels,
//   });

//   @override
//   List<Object> get props => [
//         parentModel,
//         childModels,
//       ];
// }

// final class SystemSelectorMenuChooseComponent extends SystemSelectorMenuState {
//   @override
//   final SsmParentModel parentModel;

//   @override
//   final List<SsmChildModel> childModels;

//   final FarmSystem farmSystem;
//   final bool alreadyFunctioningFarm;
//   final List<ComponentId> componentsEditable;

//   const SystemSelectorMenuChooseComponent({
//     required this.parentModel,
//     required this.childModels,
//     required this.farmSystem,
//     this.alreadyFunctioningFarm = false,
//     this.componentsEditable = const [],
//   });

//   @override
//   List<Object> get props => [
//         parentModel,
//         childModels,
//         farmSystem,
//         alreadyFunctioningFarm,
//         componentsEditable,
//       ];
// }
