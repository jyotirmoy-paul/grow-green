import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../../screens/game_screen/cubit/game_overlay_cubit.dart';
import '../../../../../grow_green_game.dart';
import '../../components/farm/farm.dart';
import '../../components/farm/model/farm_content.dart';
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
  final FarmContent? farmContent;

  String get _farmName => farm.farmName;

  FarmCompositionMenu({
    super.key,
    required this.farm,
  }) : farmContent = farm.farmController.farmContent;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      key: ValueKey('$overlayName-$_farmName'),
      alignment: Alignment.topRight,
      insetPadding: const EdgeInsets.all(32.0),
      child: Container(
        width: 100.0,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// farm name
            Text(
              _farmName,
              style: const TextStyle(
                fontSize: 28.0,
              ),
            ),

            /// farm compositions
            const Gap(24.0),

            /// crop
            ContentRowWidget(
              textA: 'Crop:',
              textB: farmContent?.crop.type.name ?? 'NA',
            ),

            const Gap(12.0),

            /// tree
            ContentRowWidget(
              textA: 'Tree:',
              textB: farmContent?.tree?.type.name ?? 'NA',
            ),

            const Gap(12.0),

            /// fertilizer
            ContentRowWidget(
              textA: 'Fertilizer:',
              textB: farmContent?.fertilizer?.type.name ?? 'NA',
            ),

            const Gap(12.0),

            /// farmer
            ContentRowWidget(
              textA: 'Farmer:',
              textB: farmContent?.farmer.name ?? 'NA',
            ),

            const Gap(12.0),

            BlocBuilder<FarmCompositionMenuCubit, FarmCompositionMenuState>(
              builder: (context, state) {
                /// show edit button
                if (state is FarmCompositionMenuDisplay) {
                  return ElevatedButton(
                    onPressed: () {
                      context.read<FarmCompositionMenuCubit>().onEditPressed();
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
            ),
          ],
        ),
      ),
    );
  }
}

class ContentRowWidget extends StatelessWidget {
  final String textA;
  final String textB;

  const ContentRowWidget({
    super.key,
    required this.textA,
    required this.textB,
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
      ],
    );
  }
}
