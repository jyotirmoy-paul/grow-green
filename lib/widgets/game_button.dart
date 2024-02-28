import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import 'button_animator.dart';
import 'stylized_container.dart';

enum GameButtonType {
  menuItem,
  text,
  image,
  textImage,
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

  factory GameButton.image({
    Key? key,
    required String image,
    required VoidCallback onTap,
    Color? bgColor,
  }) {
    return GameButton._(
      key: key,
      type: GameButtonType.image,
      image: image,
      onTap: onTap,
      color: bgColor,
    );
  }

  factory GameButton.textImage({
    Key? key,
    required String text,
    required String image,
    required VoidCallback onTap,
    Color? bgColor,
  }) {
    return GameButton._(
      key: key,
      type: GameButtonType.textImage,
      onTap: onTap,
      text: text,
      image: image,
      color: bgColor,
    );
  }

  bool _applyColorOpacity() {
    switch (type) {
      case GameButtonType.menuItem:
        return true;

      default:
        return false;
    }
  }

  EdgeInsets _padding() {
    switch (type) {
      case GameButtonType.image:
        return EdgeInsets.all(6.s);

      default:
        return EdgeInsets.all(12.s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonAnimator(
      onPressed: onTap,
      child: StylizedContainer(
        applyColorOpacity: _applyColorOpacity(),
        padding: _padding(),
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
              return _TextButton(
                key: const ValueKey('text-button'),
                text: text!,
              );

            case GameButtonType.image:
              return _ImageButton(
                key: const ValueKey('image-button'),
                image: image!,
              );

            case GameButtonType.textImage:
              return _TextImageButton(
                key: const ValueKey('text-image'),
                text: text!,
                image: image!,
              );
          }
        }(),
      ),
    );
  }
}

class _TextImageButton extends StatelessWidget {
  final String text;
  final String image;

  const _TextImageButton({
    super.key,
    required this.text,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
          style: TextStyles.s28,
        ),
        Gap(5.s),
        Image.asset(
          image,
          height: 50.s,
        ),
      ],
    );
  }
}

class _ImageButton extends StatelessWidget {
  final String image;
  const _ImageButton({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      fit: BoxFit.contain,
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;

  const _TextButton({
    super.key,
    required this.text,
  });

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

  bool get hasExtraData => dataText != null || dataImage != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 100.s,
      child: Stack(
        alignment: Alignment.center,
        children: [
          /// image
          Align(
            alignment: hasExtraData ? Alignment.center : Alignment.topCenter,
            child: Image.asset(
              image,
              height: hasExtraData ? 60.s : 70.s,
              fit: BoxFit.contain,
            ),
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
                        style: TextStyles.s12,
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
                  return Text(
                    dataText!,
                    style: TextStyles.s20,
                  );
                }

                return const SizedBox.shrink();
              }(),

              /// gap
              const Spacer(),

              /// text
              Text(
                text,
                style: TextStyles.s20,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
