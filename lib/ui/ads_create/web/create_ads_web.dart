
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/client_ads/client_ads_controller.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/ads_create/web/helper/basic_details_tab.dart';
import 'package:odigov3/ui/ads_create/web/helper/image_frame_viewer.dart';
import 'package:odigov3/ui/ads_create/web/helper/media_details_tab.dart';
import 'package:odigov3/ui/ads_create/web/helper/media_picker_class.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class CreateAdsWeb extends ConsumerStatefulWidget {
  final String? uuid;
  const CreateAdsWeb({Key? key, this.uuid}) : super(key: key);

  @override
  ConsumerState<CreateAdsWeb> createState() => _CreateAdsWebState();
}

class _CreateAdsWebState extends ConsumerState<CreateAdsWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final createAdsWatch = ref.watch(createAdsController);

    bool isClientAdLoading = createAdsWatch.addClientAdApiState.isLoading || createAdsWatch.addClientAdsContentImageState.isLoading || createAdsWatch.addClientAdsContentVideoState.isLoading || createAdsWatch.validateAdsContentState.isLoading;
    bool isDefaultAdLoading = createAdsWatch.addDefaultAdApiState.isLoading || createAdsWatch.addDefaultAdsContentImageState.isLoading || createAdsWatch.addDefaultAdsContentVideoState.isLoading || createAdsWatch.validateAdsContentState.isLoading;
    return BaseDrawerPageWidget(
        body: Stack(
      children: [
        _bodyWidget(),
        isClientAdLoading || isDefaultAdLoading ? Container(color: AppColors.white.withValues(alpha: 0.8), child: CommonAnimLoader()) : Offstage(),
      ],
    ),
       isApiLoading: isClientAdLoading || isDefaultAdLoading,

    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    final createAdsWatch = ref.read(createAdsController);
    final adsDetailsWatch = ref.read(adsDetailsController);
    final bool isLoading = adsDetailsWatch.clientAdsDetailState.isLoading || adsDetailsWatch.defaultAdsDetailState.isLoading;
    return isLoading ?
    /// Loader
    Center(child: CommonAnimLoader()):
    // /// Empty state
    // destinationWatch.destinationList.isEmpty || (userDetailWatch.destinationUserDetailsState.success?.data == null   && userUuid != null)?
    // Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,)):
    Row(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            height: context.height,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ///Basic details
                  BasicDetailsTab(uuid: widget.uuid ?? ''),

                  ///Media details
                  MediaDetailsTab(uuid: widget.uuid ?? ''),

                  ///Media picker
                  MediaPickerClass(),

                  Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          onTap: () async {
                            // Check if image/document is selected
                            if (createAdsWatch.selectedDocumentData != null || createAdsWatch.selectedDocumentFile != null) {
                              createAdsWatch.changeImageErrorVisible(false);
                            } else {
                              createAdsWatch.changeImageErrorVisible(true);
                            }

                            // Validate form
                            final bool? result = createAdsWatch.formKey.currentState?.validate();

                            // Proceed if form is valid and image check passed
                            if (result == true && !createAdsWatch.isImageErrorVisible) {
                              if ((widget.uuid ?? '').isNotEmpty) {
                                /// UUID is present → call Add Content API
                                await onAddContentApiCall(
                                  context: context,
                                  ref: ref,
                                  uuid: widget.uuid!,
                                );
                              } else {
                                /// UUID is empty → create new ad based on tab
                                if (ref.watch(adsModuleController).selectedTab == 0) {
                                  await createClientAdsApiCall(context, ref);
                                } else {
                                  await createDefaultAdsApiCall(context, ref);
                                }
                              }
                            }
                          },
                          // isLoading: ref.watch(adsModuleController).selectedTab == 0 ? isClientAdLoading : isDefaultAdLoading,
                          buttonText: LocaleKeys.keySave.localized,
                        ),
                      ),
                      SizedBox(width: 20),

                      /// Back Button
                      Expanded(
                        child: CommonButton(
                          buttonText: LocaleKeys.keyBack.localized,
                          borderColor: AppColors.clr9E9E9E,
                          backgroundColor: AppColors.clrF4F5F7,
                          buttonTextColor: AppColors.clr787575,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),

                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ).paddingOnly(top: 20),
                ],
              ).paddingSymmetric(vertical: context.height * 0.032, horizontal: context.width * 0.017),
            ),
          ),
        ),
        SizedBox(width: context.width * 0.015),
        Expanded(
          flex: 2,
          child: Container(
            height: context.height,
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: ImageFrameViewer(),
          ),
        ),
      ],
    );
  }
}

