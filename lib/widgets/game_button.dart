import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import 'button_animator.dart';
import 'stylized_container.dart';

enum GameButtonType {
  menuItem,
  text,
}

class GameButton extends StatelessWidget {
  final GameButtonType type;
  final Color? color;
  final VoidCallback? onTap;
  final String? text;
  final String? image;
  final String? dataText;
  final String? dataImage;

  const GameButton._({
    super.key,
    required this.type,
    this.color,
    this.onTap,
    this.text,
    this.image,
    this.dataText,
    this.dataImage,
  });

  factory GameButton.menuItem({
    Key? key,
    required String text,
    required String image,
    required VoidCallback onTap,
    Color? color,
    String? dataText,
    String? dataImage,
  }) {
    return GameButton._(
      key: key,
      type: GameButtonType.menuItem,
      color: color,
      onTap: onTap,
      text: text,
      image: image,
      dataText: dataText,
      dataImage: dataImage,
    );
  }

  factory GameButton.text({
    Key? key,
    required String text,
    required VoidCallback onTap,
  }) {
    return GameButton._(
      key: key,
      type: GameButtonType.text,
      onTap: onTap,
      text: text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ButtonAnimator(
      onPressed: onTap,
      child: StylizedContainer(
        padding: EdgeInsets.all(12.s),
        color: color,
        child: () {
          switch (type) {
            case GameButtonType.menuItem:
              return _MenuItemButton(
                text: text!,
                image: image!,
                dataImage: dataImage,
                dataText: dataText,
              );

            case GameButtonType.text:
              return _TextButton();
          }
        }(),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  const _TextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class _MenuItemButton extends StatelessWidget {
  final String text;
  final String image;
  final String? dataText;
  final String? dataImage;

  const _MenuItemButton({
    super.key,
    required this.text,
    required this.image,
    this.dataText,
    this.dataImage,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100.s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// image
          Image.asset(
            image,
            height: 60.s,
            fit: BoxFit.contain,
          ),

          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              /// data
              () {
                if (dataText != null && dataImage != null) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /// data
                      Text(
                        dataText!,
                        style: TextStyles.s5,
                      ),

                      /// spacer
                      Gap(4.s),

                      /// image
                      Image.asset(
                        dataImage!,
                        width: 20.s,
                      ),
                    ],
                  );
                } else if (dataText != null) {
                  return Text(dataText!);
                }

                return const SizedBox.shrink();
              }(),

              /// gap
              const Spacer(),

              /// text
              Text(
                text,
                style: TextStyles.s20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
