import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/ssm_child_model.dart';

class MenuChildWidget extends StatelessWidget {
  final SsmChildModel childModel;
  final double diameter;
  final VoidCallback? onTap;

  const MenuChildWidget({
    super.key,
    required this.childModel,
    this.diameter = 100.0,
    this.onTap,
  });

  Widget _buildChild() {
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: childModel.editable ? Colors.greenAccent : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 50,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TODO: image
          FlutterLogo(
            size: diameter * 0.4,
          ),

          /// gap
          const Gap(12.0),

          /// name
          Text(
            childModel.shortName,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (childModel.editable) {
          onTap?.call();
        } else {
          // BotToast.showSimpleNotification(
          //   title: 'Editing ${childModel.shortName} is not available!',
          //   titleStyle: const TextStyle(
          //     color: Colors.black,
          //     fontSize: 32.0,
          //     letterSpacing: 2.0,
          //   ),
          // );
        }
      },
      child: _buildChild(),
    );
  }
}
