import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:odigov3/framework/controller/table_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_overlay_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_switch_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonTableGenerator extends ConsumerStatefulWidget {
  final List<Widget> headerContent;
  final List<dynamic> childrenHeader;
  final List<Widget> Function(int index) childrenContent;
  final bool? isStatusAvailable;
  final bool? canDeletePermission;
  final bool? Function(int index)? hideStatus;
  final bool? Function(int index)? statusValue;
  final bool? isDetailsAvailable;
  final bool? isEditAvailable;
  final bool? Function(int index)? isEditVisible;
  final bool? isConfirmationField;
  final bool? Function(int index)? isConfirmationFieldVisible;
  final bool? Function(int index)? isAddContentButtonVisible;
  final bool? isDeleteAvailable;
  final bool? Function(int index)? isDeleteVisible;
  final bool? isInfoAvailable;
  final bool? Function(int index)? isInfoVisible;
  final String? Function(int index)? infoText;
  final bool? isLoading;
  final Function(int index)? onApprove;
  final Function(int index)? onDecline;
  final Function(int index)? onAddContent;
  final bool? Function(int index)? isApproveLoading;
  final Function(bool value, int index)? onStatusTap;
  final Function(int index)? onDelete;
  final bool? Function(int index)? isDeleteLoading;
  final Function() onScrollListener;
  final Function(int index)? onEdit;
  final Function(int index)? onForwardArrow;
  final bool? Function(int index)? isSwitchLoading;
  final bool? isLoadMore;
  final double? childVerticalPadding;
  final Widget? forwardArrowIcon;

  const CommonTableGenerator({
    super.key,
    required this.headerContent,
    required this.childrenHeader,
    required this.childrenContent,
    this.isStatusAvailable = false,
    this.hideStatus,
    this.statusValue,
    this.isDetailsAvailable = false,
    this.isEditAvailable,
    this.isEditVisible,
    this.isConfirmationField = false,
    this.isConfirmationFieldVisible,
    this.isAddContentButtonVisible,
    this.isDeleteAvailable = false,
    this.isDeleteVisible,
    this.isInfoAvailable = false,
    this.isInfoVisible,
    this.infoText,
    this.isLoading = false,
    this.onApprove,
    this.onDecline,
    this.onAddContent,
    this.isApproveLoading,
    this.onStatusTap,
    this.onDelete,
    this.isDeleteLoading,
    required this.onScrollListener,
    this.onEdit,
    this.onForwardArrow,
    this.isSwitchLoading,
    this.isLoadMore = false,
    this.canDeletePermission,
    this.childVerticalPadding,
    this.forwardArrowIcon,
  });

  @override
  ConsumerState<CommonTableGenerator> createState() => _CommonAdsTableState();
}

