part of 'farm_composition_menu_cubit.dart';

sealed class FarmCompositionMenuState extends Equatable {
  const FarmCompositionMenuState();

  @override
  List<Object> get props => [];
}

final class FarmCompositionMenuEmpty extends FarmCompositionMenuState {
  const FarmCompositionMenuEmpty();

  @override
  List<Object> get props => [];
}

final class FarmCompositionMenuDisplay extends FarmCompositionMenuState {
  const FarmCompositionMenuDisplay({
    required this.crops,
    required this.trees,
    required this.fertilizers,
    required this.farmer,
  });

  final Content<CropType> crops;
  final Content<TreeType> trees;
  final Content<FertilizerType> fertilizers;
  final FarmerCategory farmer;

  @override
  List<Object> get props => [
        crops,
        trees,
        fertilizers,
        farmer,
      ];
}

final class FarmCompositionMenuEditing extends FarmCompositionMenuState {
  const FarmCompositionMenuEditing({
    required this.requirement,
    required this.crops,
    required this.trees,
    required this.fertilizers,
    required this.farmer,
  });

  final CompositionRequirement requirement;
  final Content<CropType> crops;
  final Content<TreeType> trees;
  final Content<FertilizerType> fertilizers;
  final FarmerCategory farmer;

  bool get isAgroforestrySystem => trees.type != TreeType.none && trees.quantity != 0;
  bool get isEdited => crops.isNotEmpty || trees.isNotEmpty || fertilizers.isNotEmpty || farmer != FarmerCategory.none;

  FarmCompositionMenuEditing copyWith({
    Content<CropType>? crops,
    Content<TreeType>? trees,
    Content<FertilizerType>? fertilizers,
    FarmerCategory? farmer,
  }) {
    return FarmCompositionMenuEditing(
      requirement: requirement, // requirement remains unchanged
      crops: crops ?? this.crops,
      trees: trees ?? this.trees,
      fertilizers: fertilizers ?? this.fertilizers,
      farmer: farmer ?? this.farmer,
    );
  }

  @override
  List<Object> get props => [
        requirement,
        crops,
        trees,
        fertilizers,
        farmer,
      ];
}

class CompositionRequirement {
  const CompositionRequirement({
    required this.monoSeedsQuantity,
    required this.agroSeedsQuantity,
    required this.saplingsQuantity,
    required this.fertilizerQuantity,
    required this.farmerQuantity,
  });

  final int monoSeedsQuantity;
  final int agroSeedsQuantity;
  final int saplingsQuantity;
  final int fertilizerQuantity;
  final int farmerQuantity;
}
