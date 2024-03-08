import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/extensions/num_extensions.dart';
import '../utils/text_styles.dart';
import 'button_animator.dart';
import 'stylized_container.dart';
import 'stylized_text.dart';

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
  final Size? size;
  final TextStyle? textStyle;

  const GameButton._({
    super.key,
    required this.type,
    this.color,
    this.onTap,
    this.text,
    this.image,
    this.dataText,
    this.dataImage,
    this.size,
    this.textStyle,
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
    Size? size,
    Color? color,
    TextStyle? textStyle,
  }) {
    return GameButton._(
      key: key,
      type: GameButtonType.text,
      onTap: onTap,
      text: text,
      size: size,
      color: color,
      textStyle: textStyle,
    );
  }

  factory GameButton.image({
    Key? key,
    required String image,
    required VoidCallback onTap,
    Color? bgColor,
    EdgeInsets? padding,
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

  EdgeInsets get _padding {
    switch (type) {
      case GameButtonType.menuItem:
      case GameButtonType.image:
        return EdgeInsets.all(6.s);

      default:
        return EdgeInsets.symmetric(horizontal: 16.s, vertical: 8.s);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ButtonAnimator(
      onPressed: onTap,
      child: StylizedContainer(
        applyColorOpacity: _applyColorOpacity(),
        padding: _padding,
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
                size: size,
                bgColor: color,
              );

            case GameButtonType.image:
              return _ImageButton(
                key: const ValueKey('image-button'),
                image: image!,
                padding: _padding,
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
        /// text
        Flexible(
          child: StylizedText(
            text: Text(
              text,
              style: TextStyles.s30,
            ),
          ),
        ),

        /// gap
        Gap(10.s),

        /// image
        Image.asset(
          image,
          height: 45.s,
        ),
      ],
    );
  }
}

class _ImageButton extends StatelessWidget {
  final String image;
  final EdgeInsets padding;

  const _ImageButton({
    super.key,
    required this.image,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60.s,
      height: 60.s,
      child: Padding(
        padding: padding,
        child: Image.asset(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final Size? size;
  final Color? bgColor;
  final TextStyle? textStyle;

  const _TextButton({
    super.key,
    required this.text,
    this.size,
    this.bgColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Center(
        child: StylizedText(
          text: Text(
            text,
            style: textStyle ?? TextStyles.s24,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
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
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          /// image
          Align(
            alignment: hasExtraData ? Alignment.center : Alignment.topCenter,
            child: Image.asset(
              image,
              height: hasExtraData ? 50.s : 60.s,
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
                      StylizedText(
                        text: Text(
                          dataText!,
                          style: TextStyles.s18,
                        ),
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
                  return StylizedText(
                    text: Text(
                      dataText!,
                      style: TextStyles.s23,
                    ),
                  );
                }

                return const SizedBox.shrink();
              }(),

              /// gap
              const Spacer(),

              /// text
              StylizedText(
                text: Text(
                  text,
                  style: TextStyles.s23,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
