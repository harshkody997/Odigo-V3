import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/repository/client/model/response/client_details_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/client/web/helper/client_details_header_content_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';

class ClientDetailsTab extends ConsumerWidget {
  const ClientDetailsTab({Key? key}) : super(key: key);

  ///Build
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientDetailsWatch = ref.watch(clientDetailsController);
    ClientDetailsData? clientDetailsData = clientDetailsWatch.clientDetailsState.success?.data;
    return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Back Button
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: CommonSVG(strIcon: Assets.svgs.svgBackArrow.path),
              ).paddingOnly(left: 10, top: 10, right: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CommonText(title: clientDetailsData?.name ?? '', style: TextStyles.bold.copyWith(fontSize: 22)),
                    SizedBox(height: context.height * 0.025),
                    Wrap(
                      children: [
                        ///Destination
                        ClientDetailsHeaderContentWidget(LocaleKeys.keyEmailAddress.localized, clientDetailsData?.email ?? '',isUseWrap: true,),
                        Container(height: 20, width: 1, color: AppColors.clr7C7474.withValues(alpha: 0.2)).paddingSymmetric(horizontal: 10),
                        ClientDetailsHeaderContentWidget(LocaleKeys.keyMobileNumber.localized, clientDetailsData?.contactNumber ?? ''),
                        Container(height: 20, width: 1, color: AppColors.clr7C7474.withValues(alpha: 0.2)).paddingSymmetric(horizontal: 10),
                        ClientDetailsHeaderContentWidget(
                          LocaleKeys.keyStatus.localized, ((clientDetailsData?.active?.toActiveStatusText) ?? '-' ),
                          subTitleColor: (clientDetailsData?.active ?? false)
                              ? AppColors.clr9B100
                              : AppColors.red,),
                      ],
                    ),
                    SizedBox(height: context.height * 0.025),
                    /// pass isExpandedSubTitle = true for avoid render issue and show multi line address text
                    ClientDetailsHeaderContentWidget(LocaleKeys.keyAddress.localized, clientDetailsWatch.formatFullAddressFromClient(clientDetailsData) ?? '',isExpandedSubTitle: true,),
                  ],
                ).paddingOnly(right: context.width * 0.01),
              ),
              /// wallet widget
              Container(
                width: context.width * 0.2,
                height: context.height * 0.2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// wallet text & eye icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText(
                          title: LocaleKeys.keyWallet.localized, /// wallet text
                          fontSize: 14,
                          fontWeight: TextStyles.fwSemiBold,
                          clrFont: AppColors.white,
                        ),
                        InkWell(
                            onTap: (){
                              clientDetailsWatch.updateWalletBalanceVisible();
                            },
                            child: CommonSVG(
                              strIcon: clientDetailsWatch.isWalletBalanceVisible ? Assets.svgs.svgHidePasswordSvg.path : Assets.svgs.svgShowPasswordSvg.path,
                              colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                            )
                        )
                      ],
                    ),
                    Spacer(),
                    /// total balance
                    CommonText(
                      title: LocaleKeys.keyTotalBalance.localized,
                      fontSize: 14,
                      fontWeight: TextStyles.fwRegular,
                      clrFont: AppColors.white,
                    ),
                    /// currency & wallet balance
                    CommonText(
                      title: '${AppConstants.currency} ${clientDetailsWatch.isWalletBalanceVisible ? clientDetailsWatch.clientDetailsState.success?.data?.wallet : getMaskedWalletBalance(clientDetailsWatch.clientDetailsState.success?.data?.wallet)}',
                      fontSize: 24,
                      fontWeight: TextStyles.fwMedium,
                      clrFont: AppColors.white,
                    ),
                  ],
                ).paddingSymmetric(horizontal: context.width * 0.015,vertical: context.height * 0.02),
              ),
            ],
          );
  }
}