class _CommonAdsTableState extends ConsumerState<CommonTableGenerator> {
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    scrollController.addListener(() async {
      // if (storeListState.success?.hasNextPage == true) {
      if (scrollController.position.maxScrollExtent == scrollController.position.pixels) {
        // if(!storeListState.isLoadMore) {
        widget.onScrollListener();
        //   await storeListApi(context,true,searchText:searchText);
        // }
      }
      // }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final tableWatch = ref.watch(tableController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        // border: Border.all(color: AppColors.grayEAECF0),
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: Column(
        children: [
          // Header row
          Container(
            decoration: BoxDecoration(
              color: AppColors.greyFCFCFD,
              border: Border(bottom: BorderSide(color: AppColors.grayEAECF0)),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
            ),
            child: Row(
              children: [
                ...widget.headerContent,
                if (widget.isDetailsAvailable == true) const SizedBox(width: 30),
                if (widget.isInfoAvailable == true) const SizedBox(width: 30),
                if (widget.isEditAvailable == true) const SizedBox(width: 30),
                if (widget.isDeleteAvailable == true) const SizedBox(width: 30),
                if (widget.isConfirmationField == true)  Expanded(flex: (widget.isDetailsAvailable == true) ? 1: 2, child: Container(height: 20,)),

                if (widget.isDetailsAvailable == true || widget.isEditAvailable == true)
                Expanded(flex: 1,child: CommonText(title:LocaleKeys.keyAction.localized, style: headerStyle()).alignAtCenterRight())
              ],
            ).paddingSymmetric(vertical: 13, horizontal: 24),
          ),

          // Table body list
          Expanded(
            child: widget.isLoading == true
                ? CommonAnimLoader()
                : widget.childrenHeader.isEmpty
                ? Center(child: CommonEmptyStateWidget())
                : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.childrenHeader.length,
                          controller: scrollController,
                        //  padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemBuilder: (context, index) {
                            return
                              Row(
                              children: [
                                // Status switch
                                if (widget.isStatusAvailable == true)
                                  Expanded(
                                    flex: 1,
                                    child: Visibility(
                                      visible: !(widget.hideStatus?.call(index) == true),
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      child: Transform.scale(
                                        scale: 0.8,
                                        child: widget.isSwitchLoading?.call(index) == true ? SizedBox(
                                            height: 22.0,
                                            width: 38.0,
                                            child: Center(child: LoadingAnimationWidget.waveDots(color: AppColors.black, size: 20))) : CommonCupertinoSwitch(
                                        absorbing: !(widget.canDeletePermission??true),
                                        opacity:widget.canDeletePermission??true?1:0.5,
                                          switchValue: widget.statusValue?.call(index) ?? false,
                                          onChanged: (value) => widget.onStatusTap?.call(value, index),
                                        ),
                                      ).alignAtCenterLeft(),
                                    ),
                                  ),

                                // Row content widgets from builder
                                ...widget.childrenContent(index),

                                // Approve/Reject buttons
                                if (widget.isConfirmationField == true || (widget.isAddContentButtonVisible?.call(index) == true))
                                  Expanded(
                                    flex: 2,
                                    child: Visibility(
                                      visible: widget.isConfirmationFieldVisible?.call(index) == true || (widget.isAddContentButtonVisible?.call(index) == true),
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      child: (widget.isAddContentButtonVisible?.call(index) == true)
                                          ? Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          CommonButton(
                                            onTap: ()=> widget.onAddContent?.call(index),
                                            buttonText: LocaleKeys.keyAddContent.localized,
                                            buttonTextStyle: TextStyles.medium.copyWith(fontSize: 12, color: AppColors.black),
                                            leftImage: Assets.svgs.svgPlus.path,
                                            leftImageColor: AppColors.black,
                                            leftImageHeight: context.height * 0.015,
                                            height: context.height * 0.04,
                                            width: context.width * 0.1,
                                            backgroundColor: AppColors.transparent,
                                            borderColor: AppColors.clrD0D5DD,
                                            borderRadius: BorderRadius.circular(6),
                                          ).paddingSymmetric(horizontal: 10)
                                        ],
                                      )
                                          : (widget.isConfirmationFieldVisible?.call(index) == true) ? Row(
                                        children: [
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: CommonConfirmationOverlayWidget(
                                              title: LocaleKeys.keyApprove.localized,
                                              description: LocaleKeys.keyAreYouSure.localized,
                                              positiveButtonText: LocaleKeys.keyApprove.localized,
                                              negativeButtonText: LocaleKeys.keyCancel.localized,
                                              onButtonTap: (isPositive) {
                                                if (isPositive) widget.onApprove?.call(index);
                                              },
                                              child: IgnorePointer(
                                                child: CommonButton(
                                                  buttonText: LocaleKeys.keyApprove.localized,
                                                  buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.clr34C759, fontSize: 12),
                                                  backgroundColor: AppColors.clrEBFFF0,
                                                  borderColor: AppColors.clr34C759,
                                                  borderWidth: 1.0,
                                                  height: context.height * 0.04,
                                                  isShowLoader: widget.isApproveLoading?.call(index) == true,
                                                  isLoading: widget.isApproveLoading?.call(index) == true,
                                                  loadingAnimationColor: AppColors.clr34C759,
                                                  loaderSize: context.height * 0.03,
                                                ),
                                              ),
                                            ).alignAtCenterRight(),
                                          ),
                                          const SizedBox(width: 15),
                                          Expanded(
                                            child: CommonButton(
                                              onTap: ()=> widget.onDecline?.call(index),
                                              buttonText: LocaleKeys.keyDecline.localized,
                                              buttonTextStyle: TextStyles.medium.copyWith(color: AppColors.clrFF3B30, fontSize: 12,decoration: TextDecoration.underline,decorationColor: AppColors.clrFF3B30),
                                              backgroundColor: Colors.transparent,
                                              borderColor: Colors.transparent,
                                              height: context.height * 0.04,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                      ) : Offstage(),
                                    ),
                                  ),

                               // Info icon
                                if (widget.isInfoAvailable == true)
                                  Visibility(
                                    visible: widget.isInfoVisible?.call(index) == true,
                                    maintainState: true,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    child: SizedBox(
                                      height: 15,
                                      width: 30,
                                      child: CommonOverlayWidget(
                                          child: SvgPicture.asset(Assets.svgs.svgInfo2.keyName, height: 20, width: 15).alignAtCenterRight(),
                                          overlayChild: Container(
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: context.width* 0.01, vertical: context.height * 0.01),
                                            child: CommonText(
                                              title: widget.infoText?.call(index) ?? '',
                                              style: TextStyles.regular.copyWith(fontSize: 14),
                                            ),
                                          )
                                      ),
                                    ),
                                  ),

                                // Edit arrow icon
                                if (widget.isEditAvailable == true)
                                  SizedBox(
                                    height: 25,
                                    width: 30,
                                    child: Visibility(
                                      visible: widget.isEditVisible?.call(index) == true, /// pass true to visible edit icon
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      child: InkWell(
                                        onTap: () => widget.onEdit?.call(index),
                                        child: SvgPicture.asset(
                                            Assets.svgs.svgEditPen.keyName,
                                            height: 20, width: 15)
                                            .alignAtCenterRight(),),
                                    ),
                                  ),

                                // Delete icon
                                if (widget.isDeleteAvailable == true && (widget.canDeletePermission??true))
                                  widget.isDeleteLoading?.call(index) == true
                                      ? SizedBox(
                                    height: 15,
                                    width: 30,
                                    child: Center(child: LoadingAnimationWidget.waveDots(color: AppColors.black, size: 20),),
                                  )
                                      : Visibility(
                                    visible: widget.isDeleteVisible?.call(index) == true && (widget.canDeletePermission??false), /// pass true to visible delete icon
                                    maintainState: true,
                                    maintainSize: true,
                                    maintainAnimation: true,
                                    child: SizedBox(
                                      height: 15,
                                      width: 30,
                                      child: CommonConfirmationOverlayWidget(
                                        title: LocaleKeys.keyDelete.localized,
                                        description: LocaleKeys.keyAreYouSure.localized,
                                        positiveButtonText: LocaleKeys.keyDelete.localized,
                                        negativeButtonText: LocaleKeys.keyCancel.localized,
                                        onButtonTap: (isPositive) {
                                          if (isPositive) widget.onDelete?.call(index);
                                        },
                                        child: SvgPicture.asset(Assets.svgs.svgDelete.keyName, height: 20, width: 15),
                                      ).alignAtCenterRight(),
                                    ),
                                  ),

                                // Forward arrow icon
                                if (widget.isDetailsAvailable == true)
                                  InkWell(
                              onTap: () => widget.onForwardArrow?.call(index),
                              child: SizedBox(
                                height: 15,
                                width: 30,
                                child: widget.forwardArrowIcon ?? Icon(Icons.arrow_forward_ios_outlined, size: 15).alignAtCenterRight(),
                              )
                                  ),
                              ],
                            ).paddingSymmetric(vertical: widget.childVerticalPadding ??  13).paddingSymmetric(horizontal: 24);
                          },
                          separatorBuilder: (_, __) => Divider(color: AppColors.grayEAECF0, height: 1),
                        ),
                    ),
                    widget.isLoadMore == true ? CircularProgressIndicator(strokeWidth: 4,color: AppColors.primary,).paddingOnly(bottom: 15) : Offstage()
                  ],
                ),
          ),
        ],
      ),
    );
  }
}

// Common header widget with flexible width
Widget CommonHeader({required String title, int flex = 1,TextAlign? textAlign}) => Expanded(
  flex: flex,
  child: CommonText(title: title, style: headerStyle(),textAlign: textAlign),
);

// Common row text widget with flexible width
Widget CommonRow({required String title, int flex = 1,Widget? widget}) => Expanded(
  flex: flex,
  child: widget??CommonText(title: title, style: rowStyle(), maxLines: 10,),
);

TextStyle headerStyle() => TextStyles.medium.copyWith(color: AppColors.gray667085, fontSize: 12);

TextStyle rowStyle() => TextStyles.medium.copyWith(color: AppColors.black, fontSize: 12);
