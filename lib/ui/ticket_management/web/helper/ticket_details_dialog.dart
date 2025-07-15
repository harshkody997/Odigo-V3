import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ticket_management/ticket_management_controller.dart';
import 'package:odigov3/framework/repository/ticket_management/model/response/ticket_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/general_support/web/helper/details_row_widget.dart';
import 'package:odigov3/ui/ticket_management/web/helper/update_ticket_status_dialog.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_status_button_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class TicketDetailsDialog extends ConsumerWidget {
  final int index;

  const TicketDetailsDialog({super.key, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///ticket detail variable
    TicketDetails ticketDetail =
        ref.watch(ticketManagementController).ticketList[index] ??
        TicketDetails();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ///Ticket Detail title
            CommonText(
              title: LocaleKeys.keyTicketDetails.localized,
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

        Expanded(
          child: SingleChildScrollView(
            child: Column(
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
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(color: AppColors.clrD1D5DC),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ///Label
                          CommonText(
                            title: LocaleKeys.keyTicketStatus.localized,
                            style: TextStyles.regular.copyWith(
                              color: AppColors.black,
                              fontSize: 12,
                            ),
                          ),
                          Spacer(),

                          ///Status widget
                          Expanded(child: CommonStatusButton(status: ticketDetail.ticketStatus ?? '',dotRequired: true,)),
                        ],
                      ).paddingSymmetric(
                        horizontal: context.width * 0.014,
                        vertical: context.height * 0.016,
                      ),
                      Divider(color: AppColors.clrD1D5DC, height: 1),

                      ///Ticket Id
                      DetailsRowWidget(
                        label: LocaleKeys.keyTicketID.localized,
                        value: ticketDetail.entityId.toString(),
                      ),
                      Divider(color: AppColors.clrD1D5DC, height: 1),

                      ///Raised by
                      DetailsRowWidget(
                        label: LocaleKeys.keyRaisedBy.localized,
                        value: ticketDetail.userType == 'DESTINATION_USER' ? LocaleKeys.keyDestinationUsers.localized : LocaleKeys.keyDestination.localized,
                      ),
                      Divider(color: AppColors.clrD1D5DC, height: 1),

                      ///Date
                      DetailsRowWidget(
                        label: LocaleKeys.keyDate.localized,
                        value:
                            '${DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(ticketDetail.createdAt ?? 0, isUtc: true))}',
                      ),
                    ],
                  ),
                ),

                ///Description text
                CommonText(
                  title: LocaleKeys.keyDescription.localized,
                  style: TextStyles.semiBold.copyWith(color: AppColors.black),
                ).paddingOnly(top: 21,bottom: 12),


                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    color: AppColors.clrF3F4F6,
                    border: Border.all(color: AppColors.clrD1D5DC),
                  ),
                  width: context.width,
                  child:
                  CommonText(
                    title: ticketDetail.description ?? '',
                    style: TextStyles.regular.copyWith(
                      color: AppColors.clr364153,
                      fontSize: 14
                    ),
                    maxLines: 10,
                  ).paddingSymmetric(
                    horizontal: context.width * 0.014,
                    vertical: context.height * 0.012,
                  ),
                ).paddingOnly(bottom: 12),

                Visibility(
                  visible:  ticketDetail.ticketStatus != TicketStatus.PENDING.name,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: AppColors.white,
                      border: Border.all(color: AppColors.clrD1D5DC),
                    ),
                    width: context.width,
                    child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: context.width,
                          decoration: BoxDecoration(
                              color: AppColors.clrF9FAFB,
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(9),topRight: Radius.circular(9))
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CommonText(
                                title: LocaleKeys.keySupportTeam.localized,
                                style: TextStyles.medium.copyWith(
                                    color: AppColors.clr364153,
                                    fontSize: 14
                                ),
                              ),
                              CommonText(
                                title: ticketDetail.ticketStatus == TicketStatus.RESOLVED.name ? DateFormat('dd MMM,yy; hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticketDetail.resolvedDate ?? 0)) :  DateFormat('dd MMM,yy; hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(ticketDetail.acknowledgedDate ?? 0)),
                                style: TextStyles.regular.copyWith(
                                    color: AppColors.clr6A7282,
                                    fontSize: 14
                                ),
                              ),
                            ],
                          ).paddingSymmetric(
                            horizontal: context.width * 0.016,
                            vertical: context.height * 0.012,
                          ),
                        ),
                        Divider(color: AppColors.clrD1D5DC, height: 1),
                        CommonText(
                          title: ticketDetail.ticketStatus == TicketStatus.RESOLVED.name ? ticketDetail.resolveComment : ticketDetail.acknowledgeComment ?? '',
                          style: TextStyles.regular.copyWith(
                            color: AppColors.clr364153,
                          ),
                          maxLines: 10,
                        ).paddingSymmetric(
                          horizontal: context.width * 0.016,
                          vertical: context.height * 0.012,
                        ),
                      ],
                    ),
                  ).paddingOnly(bottom: 12),
                ),
                ///take action button
                Visibility(
                  visible: Session.getRoleType() == 'SUPER_ADMIN' && ticketDetail.ticketStatus != TicketStatus.RESOLVED.name ,
                  child: CommonButton(
                    height: context.height * 0.077,
                    borderRadius: BorderRadius.circular(9),
                    buttonTextStyle: TextStyles.regular.copyWith(
                      fontSize: 16,
                      color: AppColors.white,
                    ),
                    buttonText: LocaleKeys.keyTakeAction.localized,
                    onTap: () {
                      Navigator.pop(
                        ref
                            .watch(ticketManagementController)
                            .ticketDetailDialogKey
                            .currentContext!,
                      );
                      ref
                          .watch(ticketManagementController)
                          .clearStatusValue();

                      showCommonWebDialog(
                        context: context,
                        keyBadge: ref
                            .watch(ticketManagementController)
                            .ticketStatusDialogKey,
                        dialogBody:  UpdateTicketStatusDialog(ticketUuid: ticketDetail.uuid ?? '',status: ticketDetail.ticketStatus ?? '',),
                        height: 0.67,
                        width: 0.4,
                      );
                    },
                  ),
                ),
              ],
            ).paddingSymmetric(
              horizontal: context.width * 0.02,
              vertical: context.height * 0.02,
            ),
          ),
        ),
        SizedBox(
          height: context.height * 0.02,
        )
      ],
    );
  }
}
