import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/repository/destination_user_management/model/destination_user_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/controller/destination_user_management/destination_user_details_controller.dart';
import 'package:odigov3/ui/destination_user_management/web/helper/destination_user_details_common_tile_widget_web.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class DestinationUserDetailsBottomWidgetWeb extends ConsumerWidget {
  const DestinationUserDetailsBottomWidgetWeb({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final userWatch = ref.read(destinationUserDetailsController);
    DestinationUserData? userData = userWatch.destinationUserDetailsState.success?.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// Contact
        DestinationUserDetailsCommonTileWidgetWeb(title: LocaleKeys.keyMobileNumber.localized, value: userData?.contactNumber??'-',).paddingOnly(bottom: 21),

        /// Email
        DestinationUserDetailsCommonTileWidgetWeb(title: LocaleKeys.keyEmailId.localized, value: userData?.email??'-',).paddingOnly(bottom: 21),

        /// Destination
        DestinationUserDetailsCommonTileWidgetWeb(title: LocaleKeys.keyDestination.localized, value: userData?.destinationName??'-',).paddingOnly(bottom: 21),

        ///Change pass and Back button
        CommonButton(
          height: 43,
          width: 144,
          borderRadius: BorderRadius.circular(7),
          buttonText: LocaleKeys.keyBack.localized,
          backgroundColor: AppColors.transparent,
          borderColor: AppColors.clr9E9E9E,
          buttonTextColor: AppColors.clr787575,
          onTap: (){
            ref.read(navigationStackController).pop();
          },
        ),
      ],
    );
  }
}
