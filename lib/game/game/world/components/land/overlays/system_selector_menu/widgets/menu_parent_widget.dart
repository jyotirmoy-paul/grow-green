import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../model/ssm_parent_model.dart';

class MenuParentWidget extends StatelessWidget {
  final double diameter;
  final SsmParentModel parentModel;

  const MenuParentWidget({
    super.key,
    required this.parentModel,
    this.diameter = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: diameter,
      height: diameter,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(-5, -5),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// TODO: image
          FlutterLogo(
            size: diameter * 0.2,
          ),

          /// gap
          const Gap(12.0),

          /// name
          Text(
            parentModel.description,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20.0,
            ),
          ),

          /// gap
          const Gap(12.0),

          /// bullet
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: parentModel.bulletPoints.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  const Icon(
                    Icons.fiber_manual_record,
                    size: 20.0,
                    color: Colors.red,
                  ),
                  Flexible(
                    child: Text(
                      parentModel.bulletPoints[index],
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return const Gap(5.0);
            },
          ),
        ],
      ),
    );
  }
}