/// Create Default Ads API Call
Future createDefaultAdsApiCall(BuildContext context, WidgetRef ref) async {
  final createAdsWatch = ref.watch(createAdsController);
  await createAdsWatch.addDefaultAdsApi(context, ref);
  if (createAdsWatch.addDefaultAdApiState.success?.status == ApiEndPoints.apiStatus_200) {
    if(createAdsWatch.mediaIndex == 0){
      await createAdsWatch.addDefaultAdsContentImageApi(context, defaultAdsUuid: createAdsWatch.addDefaultAdApiState.success?.data?.uuid ?? '').then(
            (value) async {
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            Clipboard.setData(ClipboardData(text: value.success?.message ?? ''));
            showToast(context: context,isSuccess: true,title:value.success?.message??'');
            await ref.read(adsModuleController).defaultAdsListApi(context);
            ref.read(navigationStackController).pop();

          }
        },
      );
    }else{
      await createAdsWatch.addDefaultAdsContentVideoApi(context, defaultAdsUuid: createAdsWatch.addDefaultAdApiState.success?.data?.uuid ?? '').then((value) async {
        if(value.success?.status == ApiEndPoints.apiStatus_200){
          Clipboard.setData(ClipboardData(text: value.success?.message ?? ''));
          showToast(context: context,isSuccess: true,title:value.success?.message ?? '');
          await ref.read(adsModuleController).defaultAdsListApi(context);
          ref.read(navigationStackController).pop();

        }
      },);
    }
  }
}

/// Create Client Ads API Call
Future createClientAdsApiCall(BuildContext context, WidgetRef ref) async {
  final createAdsWatch = ref.watch(createAdsController);
  await createAdsWatch.validateAdsContentApi(context);
  if (createAdsWatch.validateAdsContentState.success?.status == ApiEndPoints.apiStatus_200) {
    await createAdsWatch.addClientAdsApi(context, ref);
    if (createAdsWatch.addClientAdApiState.success?.status == ApiEndPoints.apiStatus_200) {
      if(createAdsWatch.mediaIndex == 0){
        await createAdsWatch.addClientAdsContentImageApi(context, clientAdsUuid: createAdsWatch.addClientAdApiState.success?.data?.uuid ?? '').then(
              (value) async {
            if(value.success?.status == ApiEndPoints.apiStatus_200){
              Clipboard.setData(ClipboardData(text: value.success?.message ?? ''));
              showToast(context: context,isSuccess: true,title:value.success?.message??'');
              await ref.read(clientAdsController).clientAdsListApi(context, odigoClientUuid: Session.getClientUuid().isNotEmpty ? Session.getClientUuid() : '');
              ref.read(navigationStackController).pop();

            }
          },
        );
      }else{
        await createAdsWatch.addClientAdsContentVideoApi(context, clientAdsUuid: createAdsWatch.addClientAdApiState.success?.data?.uuid ?? '').then((value) async {
          if(value.success?.status == ApiEndPoints.apiStatus_200){
            Clipboard.setData(ClipboardData(text: value.success?.message ?? ''));
            showToast(context: context,isSuccess: true,title:value.success?.message ?? '');
            await ref.read(clientAdsController).clientAdsListApi(context);
            ref.read(navigationStackController).pop();

          }
        },);
      }
    }
  }
}

Future<void> onAddContentApiCall({
  required BuildContext context,
  required WidgetRef ref,
  String? uuid
}) async {
  final createAdsWatch = ref.watch(createAdsController);
  final selectedTab = ref.watch(adsModuleController).selectedTab;
  final mediaIndex = createAdsWatch.mediaIndex;

  await createAdsWatch.validateAdsContentApi(context);

  final isValid = createAdsWatch.validateAdsContentState.success?.status == ApiEndPoints.apiStatus_200;
  if (!isValid) return;

  var result;
  if (selectedTab == 0) {
    // Client Ads
    result = (mediaIndex == 0)
        ? await createAdsWatch.addClientAdsContentImageApi(context, clientAdsUuid: uuid ?? '')
        : await createAdsWatch.addClientAdsContentVideoApi(context, clientAdsUuid: uuid ?? '');
  } else {
    // Default Ads
    result = (mediaIndex == 0)
        ? await createAdsWatch.addDefaultAdsContentImageApi(context, defaultAdsUuid: uuid ?? '')
        : await createAdsWatch.addDefaultAdsContentVideoApi(context, defaultAdsUuid: uuid ?? '');
  }

  final isSuccess = result?.success?.status == ApiEndPoints.apiStatus_200;
  if (isSuccess) {
    final message = result?.success?.message ?? 'Success';
    Clipboard.setData(ClipboardData(text: message));
    showToast(context: context, isSuccess: true, title: message);

    if (selectedTab == 0) {
      await ref.read(clientAdsController).clientAdsListApi(context);
    } else {
      await ref.read(adsModuleController).defaultAdsListApi(context);
    }

    ref.read(navigationStackController).pop();
  }
}

