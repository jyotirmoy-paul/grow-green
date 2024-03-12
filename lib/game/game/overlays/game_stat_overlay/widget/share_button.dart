import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../services/auth/auth.dart';
import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../utils/utils.dart';
import '../../../../../widgets/dialog_container.dart';
import '../../../../../widgets/game_button.dart';
import 'package:flutter/services.dart';

import '../../../../../widgets/stylized_text.dart';
import '../../../world/components/land/overlays/achievement/GwalletService.dart';
import 'firebase_storage_service.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoggedIn) {
          final user = state.user;
          return GameButton.text(
            text: "Share",
            onTap: () {
              showShareDialog(context, user.id);
            },
            textStyle: TextStyles.s30,
            color: Colors.transparent,
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  void showShareDialog(BuildContext context, String id) {
    Utils.showNonAnimatedDialog(
      barrierLabel: "Share",
      context: context,
      builder: (context) {
        return ShareDialog(id: id);
      },
    );
  }
}

class ShareDialog extends StatelessWidget {
  final String id;
  const ShareDialog({
    super.key,
    required this.id,
  });

  String get nativeDeeplink => "grow.green://view?id=$id";
  Future<String> getWebLink() async {
    return await FirebaseStorageUploadService.getHostedLinkFor(nativeDeeplink);
  }

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      title: "Show your farm to world",
      dialogType: DialogType.small,
      child: Center(
        child: FutureBuilder<String>(
          future: getWebLink(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return shareButtons(snapshot.data!);
              } else {
                return StylizedText(
                  text: Text(
                    "Something went wrong",
                    style: TextStyles.s23,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }

  Column shareButtons(String weblink) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 150.s,
              height: 60.s,
              child: GameButton.text(
                text: "Share",
                onTap: () {
                  final message = "Hey, check out my village on Grow Green using this link: $weblink";
                  Share.share(message);
                },
                textStyle: TextStyles.s30,
                color: Colors.green,
              ),
            ),
            Gap(40.s),
            SizedBox(
              width: 150.s,
              height: 60.s,
              child: GameButton.text(
                text: "Copy link",
                onTap: () {
                  Clipboard.setData(ClipboardData(text: weblink));
                },
                textStyle: TextStyles.s30,
                color: Colors.red,
              ),
            ),
          ],
        ),
        Gap(30.s),
        SizedBox(
          width: 180.s,
          height: 60.s,
          child: GameButton.text(
            text: "Add to Gwallet",
            onTap: () async {
              await GwalletService.claimGwalletFromFarmView(weblink);
            },
            textStyle: TextStyles.s30,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
