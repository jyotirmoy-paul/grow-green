import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../game/utils/game_icons.dart';
import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import 'game_button.dart';
import 'stylized_text.dart';

enum DialogType {
  small,
  medium,
  large,
}

enum DialogEndType {
  close,
}

class DialogContainer extends StatelessWidget {
  final String title;
  final Widget child;

  final Size _size;

  static Size _determineSize(DialogType dialogType) {
    switch (dialogType) {
      case DialogType.small:
        return Size(500.s, 300.s);

      case DialogType.medium:
        return Size(780.s, 500.s);

      case DialogType.large:
        return Size(1060.s, 700.s);
    }
  }

  DialogContainer({
    super.key,
    DialogType dialogType = DialogType.small,
    required this.title,
    required this.child,
  }) : _size = _determineSize(dialogType);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration.zero,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.all(10.s),
        decoration: BoxDecoration(
          color: Colors.brown[400],
          borderRadius: BorderRadius.circular(12.s),
          border: Border.all(
            color: Colors.black,
            width: 4.s,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        ),
        child: Column(
          children: [
            /// header
            SizedBox(
              height: 50.s,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  /// background shine
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      height: 25.s,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.30),
                        borderRadius: BorderRadius.circular(6.s),
                      ),
                    ),
                  ),

                  /// header content
                  StylizedText(
                    text: Text(
                      title,
                      style: TextStyles.s42,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GameButton.image(
                      image: GameIcons.close,
                      onTap: () {
                        Navigator.pop(context, DialogEndType.close);
                      },
                      bgColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),

            Gap(10.s),

            /// body
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown[50],
                  borderRadius: BorderRadius.circular(12.s),
                ),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
