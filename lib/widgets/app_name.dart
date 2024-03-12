import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import 'stylized_text.dart';

class AppName extends StatelessWidget {
  const AppName({super.key});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'app-name',
      child: Material(
        type: MaterialType.transparency,
        borderOnForeground: false,
        child: Padding(
          padding: EdgeInsets.all(10.s),
          child: StylizedText(
            text: Text(
              context.l10n.appName,
              style: TextStyles.s80,
            ),
          ),
        ),
      ),
    );
  }
}
