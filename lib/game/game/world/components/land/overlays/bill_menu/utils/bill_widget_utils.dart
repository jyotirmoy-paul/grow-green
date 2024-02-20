import 'package:flutter/material.dart';

import '../../../components/farm/components/system/real_life/utils/cost_calculator.dart';
import '../../../components/farm/components/system/real_life/utils/qty_calculator.dart';
import '../../../components/farm/components/tree/enums/tree_type.dart';
import '../../../components/farm/model/content.dart';
import '../../../components/farm/model/farm_content.dart';
import '../../../components/farm/model/fertilizer/fertilizer_type.dart';
import '../widget/bill_group.dart';
import '../widget/bill_item.dart';

abstract class BillWidgetUtils {
  static Widget buildCropGroup({required FarmContent farmContent}) {
    final crop = farmContent.crop;

    return BillGroup(
      groupHeading: crop != null ? crop.type.name : 'Crop',
      billItems: crop != null
          ? [
              BillItem(title: 'Quantity', value: '${crop.qty.value} ${crop.qty.scale.name}'),
              BillItem(
                title: 'Price',
                value: 'Rs ${CostCalculator.seedCost(
                  cropType: crop.type,
                  seedsRequired: QtyCalculator.getSeedQtyRequireFor(
                    cropType: crop.type,
                    systemType: farmContent.systemType,
                  ),
                )}',
              ),
            ]
          : const [],
    );
  }

  static Widget buildTreeGroup({required FarmContent farmContent}) {
    final trees = farmContent.trees;

    return BillGroup(
      groupHeading: 'Trees',
      billItems: trees != null
          ? trees.map<Widget>(
              (tree) {
                return BillGroup(
                  bgColor: Colors.lightBlueAccent,
                  groupHeading: tree.type.name,
                  billItems: [
                    BillItem(title: 'Quantity', value: '${tree.qty.value} ${tree.qty.scale.name}'),
                    BillItem(
                      title: 'Price',
                      value: 'Rs ${CostCalculator.saplingCost(
                        treeType: tree.type,
                        saplingQty: QtyCalculator.getNumOfSaplingsFor(farmContent.systemType),
                      )}',
                    ),
                  ],
                );
              },
            ).toList()
          : const [],
    );
  }

  static Widget buildFertilizerGroup({required FarmContent farmContent}) {
    final fertilizer = farmContent.fertilizer;

    return BillGroup(
      groupHeading: fertilizer != null ? fertilizer.type.name : 'Fertilizer',
      billItems: fertilizer != null
          ? [
              BillItem(title: 'Quantity', value: '${fertilizer.qty.value} ${fertilizer.qty.scale.name}'),

              /// TODO: update with fertilizer calculator
              const BillItem(
                title: 'Price',
                value: 'Rs 10,000',
              ),
            ]
          : const [],
    );
  }

  static Widget buildTotal({required FarmContent farmContent}) {
    return BillGroup(
      groupHeading: 'Total',
      billItems: [
        BillItem(title: 'Price', value: farmContent.priceOfFarmContent.toString()),
      ],
    );
  }
}
