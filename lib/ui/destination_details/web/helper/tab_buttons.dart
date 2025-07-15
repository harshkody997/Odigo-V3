import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';

class TabButtonsRow extends StatelessWidget {
  const TabButtonsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer(
          builder:(context, ref, child) {
            final destinationDetailsWatch = ref.watch(destinationDetailsController);
            return Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: CommonButton(
                          buttonText: LocaleKeys.keyRobots.localized,
                          backgroundColor: destinationDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.white,
                          borderColor: destinationDetailsWatch.selectedTab == 0 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                          width: context.width * 0.10,
                          buttonTextStyle: TextStyles.medium.copyWith(color: destinationDetailsWatch.selectedTab == 0 ? AppColors.white : AppColors.clrE0E0E0,fontSize: 12),
                          height: context.height * 0.06,
                          onTap: () {
                            destinationDetailsWatch.updateSelectedTab(0);
                          },
                        ),
                      ),
                      SizedBox(width: 18),
                      Flexible(
                        child: CommonButton(
                          buttonText: LocaleKeys.keyStore.localized,
                          backgroundColor: destinationDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.white,
                          borderColor: destinationDetailsWatch.selectedTab == 1 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                          width: context.width * 0.1,
                          height: context.height * 0.06,
                          buttonTextStyle: TextStyles.medium.copyWith(color: destinationDetailsWatch.selectedTab == 1 ? AppColors.white : AppColors.clrE0E0E0,fontSize: 12),
                          onTap: () {
                            destinationDetailsWatch.updateSelectedTab(1);
                          },
                        ),
                      ),
                      SizedBox(width: 18),
                      Flexible(
                        child: CommonButton(
                          buttonText: LocaleKeys.keyFloor.localized,
                          backgroundColor: destinationDetailsWatch.selectedTab == 3 ? AppColors.clr2997FC : AppColors.white,
                          borderColor: destinationDetailsWatch.selectedTab == 3 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                          width: context.width * 0.1,
                          height: context.height * 0.06,
                          buttonTextStyle: TextStyles.medium.copyWith(color: destinationDetailsWatch.selectedTab == 3 ? AppColors.white : AppColors.clrE0E0E0,fontSize: 12),
                          onTap: () {
                            destinationDetailsWatch.updateSelectedTab(3);
                          },
                        ),
                      ),
                      SizedBox(width: 18),
                      Flexible(
                        child: CommonButton(
                          buttonText: LocaleKeys.keyPrice.localized,
                          backgroundColor: destinationDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.white,
                          borderColor: destinationDetailsWatch.selectedTab == 2 ? AppColors.clr2997FC : AppColors.clrE0E0E0,
                          width: context.width * 0.1,
                          height: context.height * 0.06,
                          buttonTextStyle: TextStyles.medium.copyWith(color: destinationDetailsWatch.selectedTab == 2 ? AppColors.white : AppColors.clrE0E0E0,fontSize: 12),
                          onTap: () {
                            destinationDetailsWatch.updateSelectedTab(2);
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                if((destinationDetailsWatch.selectedTab == 0) || (destinationDetailsWatch.selectedTab == 1))
                  CommonButton(
                  buttonText: destinationDetailsWatch.selectedTab == 0 ? LocaleKeys.keyAssignNewRobot.localized : LocaleKeys.keyAssignNewStore.localized,
                  isPrefixEnable: true,
                  width: context.width * 0.13,
                  leftImage: Assets.svgs.svgPlus.keyName,
                  buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.white,fontSize: 12),
                  height: context.height * 0.06,
                  onTap: () {
                    if( destinationDetailsWatch.selectedTab == 0 ){
                      ref.read(navigationStackController).push(NavigationStackItemAssignRobotPage());
                    }else{
                      ref.read(navigationStackController).push(NavigationStackItemAssignStorePage());
                    }
                  },
                )

              ],
            );
          },
      ),
    );
  }
}
