import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/ads_module/ads_module_controller.dart';
import 'package:odigov3/framework/controller/client/client_list_controller.dart';
import 'package:odigov3/framework/controller/create_ads/ads_details_controller.dart';
import 'package:odigov3/framework/controller/destination/destination_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/framework/utils/form_validations.dart';
import 'package:odigov3/framework/controller/create_ads/create_ads_controller.dart';
import 'package:odigov3/framework/utils/session.dart';
import 'package:odigov3/ui/utils/app_constants.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class BasicDetailsTab extends ConsumerStatefulWidget {
  final String? uuid;
  const BasicDetailsTab({Key? key, this.uuid}) : super(key: key);

  @override
  ConsumerState<BasicDetailsTab> createState() => _BasicDetailsTabState();
}

class _BasicDetailsTabState extends ConsumerState<BasicDetailsTab> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final createAdsWatch = ref.watch(createAdsController);
    final adsListWatch = ref.watch(adsModuleController);
    final clientListWatch = ref.watch(clientListController);
    final destinationWatch = ref.watch(destinationController);

    return Form(
      key: createAdsWatch.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(title: LocaleKeys.keyBasicDetails.localized,style: TextStyles.semiBold.copyWith(fontSize: 14),),

          SizedBox(height: context.height * 0.024,),
          adsListWatch.selectedTab == 0 ?
          Visibility(
            visible: Session.getClientUuid().isEmpty,
            child: CommonSearchableDropdown(
              isEnable: (widget.uuid?.isEmpty ?? false),
              hintText: LocaleKeys.keySelectClients.localized,
              onSelected: (value) {
                createAdsWatch.updateClientDropdown(value.name ?? '', value.uuid ?? '');
              },
              textEditingController: createAdsWatch.searchClientController,
              items: clientListWatch.clientList,
              validator: (value) {
                return validateText(value, LocaleKeys.keyClientSelectionRequired.localized);
              },
              title: (str) {
                return str.name ?? '';
              },
              onScrollListener: () async {
                if (!clientListWatch.clientListState.isLoadMore && clientListWatch.clientListState.success?.hasNextPage == true) {
                  if (context.mounted) {
                    await clientListWatch.getClientApi(context, pagination: true);
                  }
                }
              },
            ).paddingOnly(bottom: context.height * 0.025),
          ) :
          CommonSearchableDropdown(
            isEnable: (widget.uuid?.isEmpty ?? false),
            hintText: LocaleKeys.keySelectDestination.localized,
            onSelected: (value) {
              createAdsWatch.updateDestinationDropdown(value.name ?? '', value.uuid ?? '');
            },
            textEditingController: createAdsWatch.searchDestinationController,
            items: destinationWatch.destinationList,
            validator: (value) {
              return validateText(value, LocaleKeys.keyDestinationSelectionRequired.localized);
            },
            title: (str) {
              return str.name ?? '';
            },
            onScrollListener: () async {
              if (!destinationWatch.destinationListState.isLoadMore && destinationWatch.destinationListState.success?.hasNextPage == true) {
                await destinationWatch.getDestinationListApi(context, isReset: true);            }
            },
          ).paddingOnly(bottom: context.height * 0.025),

          /// Tag Name Field
          CommonInputFormField(
            isEnable: (widget.uuid?.isEmpty ?? false),
            textEditingController: createAdsWatch.addTagNameController,
            hintText: LocaleKeys.keyAddTagName.localized,
            focusNode: createAdsWatch.tagFocus,
            onFieldSubmitted: (value) {
              FocusScope.of(context).unfocus();
            },
            maxLength: maxLength50,
            validator: (value) {
              return validateText(value, LocaleKeys.keyAddTagNameShouldBeRequired.localized);
            },
          ),
          SizedBox(height: context.height * 0.02),

          // if(createAdsWatch.selectedTagsList.isNotEmpty || createAdsWatch.selectedTagsList.length != 0)
          //   Container(
          //     child: Wrap(
          //       crossAxisAlignment: WrapCrossAlignment.start,
          //       children: [
          //         ...List.generate(createAdsWatch.selectedTagsList.length, (index) {
          //           final item = createAdsWatch.selectedTagsList[index];
          //           return Container(
          //             height: context.height * 0.05,
          //             decoration: BoxDecoration(
          //               borderRadius: BorderRadius.circular(25),
          //               border: Border.all(
          //                 color: AppColors.whiteEAEAEA,
          //               ),
          //             ),
          //             child: Row(
          //               mainAxisSize: MainAxisSize.min,
          //               children: [
          //                 CommonText(
          //                   title: item.capsFirstLetterOfSentence,
          //                   style: TextStyles.medium.copyWith(color: AppColors.textFieldBorderColor, fontSize: 14),
          //                 ),
          //                 SizedBox(width: context.width * 0.005),
          //                 InkWell(
          //                   onTap: () {
          //                     createAdsWatch.removeTagList(item);
          //                   },
          //                   child:  CommonSVG(
          //                     strIcon: Assets.svgs.svgCrossRounded.keyName,
          //                     height: context.height * 0.03,
          //                     width: context.height * 0.03,
          //                   ).paddingAll(5),
          //                 ),
          //               ],
          //             ).paddingOnly(left: context.width * 0.01, right: context.width * 0.005),
          //           ).paddingOnly(right: context.width * 0.01,bottom: context.height * 0.01);
          //         },)
          //       ],
          //     ),
          //   ),
          //
          // SizedBox(height: context.height * 0.02),

        ],
      ),
    );
  }
}
