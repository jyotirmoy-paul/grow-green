import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../../../../../../../utils/extensions/list_extensions.dart';

class BillGroup extends StatelessWidget {
  const BillGroup({
    super.key,
    required this.groupHeading,
    this.billItems = const [],
    this.bgColor = Colors.greenAccent,
  });

  final String groupHeading;
  final List<Widget> billItems;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: billItems.isEmpty ? Colors.grey : bgColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// heading
          Text(groupHeading, style: const TextStyle(fontSize: 28.0)),

          /// items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              children: billItems.addSeparator(const Gap(8.0)),
            ),
          ),
        ],
      ),
    );
  }
}
