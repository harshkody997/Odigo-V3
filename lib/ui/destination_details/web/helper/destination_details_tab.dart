import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination_details/web/helper/change_password_dialog.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';

class DestinationDetailsTab extends ConsumerStatefulWidget {
  const DestinationDetailsTab({Key? key}) : super(key: key);

  @override
  ConsumerState<DestinationDetailsTab> createState() => _DestinationDetailsTabState();
}

class _DestinationDetailsTabState extends ConsumerState<DestinationDetailsTab> {
  ///Build
  @override
  Widget build(BuildContext context) {
    final destinationDetailsWatch = ref.watch(destinationDetailsController);
    final destinationData = destinationDetailsWatch.destinationDetailsState.success?.data;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///network image
              ClipOval(
                child: CacheImage(
                  imageURL: destinationData?.imageUrl ?? '',
                  height: context.height * 0.17,
                  width: context.height * 0.17,
                ),
              ),

              SizedBox(width: context.width * 0.032),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    /// destination name, buttons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// destination name
                        Expanded(child: CommonText(title: destinationData?.name ?? '',maxLines: 5, style: TextStyles.bold.copyWith(fontSize: 22))),
                        ///buttons
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CommonButton(
                              onTap: () {
                                showCommonWebDialog(
                                  context: context,
                                  keyBadge: destinationDetailsWatch.changePasswordDialogKey,
                                  dialogBody: ChangeDestinationPasswordDialog(),
                                  height: 0.54,
                                  width: 0.4,
                                );
                              },
                              buttonText: LocaleKeys.keyChangePassword.localized,
                              backgroundColor: AppColors.clrF4F5F7,
                              height: context.height * 0.06,
                              width: context.width * 0.135,
                              borderRadius: BorderRadius.circular(10),
                              borderColor: AppColors.gray606060,
                              borderWidth: 1.0,
                              buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.gray606060),
                            ),
                            SizedBox(width: context.width * 0.018),
                            Visibility(
                              visible: ref.watch(drawerController).isMainScreenCanEdit && destinationData?.active == true,
                              child: CommonButton(
                                onTap: () {
                                  ref.read(manageDestinationController).disposeController();
                                  ref.read(navigationStackController).push(NavigationStackItem.manageDestination(destinationUuid: destinationData?.uuid));
                                },
                                buttonText: LocaleKeys.keyEdit.localized,
                                leftImage: Assets.svgs.svgEditPen.keyName,
                                backgroundColor: AppColors.clrF4F5F7,
                                height: context.height * 0.06,
                                width: context.width * 0.06,
                                borderRadius: BorderRadius.circular(10),
                                borderColor: AppColors.gray606060,
                                borderWidth: 1.0,
                                buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.gray606060),
                              ),
                            ),
                          ],
                        ).paddingOnly(left: context.width * 0.01),
                      ],
                    ),
                    // SizedBox(height: context.height * 0.025),
                    Row(
                      children: [
                        HeaderContent(LocaleKeys.keyType.localized, destinationData?.destinationTypeName ?? '-'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyFloor.localized, destinationData?.totalFloor.toString() ?? '0'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyCountry.localized, destinationData?.countryName ?? '-'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(
                          LocaleKeys.keyStatus.localized,
                          destinationData?.active == true ? LocaleKeys.keyActive.localized : LocaleKeys.keyPending.localized,
                          subTitleColor: destinationData?.active == true ? LocaleKeys.keyActive.localized.getStatusColor() : LocaleKeys.keyPending.localized.getStatusColor(),
                        ),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyOwnerName.localized, destinationData?.ownerName ?? '-'),
                      ],
                    ),
                    SizedBox(height: context.height * 0.025),
                    SizedBox(
                      child: HeaderContent(
                        LocaleKeys.keyAddress.localized,
                        '${destinationData?.houseNumber ?? '-'} ${destinationData?.addressLine1 ?? '-'} ${destinationData?.addressLine2 ?? '-'} ${destinationData?.streetName ?? '-'}  ${destinationData?.landmark ?? '-'} ${destinationData?.cityName ?? '-'} ${destinationData?.stateName ?? '-'} ${destinationData?.postalCode ?? '-'}'
                      ),
                    ),
                    SizedBox(height: context.height * 0.025),

                    Wrap(
                      children: [
                        HeaderContent(LocaleKeys.keyEmailID.localized, destinationData?.email ?? '-'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyContact.localized, destinationData?.contactNumber ?? '-'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyFillerPrice.localized, destinationData?.fillerPrice.toString() ?? '0'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyPremiumPrice.localized, destinationData?.premiumPrice.toString() ?? '0'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                        HeaderContent(LocaleKeys.keyTimezone.localized, destinationData?.timeZone ?? '-'),
                        Container(
                          height: 20,
                          width: 1,
                          color: AppColors.clr7C7474.withValues(alpha: 0.2),
                        ).paddingSymmetric(horizontal: 10),
                      ],
                    ),
                  ],
                ),
              ),

              /*///buttons
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonButton(
                        onTap: () {
                          showCommonWebDialog(
                            context: context,
                            keyBadge: destinationDetailsWatch.changePasswordDialogKey,
                            dialogBody: ChangeDestinationPasswordDialog(),
                            height: 0.54,
                            width: 0.4,
                          );
                        },
                        buttonText: LocaleKeys.keyChangePassword.localized,
                        backgroundColor: AppColors.clrF4F5F7,
                        height: context.height * 0.055,
                        width: context.width * 0.135,
                        borderRadius: BorderRadius.circular(10),
                        borderColor: AppColors.gray606060,
                        borderWidth: 1.0,
                        buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.gray606060),
                      ),
                      SizedBox(width: context.width * 0.018),
                      Visibility(
                        visible: ref.watch(drawerController).isMainScreenCanEdit && destinationData?.active == true,
                        child: CommonButton(
                          onTap: () {
                            ref.read(manageDestinationController).disposeController();
                            ref.read(navigationStackController).push(NavigationStackItem.manageDestination(destinationUuid: destinationData?.uuid));
                          },
                          buttonText: LocaleKeys.keyEdit.localized,
                          leftImage: Assets.svgs.svgEditPen.keyName,
                          backgroundColor: AppColors.clrF4F5F7,
                          height: context.height * 0.055,
                          width: context.width * 0.06,
                          borderRadius: BorderRadius.circular(10),
                          borderColor: AppColors.gray606060,
                          borderWidth: 1.0,
                          buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.gray606060),
                        ),
                      ),
                    ],
                  ),
                ],
              ),*/
            ],
          );
  }

  Widget HeaderContent(String title, String subTitle, {Color? subTitleColor}) => Wrap(
    children: [
      CommonText(
        title: '${title} :',
        style: TextStyles.regular.copyWith(color: AppColors.clr7C7474, fontSize: 16),
      ),
      CommonText(
        title: subTitle,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyles.regular.copyWith(color: subTitleColor ??  AppColors.primary, fontSize: 16),
      ),
    ],
  );
}
