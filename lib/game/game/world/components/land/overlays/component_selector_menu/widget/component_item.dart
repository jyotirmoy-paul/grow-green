import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/csm_item_model.dart';

class ComponentItem extends StatelessWidget {
  final CsmItemModel itemModel;
  final VoidCallback? onTap;

  const ComponentItem({
    super.key,
    required this.itemModel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(12.0),
        width: 100.0,
        height: 100.0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// TODO: image
            const FlutterLogo(
              size: 32.0,
            ),

            const Gap(20.0),

            Text(
              itemModel.name,
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
