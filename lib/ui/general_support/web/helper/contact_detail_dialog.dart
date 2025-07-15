import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/general_support/general_support_controller.dart';
import 'package:odigov3/framework/repository/general_support/model/contact_us_list_response.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/general_support/web/helper/details_row_widget.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class ContactDetailDialog extends ConsumerWidget {
  final int index;

  const ContactDetailDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///contact detail variable
    ContactDetail contactDetail =
        ref.watch(generalSupportController).contactUsList[index] ??
        ContactDetail();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Contact Detail title
            CommonText(
              title: LocaleKeys.keySupportDetails.localized,
              style: TextStyles.medium.copyWith(
                fontSize: 20,
                color: AppColors.black,
              ),
            ),

            ///Cross Icon
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: CommonSVG(
                strIcon: Assets.svgs.svgCrossIconBg.keyName,
                height: context.height * 0.040,
                width: context.height * 0.040,
              ),
            ),
          ],
        ).paddingOnly(
          left: context.width * 0.02,
          right: context.width * 0.02,
          top: context.height * 0.02,
        ),
        Divider(
          color: AppColors.clrEAECF0,
          height: 1,
        ).paddingSymmetric(vertical: context.height * 0.02),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///summery text
            CommonText(
              title: LocaleKeys.keySummary.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.black),
            ),

            SizedBox(height: context.height * 0.012),

            ///summery details
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.clrD1D5DC),
              ),
              child: Column(
                children: [
                  DetailsRowWidget(
                    label: LocaleKeys.keyName.localized,
                    value: contactDetail.name ?? '-',
                  ),
                  Divider(color: AppColors.clrD1D5DC, height: 1),
                  DetailsRowWidget(
                    label: LocaleKeys.keyEmailId.localized,
                    value: contactDetail.email ?? '-',
                  ),
                  Divider(color: AppColors.clrD1D5DC, height: 1),
                  DetailsRowWidget(
                    label: LocaleKeys.keyContactUs.localized,
                    value: contactDetail.contactNumber ?? '-',
                  ),
                  Divider(color: AppColors.clrD1D5DC, height: 1),
                  DetailsRowWidget(
                    label: LocaleKeys.keyDate.localized,
                    value: formatUtcToLocalDate(contactDetail.createdAt) ?? '',
                  ),
                ],
              ),
            ),

            ///Description text
            CommonText(
              title: LocaleKeys.keyDescription.localized,
              style: TextStyles.semiBold.copyWith(color: AppColors.black),
            ).paddingSymmetric(vertical: context.height * 0.018),

            ///Description container
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppColors.clrF3F4F6,
                border: Border.all(color: AppColors.clrD1D5DC),
              ),
              width: context.width,
              child:
                  CommonText(
                    title: contactDetail.description ?? '',
                    style: TextStyles.regular.copyWith(
                      color: AppColors.clr364153,
                      fontSize: 14
                    ),
                    maxLines: 8,
                  ).paddingSymmetric(
                    horizontal: context.width * 0.016,
                    vertical: context.height * 0.012,
                  ),
            ),
          ],
        ).paddingOnly(
          left: context.width * 0.02,
          right: context.width * 0.02,
          bottom: context.height * 0.02,
        ),
      ],
    );
  }
}
