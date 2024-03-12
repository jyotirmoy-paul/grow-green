import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../game/utils/game_assets.dart';
import '../../../widgets/app_name.dart';
import '../cubit/splash_screen_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashScreenCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(GameAssets.background),
          fit: BoxFit.cover,
        ),
      ),
      child: const Center(
        child: AppName(),
      ),
    );
  }
}
