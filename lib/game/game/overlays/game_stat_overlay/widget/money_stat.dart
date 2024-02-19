import 'package:flutter/material.dart';

import '../../../services/game_services/monetary/monetary_service.dart';

class MoneyStat extends StatelessWidget {
  final MonetaryService monetaryService;

  const MoneyStat({
    super.key,
    required this.monetaryService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(12.0),
      child: StreamBuilder(
        stream: monetaryService.balanceStream,
        initialData: monetaryService.balance,
        builder: (context, snapshot) {
          final money = snapshot.data;
          if (money == null) return const CircularProgressIndicator();

          return Text(
            'Rs ${money.formattedRupees}',
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 1.0,
              fontSize: 24.0,
            ),
          );
        },
      ),
    );
  }
}
