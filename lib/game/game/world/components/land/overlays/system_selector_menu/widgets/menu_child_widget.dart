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

  bool get _isChildrenAvailable => childModel.children.isNotEmpty;

  Widget _buildChild() {
    return Container(
      width: diameter,
      height: diameter,
      decoration: const BoxDecoration(
        color: Colors.greenAccent,
        shape: BoxShape.circle,
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
      onTap: onTap,
      child: _isChildrenAvailable
          ? Stack(
              children: [
                ...List<Widget>.generate(
                  childModel.children.length,
                  (index) {
                    return Transform.translate(
                      offset: Offset(-10.0 * index, -10.0 * index),
                      child: Container(
                        width: diameter,
                        height: diameter,
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  },
                ),
                _buildChild(),
              ],
            )
          : _buildChild(),
    );
  }
}
