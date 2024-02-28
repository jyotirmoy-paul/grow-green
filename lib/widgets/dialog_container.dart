import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../game/utils/game_icons.dart';
import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import '../utils/utils.dart';
import 'game_button.dart';

enum DialogType {
  small,
  large,
}

class DialogContainer extends StatelessWidget {
  final String title;
  final Widget child;

  final Size _size;

  DialogContainer({
    super.key,
    DialogType dialogType = DialogType.small,
    required this.title,
    required this.child,
  }) : _size = dialogType == DialogType.small ? Size(500.s, 300.s) : Size(1000.s, 600.s);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          width: _size.width,
          height: _size.height,
          padding: EdgeInsets.all(10.s),
          decoration: BoxDecoration(
            color: Colors.brown[400],
            borderRadius: BorderRadius.circular(12.s),
            boxShadow: Utils.generalOutlineShadows,
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

                    Text(
                      title,
                      style: TextStyles.s28,
                    ),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GameButton.image(
                        image: GameIcons.close,
                        onTap: () {
                          Navigator.pop(context);
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
      ),
    );
  }
}
