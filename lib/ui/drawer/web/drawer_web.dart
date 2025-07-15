import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/drawer/model/drawer_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/drawer/web/helper/drawer_list_tile.dart';
import 'package:odigov3/ui/routing/navigation_stack_item.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';

class DrawerWeb extends ConsumerStatefulWidget {
  const DrawerWeb({super.key});

  @override
  ConsumerState createState() => _DrawerWebState();
}

class _DrawerWebState extends ConsumerState<DrawerWeb> {
  final ScrollController _scrollController = ScrollController();
  List<GlobalKey> _tileKeys = [];

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final drawerWatch = ref.read(drawerController);
      drawerWatch.manageScrollContentDrawer(_tileKeys, _scrollController);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final drawerWatch = ref.watch(drawerController);
    _tileKeys = List.generate(drawerWatch.sidebarMenuList.length, (_) => GlobalKey());
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.clrD8D8D8)),
        color: AppColors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: Scrollbar( /// for showing scroll on drawer
              controller: _scrollController,
              thickness: 3,
              radius: Radius.circular(6),
              interactive: true,
              trackVisibility: false,
              thumbVisibility: false,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: drawerWatch.sidebarMenuList.length,
                itemBuilder: (context, menuIndex) {
                  final drawerModel = drawerWatch.sidebarMenuList[menuIndex].drawerMenuModel!;
                  return DrawerMenuListTile(
                    key: _tileKeys.isNotEmpty ? _tileKeys[menuIndex] : null,
                    drawerModel: drawerModel,
                    menuIndex: menuIndex,
                    isExpanded: drawerModel.isExpanded,
                    isSelected: drawerWatch.selectedMainScreen?.drawerMenuModel?.screenName == drawerModel.screenName,
                    sidebarModel: drawerWatch.sidebarMenuList[menuIndex],
                  );
                },
              ),
            )
            ,
          ),
          SizedBox(height: context.height * 0.03),
          CommonConfirmationOverlayWidget(
            title: LocaleKeys.keyLogout.localized,
            description: LocaleKeys.keyLogoutConfirmationMessageWeb.localized,
            positiveButtonText: LocaleKeys.keyLogout.localized,
            // negativeButtonText: LocaleKeys.keyCancel.localized,
            onButtonTap: (isPositive) {
              if (isPositive) {
                ///Logout Here
                // Session.userAccessToken = '';
                // ref.read(navigationStackController).pushAndRemoveAll(const NavigationStackItem.login());
                Session.sessionLogout(ref, context);
              }
            },
            child: Container(
                height: context.height * 0.06,
                width: context.height * 0.06,
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(8)
                ),
                alignment: Alignment.center,
                child: CommonSVG(strIcon: Assets.svgs.svgLogoutSquare.path,
                  height: context.height * 0.025,
                  width: context.height * 0.025,
                ))
            //  Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [CommonSVG(strIcon: Assets.svgs.svgLogout.path,colorFilter: ColorFilter.mode(AppColors.black, BlendMode.srcATop),)],
            // ),
          ),
          SizedBox(height: context.height * 0.01),
        ],
      ).paddingSymmetric(vertical: context.height * 0.03, horizontal: context.width * 0.01),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
