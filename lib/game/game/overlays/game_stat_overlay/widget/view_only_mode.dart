import 'package:flutter/material.dart';

import '../../../../../utils/extensions/num_extensions.dart';
import '../../../../../utils/text_styles.dart';
import '../../../../../widgets/stylized_container.dart';
import '../../../../../widgets/stylized_text.dart';

class ViewOnlyMode extends StatelessWidget {
  const ViewOnlyMode({super.key});

  @override
  Widget build(BuildContext context) {
    return StylizedContainer(
      color: Colors.black.withOpacity(0.3),
      padding: EdgeInsets.symmetric(horizontal: 8.s),
      margin: EdgeInsets.zero,
      isReflectionEnabled: false,
      child: SizedBox(
          width: 200.s,
          height: 60.s,
          child: StylizedText(
            text: Text(
              'View Only Mode',
              style: TextStyles.s23,
            ),
          )),
    );
  }
}
