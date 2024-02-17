import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/calender_cubit.dart';

class CalenderStat extends StatelessWidget {
  const CalenderStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.all(24.0),
      padding: const EdgeInsets.all(12.0),
      child: BlocBuilder<CalenderCubit, CalenderState>(
        builder: (context, state) {
          if (state.isEmpty) return const SizedBox();

          return Text(
            '${state.month}, ${state.year}',
            style: const TextStyle(
              color: Colors.black,
              letterSpacing: 1.0,
              fontSize: 32.0,
            ),
          );
        },
      ),
    );
  }
}
