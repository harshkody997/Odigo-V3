import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
class DeviceTitleButtonWidgetWeb extends ConsumerWidget {
  const DeviceTitleButtonWidgetWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText(
          title: LocaleKeys.keyDevices.localized,
          style: TextStyles.semiBold.copyWith(
            fontSize: 16,
          ),
        ),

        CommonButton(
          buttonText: LocaleKeys.keyAddDevice.localized,
          fontSize: 13,
          height: 35,
          width: 135,
          onTap: (){
            ref.read(navigationStackController).push(NavigationStackItem.addEditDevice());
          },
        ),
      ],
    ).paddingOnly(bottom: 15);
  }
}
