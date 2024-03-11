import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
  final DialogType dialogType;

  Size get _size {
    switch (dialogType) {
      case DialogType.small:
        return Size(500.s, 300.s);

      case DialogType.medium:
        return Size(850.s, 600.s);

      case DialogType.large:
        return Size(1060.s, 700.s);
    }
  }

  const DialogContainer({
    super.key,
    this.dialogType = DialogType.large,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetAnimationDuration: Duration.zero,
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: Container(
        clipBehavior: Clip.none,
        width: _size.width,
        height: _size.height,
        padding: EdgeInsets.all(10.s),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(12.s),
          border: Border.all(
            color: Colors.white,
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
                  /// header content
                  StylizedText(
                    text: Text(
                      title,
                      style: TextStyles.s42,
                    ),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox.square(
                      dimension: 58.s,
                      child: GameButton.text(
                        text: 'X',
                        onTap: () {
                          Navigator.pop(context, DialogEndType.close);
                        },
                        color: Colors.red,
                      ),
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
