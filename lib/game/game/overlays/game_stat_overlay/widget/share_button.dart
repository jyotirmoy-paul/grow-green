import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../l10n/l10n.dart';
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
            text: context.l10n.share,
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
      barrierLabel: context.l10n.share,
      context: context,
      builder: (context) {
        return ShareDialog(id: id);
      },
    );
  }
}

class ShareDialog extends StatefulWidget {
  final String id;
  const ShareDialog({
    super.key,
    required this.id,
  });

  @override
  State<ShareDialog> createState() => _ShareDialogState();
}

class _ShareDialogState extends State<ShareDialog> {
  String get nativeDeeplink => "grow.green://view?id=${widget.id}";

  Future<String> getWebLink() {
    return FirebaseStorageUploadService.getHostedLinkFor(nativeDeeplink);
  }

  String webLink = '';

  void fetch() async {
    webLink = await getWebLink();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      title: context.l10n.shareYourFarm,
      dialogType: DialogType.small,
      child: Center(
        child: webLink.isEmpty ? const CircularProgressIndicator() : shareButtons(webLink),
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
            /// share
            SizedBox(
              width: 100.s,
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

            /// gap
            Gap(40.s),

            /// copy linke
            SizedBox(
              width: 150.s,
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

        /// gap
        Gap(30.s),

        SizedBox(
          width: 230.s,
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
