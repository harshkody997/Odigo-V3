import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/manage_destination_controller.dart';
import 'package:odigov3/framework/controller/master/city/city_list_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/controller/master/destination_type/destination_type_list_controller.dart';
import 'package:odigov3/framework/controller/master/state/state_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/destination/web/helper/manage_destination_address_widget.dart';
import 'package:odigov3/ui/destination/web/helper/manage_destination_form_widget.dart';
import 'package:odigov3/ui/destination/web/helper/manage_destination_owner_details_widget.dart';
import 'package:odigov3/ui/destination/web/helper/manage_destination_price_widget.dart';
import 'package:odigov3/ui/destination/web/helper/manage_destination_store_timings_widget.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class ManageDestinationWeb extends ConsumerStatefulWidget {
  const ManageDestinationWeb({super.key});

  @override
  ConsumerState createState() => _ManageDestinationWebState();
}

class _ManageDestinationWebState extends ConsumerState<ManageDestinationWeb> {
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(
      isApiLoading: ((ref.watch(manageDestinationController).destinationDetailsState.isLoading) ||
          (ref.watch(countryListController).countryListState.isLoading) ||
          (ref.watch(stateListController).stateListState.isLoading) ||
          (ref.watch(cityListController).cityListState.isLoading) ||
          (ref.watch(countryListController).countryTimezoneListState.isLoading) ||
          (ref.watch(destinationTypeListController).destinationTypeListState.isLoading)),
      body: Stack(
        children: [
          Form(
            key: ref.read(manageDestinationController).destinationFormKey,
            child: ((ref.watch(manageDestinationController).destinationDetailsState.isLoading) ||
                (ref.watch(countryListController).countryListState.isLoading) ||
                (ref.watch(countryListController).countryTimezoneListState.isLoading) ||
                (ref.watch(destinationTypeListController).destinationTypeListState.isLoading))
                ? CommonAnimLoader()
                : SingleChildScrollView(
                  child: AbsorbPointer(
                    absorbing:
                        ((ref.watch(manageDestinationController).manageDestinationState.isLoading) ||
                        (ref.watch(manageDestinationController).destinationDetailsState.isLoading) ||
                        (ref.watch(countryListController).countryListState.isLoading) ||
                        (ref.watch(stateListController).stateListState.isLoading) ||
                        (ref.watch(cityListController).cityListState.isLoading) ||
                        (ref.watch(countryListController).countryTimezoneListState.isLoading) ||
                        (ref.watch(destinationTypeListController).destinationTypeListState.isLoading)),
                    child: Column(
                      children: [
                        ManageDestinationFormWidget(),
                        SizedBox(height: context.height * 0.02),
                        ManageDestinationStoreTimingsWidget(),
                        SizedBox(height: context.height * 0.02),
                        ManageDestinationOwnerDetailsWidget(),
                        SizedBox(height: context.height * 0.02),
                        ManageDestinationAddressWidget(),
                        SizedBox(height: context.height * 0.02),
                        ManageDestinationPriceWidget(),
                        SizedBox(height: context.height * 0.02),
                        Row(
                          children: [
                            CommonButton(
                              width: context.width * 0.1,
                              // height: context.height * 0.04,
                              backgroundColor: AppColors.clr080808,
                              buttonText: LocaleKeys.keySave.localized,
                              isLoading: ref.watch(manageDestinationController).manageDestinationState.isLoading,
                              onTap: () {
                                bool destinationValidation = ref.read(manageDestinationController).checkDestinationTimeValidation();
                                bool isValid = ref.read(manageDestinationController).destinationFormKey.currentState?.validate() ?? false;
                                if(!destinationValidation)showToast(context: context,isSuccess: false,title:LocaleKeys.keyStoreTimingsSelectionValidation.localized);
                                if (isValid && destinationValidation) {
                                  ref.read(manageDestinationController).manageDestinationApi(context, destinationUuid: ref.read(manageDestinationController).destinationDetailsState.success?.data?.uuid);
                                }
                              },
                            ),
                            SizedBox(width: context.width * 0.005),
                            CommonButton(
                              onTap: () {
                                ref.read(navigationStackController).pop();
                              },
                              width: context.width * 0.1,
                              // height: context.height * 0.04,
                              backgroundColor: AppColors.transparent,
                              borderColor: AppColors.black,
                              buttonText: LocaleKeys.keyBack.localized,
                              buttonTextColor: AppColors.clr080808,
                            ),
                          ],
                        ).paddingOnly(bottom: context.height * 0.01),
                      ],
                    ),
                  ),
                ),
          ),
          (ref.watch(stateListController).stateListState.isLoading) ||
          (ref.watch(cityListController).cityListState.isLoading) ? CommonAnimLoader() : Offstage()
        ],
      ),
    );
  }
}
