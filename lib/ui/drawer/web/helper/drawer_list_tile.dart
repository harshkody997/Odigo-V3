import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/repository/drawer/model/drawer_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/hover_aware.dart';

class DrawerMenuListTile extends ConsumerStatefulWidget {
  final DrawerModel drawerModel;
  final int menuIndex;
  final bool isExpanded;
  final bool isSelected;
  final SidebarModel sidebarModel;

  const DrawerMenuListTile({
    super.key,
    required this.drawerModel,
    required this.menuIndex,
    this.isExpanded = false,
    required this.isSelected,
    required this.sidebarModel,
  });

  @override
  ConsumerState<DrawerMenuListTile> createState() => _DrawerMenuListTileState();
}

class _DrawerMenuListTileState extends ConsumerState<DrawerMenuListTile> with SingleTickerProviderStateMixin {
  AnimationController? animationController;
  bool isHovered = false;
  bool allowHover = false;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  bool _isOverSubmenu = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _removeOverlay();
      animationController = AnimationController(vsync: this);
      allowHover = true;
      _isOverSubmenu = false;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _removeOverlay();
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: HoverAware(
        allowHover: allowHover,
        onEnter: (event) {
          isHovered = true;
          animationController?.forward();
          _removeOverlay();
          setState(() {});
          _showOverlay();
        },
        onExit: (event) {
          isHovered = false;
          animationController?.reverse();
          setState(() {});

          // Add delay before hiding to prevent flickering
          Future.delayed(Duration(milliseconds: 100), () {
            if (!mounted) return;
            if (!isHovered && !_isOverSubmenu) {
              _removeOverlay();
            }
          });
        },
        child: InkWell(
          onTap: () {
            _removeOverlay();
            if((widget.sidebarModel.children??[]).isNotEmpty){
              _showOverlay();
              return;
            }
            if (widget.drawerModel.item == null) return;
            ref.read(drawerController).updateSelectedMainScreen(widget.drawerModel.screenName);
            ref.read(navigationStackController).pushAndRemoveAll(widget.drawerModel.item!);
          },
          child: Opacity(
            opacity: widget.isSelected ? 1 : 0.2,
            child: Lottie.asset(
              widget.drawerModel.strIcon,
              width: context.width * 0.012,
              height: context.height * 0.025,
              animate: isHovered,
              controller: animationController,
              onLoaded: (composition) {
                animationController?.duration = composition.duration;
              },
            ),
          ),
        ),
      ).paddingOnly(bottom: context.height * 0.03),
    );
  }

  void _showOverlay() {
    _removeOverlay();

    SchedulerBinding.instance.addPostFrameCallback((_) {



      if (!mounted) return;
    final overlay = Overlay.of(context, rootOverlay: true);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final hasDropdownList = widget.sidebarModel.children?.isNotEmpty ?? false;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: isRtl ? null : size.width,
        right: isRtl ? size.width : null,
        width: (hasDropdownList) ? context.width * (0.15) : null,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: isRtl ? Offset(-size.width, 0) : Offset(size.width, 0),
          followerAnchor: isRtl ? Alignment.topRight : Alignment.topLeft,
          targetAnchor: isRtl ? Alignment.topRight : Alignment.topLeft,
          child: MouseRegion(
            onEnter: (event) {
              _isOverSubmenu = true;
            },
            onExit: (event) {
              // Add a small delay before setting _isOverSubmenu to false
              // to give time for the mouse to enter child elements
              Future.delayed(Duration(milliseconds: 50), () {
                if (!mounted) return;
                _isOverSubmenu = false;

                // Increased delay before hiding
                Future.delayed(Duration(milliseconds: 500), () {
                  if (!mounted) return;
                  if (!isHovered && !_isOverSubmenu) {
                    _removeOverlay();
                  }
                });
              });
            },
            child: Material(
              color: AppColors.transparent,
              child: Container(
                // Add padding to increase hit area
                color: AppColors.transparent,
                padding: EdgeInsets.only(
                  bottom: context.height * 0.17,
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Container(
                      width: hasDropdownList ? context.width * 0.13 : null,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.black),
                      padding: EdgeInsets.symmetric(vertical: context.height * 0.01),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonText( /// drawer menu name in hover
                            title: widget.sidebarModel.modulesName??'-',
                            textAlign: TextAlign.center,
                            style: TextStyles.medium.copyWith(color: AppColors.white,fontSize: 13),
                          ).paddingSymmetric(horizontal: context.width * 0.01),
                          if (hasDropdownList) ...{ /// if has submenu then showing
                            Divider(color: AppColors.white.withValues(alpha: 0.5),),
                            Container(
                              constraints: BoxConstraints(
                                maxHeight: context.height * 0.5, // Limit height to prevent overflow
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                // Use ClampingScrollPhysics to prevent scrolling issues
                                physics: ClampingScrollPhysics(),
                                itemCount: widget.sidebarModel.children?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final drawerWatch = ref.watch(drawerController);
                                  final subMenu = widget.sidebarModel.children?[index];
                                  bool isSelected = drawerWatch.selectedSubScreen?.drawerMenuModel?.screenName == subMenu?.drawerMenuModel?.screenName;
                                  return MouseRegion(
                                    onEnter: (_) {
                                      _isOverSubmenu = true;
                                    },
                                    child: InkWell(
                                      onTap: () {
                                        if (subMenu?.drawerMenuModel?.item == null) {
                                          return;
                                        }
                                        _removeOverlay();
                                        // Navigate after a short delay to ensure overlay is removed
                                        ref.read(drawerController).updateSelectedSubScreen(subMenu?.drawerMenuModel?.screenName);
                                        Future.microtask(() {
                                          ref.read(navigationStackController).pushAndRemoveAll(subMenu!.drawerMenuModel!.item!);
                                        });
                                      },
                                      hoverColor: AppColors.white.withOpacity(0.1),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.symmetric(
                                            vertical: context.height * 0.01,
                                            horizontal: context.width * 0.01
                                        ),
                                        child: CommonText(
                                          title: subMenu?.modulesName ?? '-',
                                          style: TextStyles.regular.copyWith(color: isSelected ? AppColors.white : AppColors.white.withValues(alpha: 0.5),fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ).paddingSymmetric(horizontal: context.width * 0.01),
                          },
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

      if (_overlayEntry != null && mounted) {
        overlay.insert(_overlayEntry!);
      }

    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void didChangeDependencies() {
    _removeOverlay();
    isHovered = false;
    super.didChangeDependencies();
  }

  @override
  void deactivate() {
    _removeOverlay();
    isHovered = false;
    super.deactivate();
  }
}
