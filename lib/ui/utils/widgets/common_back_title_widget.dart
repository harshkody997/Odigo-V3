import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonBackTitleWidget extends ConsumerWidget {
  final String title;
  final Function()? onBackTap;

  const CommonBackTitleWidget({super.key, required this.title, this.onBackTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap:
          onBackTap ??
          () {
            ref.read(navigationStackController).pop();
          },
      child: Row(
        children: [
          CommonSVG(strIcon: Assets.svgs.svgBackButtonWithoutBg.keyName).paddingOnly(right: 10),
          CommonText(title: title, style: TextStyles.semiBold.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
