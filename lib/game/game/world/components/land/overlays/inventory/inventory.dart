import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../../../../utils/extensions/list_extensions.dart';
import '../../../../../grow_green_game.dart';
import 'cubit/inventory_cubit.dart';
import 'enums/inventory_options.dart';

class Inventory extends StatefulWidget {
  static const _height = 160.0;

  static const overlayName = 'inventory';
  static Widget builder(BuildContext context, GrowGreenGame game) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: -_height, end: 0.0),
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      builder: (_, animation, child) {
        return Positioned(
          bottom: animation,
          left: 0,
          right: 0,
          child: Opacity(
            opacity: 1 + animation / _height,
            child: child,
          ),
        );
      },
      child: const Inventory(),
    );
  }

  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  @override
  void initState() {
    super.initState();

    context.read<InventoryCubit>().initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// sections
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Row(
              children: InventoryOption.values
                  .map<Widget>(
                    (option) => Expanded(
                      child: BlocBuilder<InventoryCubit, InventoryState>(
                        builder: (context, s) {
                          if (s is InventoryNotInitialized) return const SizedBox.shrink();
                          final state = s as InventoryOptionSelected;

                          final isSelected = option == state.selectedOption;

                          return InkWell(
                            onTap: () {
                              context.read<InventoryCubit>().onOptionSelect(option);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              color: isSelected ? Colors.deepPurpleAccent : Colors.grey,
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                option.name,
                                style: const TextStyle(
                                  fontSize: 26.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                  .addSeparator(const Gap(20.0)),
            ),
          ),

          /// body
          Container(
            width: double.infinity,
            height: Inventory._height,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
            child: BlocConsumer<InventoryCubit, InventoryState>(
              listener: (_, __) {},
              builder: (_, s) {
                if (s is InventoryNotInitialized) return const SizedBox.shrink();

                final state = s as InventoryOptionSelected;

                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  reverseDuration: const Duration(milliseconds: 200),
                  switchInCurve: Curves.easeInOut,
                  switchOutCurve: Curves.easeInOut,
                  child: SingleChildScrollView(
                    key: ValueKey(state.selectedOption),
                    scrollDirection: Axis.horizontal,
                    child: state.inventoryItems.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Text(
                              'No ${state.selectedOption.name} for you!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 44.0,
                                letterSpacing: 2.0,
                              ),
                            ),
                          )
                        : Row(
                            children: state.inventoryItems.map<Widget>(
                              (item) {
                                return InkWell(
                                  onTap: () {
                                    context.read<InventoryCubit>().onInventoryItemTap(item);
                                  },
                                  child: Container(
                                    width: 100.0,
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(fontSize: 22.0),
                                        ),
                                        const FlutterLogo(size: 40.0),
                                        Text(
                                          'X${item.quantity}',
                                          style: const TextStyle(fontSize: 22.0),
                                        ),
                                      ].addSeparator(const Gap(8.0)),
                                    ),
                                  ),
                                );
                              },
                            ).addSeparator(const Gap(20.0)),
                          ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
