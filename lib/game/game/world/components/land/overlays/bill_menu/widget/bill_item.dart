import 'package:flutter/material.dart';

class BillItem extends StatelessWidget {
  const BillItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 24.0),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 24.0),
        ),
      ],
    );
  }
}
