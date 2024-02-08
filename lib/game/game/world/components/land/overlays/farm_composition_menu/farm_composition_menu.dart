import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:growgreen/game/game/world/components/land/components/farm/components/farmer/enums/farmer_category.dart';

import '../../../../../../../screens/game_screen/cubit/game_overlay_cubit.dart';
import '../../../../../grow_green_game.dart';
import '../../components/farm/farm.dart';
import 'cubit/farm_composition_menu_cubit.dart';

class FarmCompositionMenu extends StatelessWidget {
  static const overlayName = 'farm-composition-menu';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    final state = context.read<GameOverlayCubit>().state;
    if (state is! GameOverlayFarmComposition) {
      throw Exception('Farm Composition Menu builder was invoked with improper game overlay state: $state!');
    }

    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 100),
      builder: (_, animation, child) {
        return Opacity(
          opacity: animation,
          child: child,
        );
      },
      child: FarmCompositionMenu(farm: state.farm),
    );
  }

  final Farm farm;

  String get _farmName => farm.farmName;

  const FarmCompositionMenu({
    super.key,
    required this.farm,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Material(
        color: Colors.transparent,
        key: ValueKey('$overlayName-$_farmName'),
        // alignment: Alignment.topRight,
        // insetPadding: const EdgeInsets.all(32.0),
        child: Container(
          width: 300.0,
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(32.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // farm name
              Text(
                _farmName,
                style: const TextStyle(
                  fontSize: 28.0,
                ),
              ),

              // separator
              const Gap(24.0),

              // composition section
              BlocBuilder<FarmCompositionMenuCubit, FarmCompositionMenuState>(
                builder: (_, state) {
                  /// TODO: We need an empty farm state widget
                  if (state is FarmCompositionMenuEmpty) {
                    return const Text(
                      'Nothing in farm!',
                      style: TextStyle(fontSize: 32.0),
                    );
                  }

                  if (state is FarmCompositionMenuDisplay) {
                    return _ContentDisplaySection(key: const ValueKey('menu-display'), state: state);
                  }

                  if (state is FarmCompositionMenuEditing) {
                    return _ContentEditingSection(key: const ValueKey('menu-editing'), state: state);
                  }

                  return const SizedBox.shrink();
                },
              ),

              // separator
              const Gap(12.0),

              // buttons
              _ActionSection(key: const ValueKey('menu-action'), farm: farm),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentDisplaySection extends StatelessWidget {
  final FarmCompositionMenuDisplay state;

  const _ContentDisplaySection({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// crop
        ContentRowWidget(
          textA: 'Crop:',
          textB: '${state.crops.type.name} (${state.crops.quantity})',
        ),

        const Gap(12.0),

        /// tree
        ContentRowWidget(
          textA: 'Tree:',
          textB: '${state.trees.type.name} (${state.trees.quantity})',
        ),

        const Gap(12.0),

        /// fertilizer
        ContentRowWidget(
          textA: 'Fertilizer:',
          textB: '${state.fertilizers.type.name} (${state.fertilizers.quantity})',
        ),

        const Gap(12.0),

        /// farmer
        ContentRowWidget(
          textA: 'Farmer:',
          textB: state.farmer.name,
        ),
      ],
    );
  }
}

class _ContentEditingSection extends StatelessWidget {
  final FarmCompositionMenuEditing state;

  const _ContentEditingSection({
    super.key,
    required this.state,
  });

  Widget? _buildTrailingWidget(bool show) {
    if (show) {
      return IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.delete_forever_rounded,
          color: Colors.red,
          size: 32.0,
        ),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// crop
        ContentRowWidget(
          textA: 'Seed:',
          textB:
              '${state.crops.type.name} (${state.crops.quantity} / ${state.isAgroforestrySystem ? state.requirement.agroSeedsQuantity : state.requirement.monoSeedsQuantity})',
          trailing: _buildTrailingWidget(state.crops.isNotEmpty),
        ),

        const Gap(12.0),

        /// tree
        ContentRowWidget(
          textA: 'Sapling:',
          textB: '${state.trees.type.name} (${state.trees.quantity} / ${state.requirement.saplingsQuantity})',
          trailing: _buildTrailingWidget(state.trees.isNotEmpty),
        ),

        const Gap(12.0),

        /// fertilizer
        ContentRowWidget(
          textA: 'Fertilizer:',
          textB:
              '${state.fertilizers.type.name} (${state.fertilizers.quantity} / ${state.requirement.fertilizerQuantity})',
          trailing: _buildTrailingWidget(state.fertilizers.isNotEmpty),
        ),

        const Gap(12.0),

        /// farmer
        ContentRowWidget(
          textA: 'Farmer:',
          textB: state.farmer.name,
          trailing: _buildTrailingWidget(state.farmer != FarmerCategory.none),
        ),
      ],
    );
  }
}

class _ActionSection extends StatelessWidget {
  final Farm farm;
  const _ActionSection({
    super.key,
    required this.farm,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FarmCompositionMenuCubit, FarmCompositionMenuState>(
      builder: (context, state) {
        /// show edit button
        /// TODO: check if farm is not in progress then only edit button can be shown
        if (state is! FarmCompositionMenuEditing) {
          return ElevatedButton(
            onPressed: () {
              context.read<FarmCompositionMenuCubit>().onEditPressed(farm);
            },
            child: const Text(
              'Edit',
              style: TextStyle(fontSize: 22.0),
            ),
          );
        }

        /// show save or cancel button
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /// cancel button
            IconButton(
              onPressed: () {
                context.read<FarmCompositionMenuCubit>().onDuringEditCancelPressed();
              },
              icon: const Icon(
                Icons.cancel,
                color: Colors.red,
                size: 42.0,
              ),
            ),

            /// save button
            IconButton(
              onPressed: () {
                context.read<FarmCompositionMenuCubit>().onDuringEditSavePressed();
              },
              icon: const Icon(
                Icons.check_box,
                color: Colors.green,
                size: 42.0,
              ),
            ),
          ],
        );
      },
    );
  }
}

class ContentRowWidget extends StatelessWidget {
  final String textA;
  final String textB;
  final Widget? trailing;

  const ContentRowWidget({
    super.key,
    required this.textA,
    required this.textB,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          textA,
          style: const TextStyle(
            fontSize: 28.0,
          ),
        ),

        const Spacer(),

        Text(
          textB,
          style: const TextStyle(
            fontSize: 28.0,
          ),
        ),

        // trailing
        if (trailing != null) trailing!,
      ],
    );
  }
}
