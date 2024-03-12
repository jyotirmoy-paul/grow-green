import 'package:flutter/material.dart';

import '../utils/text_styles.dart';
import 'stylized_text.dart';

class AppName extends StatelessWidget {
  static const appName = 'Grow Green';

  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return StylizedText(
      text: Text(
        appName,
        style: TextStyles.s80,
      ),
    );
  }
}
