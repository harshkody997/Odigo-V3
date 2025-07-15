import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/dashboard/dashboard_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/dashboard_count_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/dashboard/web/helper/overview/common_dashboard_header_tile.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardHeaderOverview extends ConsumerWidget {
  const CommonDashboardHeaderOverview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardWatch = ref.watch(dashboardController);
    DashboardCountData? dashboardData = dashboardWatch.dashboardCountState.success?.data;
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CommonSVG(strIcon: Assets.svgs.svgHourglass.path),
              SizedBox(width: context.width * 0.001),
              CommonText(title: LocaleKeys.keyOverview.localized, style: TextStyles.semiBold),
              Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: context.height * 0.02),
          ((Session.getEntityType() == RoleType.DESTINATION.name) || (Session.getEntityType() == RoleType.DESTINATION_USER.name))
            ? Row(
            children: [
              CommonDashboardHeaderTile(
                title: LocaleKeys.keyRobotRegistration,
                count: dashboardData?.totalRobot.toString() ?? '',
                active: dashboardData?.activeRobot.toString() ?? '',
                inActive: dashboardData?.deactiveRobot.toString() ?? '',
                asset: Assets.svgs.svgRoundedRobot.path,
              ),
              SizedBox(width: context.width * 0.005,),
              Spacer(),
              // SizedBox(width: context.width * 0.005,),
              // Spacer(),
            ]
          )
            : Row(
        children: [
          CommonDashboardHeaderTile(
            title: LocaleKeys.keyTotalDestination,
            count: dashboardData?.totalDestination.toString() ?? '',
            active: dashboardData?.activeDestination.toString() ?? '',
            inActive: dashboardData?.deactiveDestination.toString() ?? '',
            asset: Assets.svgs.svgRoundedDestination.path,
          ),
          SizedBox(width: context.width * 0.005,),
          CommonDashboardHeaderTile(
            title: LocaleKeys.keyRobotRegistration,
            count: dashboardData?.totalRobot.toString() ?? '',
            active: dashboardData?.activeRobot.toString() ?? '',
            inActive: dashboardData?.deactiveRobot.toString() ?? '',
            asset: Assets.svgs.svgRoundedRobot.path,
          ),
          SizedBox(width: context.width * 0.005,),
          CommonDashboardHeaderTile(
            title: LocaleKeys.keyClientRegistered,
            count: dashboardData?.totalClient.toString() ?? '',
            active: dashboardData?.activeClient.toString() ?? '',
            inActive: dashboardData?.deactiveClient.toString() ?? '',
            asset: Assets.svgs.svgRoundedUser.path,
          ),
        ]
    ),
        ],
      ),
    );
  }
}
