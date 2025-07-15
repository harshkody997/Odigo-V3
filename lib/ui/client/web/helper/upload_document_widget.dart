import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/add_update_client_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/ui/client/web/helper/add_edit_clients_bottom_button_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';
import 'package:path/path.dart' as path;

class UploadDocumentWidget extends ConsumerStatefulWidget {
  final String? clientUuid;
  final Function? popCallBack;

  const UploadDocumentWidget({super.key, this.clientUuid, this.popCallBack});

  @override
  ConsumerState<UploadDocumentWidget> createState() => _UploadDocumentWidgetState();
}

class _UploadDocumentWidgetState extends ConsumerState<UploadDocumentWidget> {
  late DropzoneViewController controller;

  @override
  Widget build(BuildContext context) {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);

    return Container(
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title: LocaleKeys.keyUploadDocuments.localized, fontWeight: TextStyles.fwSemiBold).paddingOnly(bottom: 10),

          /// To Show Selected Images
          Stack(
            children: [
              Visibility(
                visible: addUpdateClientWatch.selectedImages.isNotEmpty || addUpdateClientWatch.documentsDataList.isNotEmpty,
                child: Column(
                  children: [
                    /// ListView for documentsDataList (CacheImage)
                    if (addUpdateClientWatch.documentsDataList.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: addUpdateClientWatch.documentsDataList.length,
                        itemBuilder: (context, index) {
                          final document = addUpdateClientWatch.documentsDataList[index];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.clrE7EAEE),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    title: (document.name?.split('.').first) ?? '',
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ).paddingOnly(bottom: 5, left: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// Cache Image Preview
                                      InkWell(
                                        onTap: () async {
                                          await addUpdateClientWatch.pickImageEdit(context: context, documentName: document.name ?? '', documentUuid: document.uuid ?? '', clientUuid: widget.clientUuid ?? '');
                                        },
                                        child: CacheImage(imageURL: document.url ?? '', height: context.height * 0.05, width: context.height * 0.05).paddingOnly(left: context.width * 0.005),
                                      ),

                                      const SizedBox(width: 8),

                                      /// Name & UUID Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(title: document.name ?? '', overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                                            CommonText(title: document.uuid ?? '', clrFont: AppColors.clr7C7474, fontSize: 12, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),

                                      /// Remove Button
                                      Visibility(
                                        visible: addUpdateClientWatch.documentsDataList.length != 1,
                                        child: SizedBox(
                                          height: 15,
                                          width: 30,
                                          child: CommonConfirmationOverlayWidget(
                                            title: LocaleKeys.keyDelete.localized,
                                            description: LocaleKeys.keyAreYouSure.localized,
                                            positiveButtonText: LocaleKeys.keyDelete.localized,
                                            negativeButtonText: LocaleKeys.keyCancel.localized,
                                            onButtonTap: (isPositive) async {
                                              if (isPositive) {
                                                addUpdateClientWatch.removeImage(index);
                                                addUpdateClientWatch.documentNameController.clear();
                                                addUpdateClientWatch.uploadImageController.clear();
                                                await addUpdateClientWatch.removeDocumentApi(context, addUpdateClientWatch.documentsDataList[index].uuid);
                                                if (addUpdateClientWatch.removeDocumentState.success?.status == ApiEndPoints.apiStatus_200) {
                                                  await addUpdateClientWatch.getDocumentImageByUuidApi(context, widget.clientUuid ?? '');
                                                }
                                              }
                                            },
                                            child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.keyName, height: 20, width: 15),
                                          ).alignAtCenterRight(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 15);
                        },
                      )
                    else
                      Offstage(),
                    SizedBox(height: 15),

                    /// ListView for selectedImages (Image.memory)
                    if (addUpdateClientWatch.selectedImages.isNotEmpty)
                      ListView.separated(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: addUpdateClientWatch.selectedImages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.clrE7EAEE),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonText(
                                    title: addUpdateClientWatch.documentNames[index].split('.').first,
                                    overflow: TextOverflow.ellipsis,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ).paddingOnly(bottom: 5, left: 8),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      /// Image Preview
                                      Image.memory(
                                        addUpdateClientWatch.selectedImages[index],
                                        height: context.height * 0.05,
                                        width: context.height * 0.05,
                                        fit: BoxFit.cover,
                                      ).paddingOnly(left: context.width * 0.005),

                                      const SizedBox(width: 8),

                                      /// Name & UUID Column
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonText(title: addUpdateClientWatch.documentNames[index], overflow: TextOverflow.ellipsis, fontWeight: FontWeight.bold),
                                            CommonText(title: addUpdateClientWatch.documentNames[index], clrFont: AppColors.clr7C7474, fontSize: 12, overflow: TextOverflow.ellipsis),
                                          ],
                                        ),
                                      ),

                                      /// Remove Button
                                      SizedBox(
                                        height: 15,
                                        width: 30,
                                        child: CommonConfirmationOverlayWidget(
                                          title: LocaleKeys.keyDelete.localized,
                                          description: LocaleKeys.keyAreYouSure.localized,
                                          positiveButtonText: LocaleKeys.keyDelete.localized,
                                          negativeButtonText: LocaleKeys.keyCancel.localized,
                                          onButtonTap: (isPositive) async {
                                            if (isPositive) {
                                              addUpdateClientWatch.removeImage(index);
                                              addUpdateClientWatch.documentNameController.clear();
                                              addUpdateClientWatch.uploadImageController.clear();
                                              if (addUpdateClientWatch.selectedImages.isEmpty) {
                                                addUpdateClientWatch.changeIsAddMoreVisibility(isAddMore: false);
                                              }
                                            }
                                          },
                                          child: CommonSVG(strIcon: Assets.svgs.svgClearSearch.keyName, height: 20, width: 15),
                                        ).alignAtCenterRight(),
                                      ).paddingOnly(right: 8),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: 15);
                        },
                      )
                    else
                      Offstage(),
                    if (addUpdateClientWatch.selectedImages.isNotEmpty)
                    SizedBox(height: 15),
                  ],
                ).paddingOnly(top: 20),
              ),
              if (addUpdateClientWatch.updateDocumentImageState.isLoading || addUpdateClientWatch.uploadDocumentImageState.isLoading || addUpdateClientWatch.removeDocumentState.isLoading) Center(child: CommonAnimLoader()),
            ],
          ),

          /// Upload Fields (conditionally shown when isAddMore is false)
          Visibility(
            visible: addUpdateClientWatch.selectedImages.length < 10 && !addUpdateClientWatch.isAddMore,
            child: Column(
              children: [
                /// Document Name Input
                CommonInputFormField(
                  focusNode: addUpdateClientWatch.documentNameFocusNode,
                  textEditingController: addUpdateClientWatch.documentNameController,
                  hintText: LocaleKeys.keyEnterDocumentTitle.localized,
                  validator: (value) {
                    if (addUpdateClientWatch.selectedImages.isEmpty) {
                      return validateText(value, LocaleKeys.keyPleaseEnterDocumentName.localized);
                    }
                    return null;
                  },
                  textInputType: TextInputType.name,
                  maxLength: 100,
                ),
                SizedBox(height: 25),

                /// Upload UI (same as your original block)
                InkWell(
                  onTap: () async {
                    if (addUpdateClientWatch.selectedImages.length < 10) {
                      final result = await addUpdateClientWatch.pickImage();
                      if (result != null) {
                        context.showSnackBar(result);
                      }
                    } else {
                      context.showSnackBar(LocaleKeys.keyMax10Documents.localized);
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: context.height * 0.07,
                                    child: DropzoneView(
                                      onCreated: (ctrl) => controller = ctrl,
                                      onDropFile: _handleDragAndDrop,
                                    ),
                                  ),
                                  Container(
                                    height: context.height * 0.07,
                                    width: context.width,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: addUpdateClientWatch.isImageErrorVisible ? AppColors.red : AppColors.clrE7EAEE),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.zero,
                                        bottomRight: Radius.zero,
                                        topLeft: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: CommonText(
                                      title: LocaleKeys.keySelectAFileOrDragAndDrop.localized,
                                      style: TextStyles.regular.copyWith(color: AppColors.clr7C7474),
                                    ).alignAtCenterLeft().paddingOnly(left: 10),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: context.height * 0.07,
                              width: context.width * 0.16,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: AppColors.clrEAEAEA,
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                border: Border.all(color: AppColors.clrE7EAEE),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CommonSVG(height: context.height * 0.03, strIcon: Assets.svgs.svgUploadImage.path),
                                  SizedBox(width: 8),
                                  Flexible(
                                    child: CommonText(
                                      title: LocaleKeys.keyUploadImage.localized,
                                      style: TextStyles.medium.copyWith(color: AppColors.black, fontSize: 14),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Error Text
                Visibility(
                  visible: addUpdateClientWatch.isImageErrorVisible,
                  child: CommonText(
                    title: LocaleKeys.keyDocumentImageShouldBeRequired.localized,
                    style: TextStyles.medium.copyWith(color: AppColors.red),
                  ).alignAtCenterLeft().paddingOnly(top: 5, left: 15),
                ),
              ],
            ),
          ),

          /// Add More or Remove Button - Show only in Edit mode or if an image is added
          if ((widget.clientUuid?.isNotEmpty ?? false) || addUpdateClientWatch.selectedImages.isNotEmpty)
            Visibility(
              visible: addUpdateClientWatch.selectedImages.length < 10,
              child: CommonButton(
                height: context.width * 0.035,
                width: context.width * 0.1,
                onTap: () {
                  if (addUpdateClientWatch.isAddMore) {
                    addUpdateClientWatch.documentNameController.clear();
                    addUpdateClientWatch.uploadImageController.clear();
                    addUpdateClientWatch.changeIsAddMoreVisibility(isAddMore: false);
                  } else {
                    addUpdateClientWatch.changeIsAddMoreVisibility(isAddMore: true);
                  }
                },
                buttonText: addUpdateClientWatch.isAddMore ? '+ ${LocaleKeys.keyAddMore.localized}' : LocaleKeys.keyRemove.localized,
              ).alignAtBottomLeft().paddingOnly(top: 20),
            ),

          SizedBox(height: 30),

          AddEditClientsBottomButtonWidget(clientUuid: widget.clientUuid, popCallBack: widget.popCallBack),
        ],
      ).paddingAll(20),
    );
  }

  Future<void> _handleDragAndDrop(dynamic event) async {
    final addUpdateClientWatch = ref.watch(addUpdateClientController);
    final name = await controller.getFilename(event);
    final mime = await controller.getFileMIME(event);
    final bytes = await controller.getFileData(event);
    final size = await controller.getFileSize(event);

    if (mime.startsWith('image/')) {
      /// check drag and drop files allowed only image
      final extension = path.extension(name).toLowerCase();
      if (['.jpg', '.jpeg', '.png'].contains(extension)) {
        /// allowed only this extension
        addUpdateClientWatch.uploadImageController.text = name;
        addUpdateClientWatch.selectedImages.add(bytes);
        addUpdateClientWatch.documentNames.add(name);
        addUpdateClientWatch.documentSizes.add(size.toString());
        // Hide upload image fields
        addUpdateClientWatch.changeIsAddMoreVisibility(isAddMore: true);
        addUpdateClientWatch.notifyListeners();
      } else {
        showToast(context: context, isSuccess: false, message: LocaleKeys.keyOnlyAllowedMessage.localized, showAtBottom: true);
      }
    } else {
      showToast(context: context, isSuccess: false, message: LocaleKeys.keyOnlyAnImageIsAllowed.localized, showAtBottom: true);
    }
  }
}
