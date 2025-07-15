import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/store/store_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/store/model/store_list_response_model.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/framework/controller/assign_new_store/assign_new_store_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_toast_widget.dart';

class AssignNewStoreWeb extends ConsumerStatefulWidget {
  const AssignNewStoreWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewStoreWeb> createState() => _AssignNewStoreWebState();
}

class _AssignNewStoreWebState extends ConsumerState<AssignNewStoreWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final assignNewStoreWatch = ref.watch(assignNewStoreController);
    final storeWatch = ref.watch(storeController);
    return BaseDrawerPageWidget(body: Stack(
      children: [
        _bodyWidget(),
        storeWatch.storeListState.isLoading || assignNewStoreWatch.assignStoreApiState.isLoading ?
        Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()) : Offstage()
      ],
    ));
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: LocaleKeys.keyAssignNewStore.localized,
            style: TextStyles.bold.copyWith(color: AppColors.black, fontSize: 14),
          ),

          ///dropdowns and table contents
          _contentData(),
        ],
      ).paddingSymmetric(vertical: context.height * 0.025, horizontal: context.height * 0.025),
    );
  }

  ///dropdowns and table contents
  _contentData() {
    final assignNewStoreWatch = ref.watch(assignNewStoreController);
    final storeWatch = ref.watch(storeController);
    final destinationDetailWatch = ref.watch(destinationDetailsController);
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: context.height * 0.025),
          Form(
            key: assignNewStoreWatch.formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Select robot dropdown
                Expanded(
                  flex: 4,
                  child: CommonSearchableDropdown(
                    hintText: LocaleKeys.keySelectStoreName.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    onSelected: (value) {
                      assignNewStoreWatch.updateStoreDropdown(value);
                      // if (assignNewStoreWatch.selectedFloor != null) {
                      // assignNewStoreWatch.updateStoreList(
                      //   StoreFloorModel(
                      //     storeName: assignNewStoreWatch.selectedStore?.name,
                      //     storeUuid: assignNewStoreWatch.selectedStore?.uuid,
                      //     floorNumber: assignNewStoreWatch.selectedFloor,
                      //   ),
                      //   context,
                      // );
                      // }
                    },
                    textEditingController: assignNewStoreWatch.storeSelectionCtr,
                    items: storeWatch.storeList,
                    validator: (value) {
                      return assignNewStoreWatch.validateStoreDrop();
                    },
                    title: (StoreData? item) {
                      return item?.name ?? '';
                    },
                    onScrollListener: () {
                      storeWatch.storeListApi(context, isForPagination: true).then((value) {
                        if(value.success?.status == ApiEndPoints.apiStatus_200){
                          ref.read(searchController).notifyListeners();
                        }
                      });
                    },
                  ).paddingOnly(bottom: context.height * 0.025),
                ),
                SizedBox(width: context.height * 0.025),
                Expanded(
                  flex: 4,
                  child: CommonSearchableDropdown<int>(
                    hintText: LocaleKeys.keyFloor.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    onSelected: (value) {
                      if (assignNewStoreWatch.selectedStore == null) {
                        assignNewStoreWatch.validateStoreDrop();
                      } else {
                        assignNewStoreWatch.updateFloorDropdown(value.toString());
                        // assignNewStoreWatch.updateStoreList(
                        //   StoreFloorModel(
                        //     storeName: assignNewStoreWatch.selectedStore?.name,
                        //     storeUuid: assignNewStoreWatch.selectedStore?.uuid,
                        //     floorNumber: assignNewStoreWatch.selectedFloor,
                        //   ),
                        //   context,
                        // );
                        // assignNewStoreWatch.clearStoreFloor();
                      }
                    },
                    textEditingController: assignNewStoreWatch.floorSelectionCtr,
                    items: assignNewStoreWatch.floorList,
                    validator: (value) {
                      return assignNewStoreWatch.validateFloorDrop();
                    },
                    title: (int? item) {
                      return item.toString();
                    },
                  ).paddingOnly(bottom: context.height * 0.025),
                ),
                SizedBox(width: context.height * 0.025),
                Flexible(
                  child: CommonButton(
                    onTap: (){
                      if(assignNewStoreWatch.formKey.currentState!.validate()) {
                        if (assignNewStoreWatch.selectedStore != null && assignNewStoreWatch.selectedFloor != null) {
                          assignNewStoreWatch.updateStoreList(
                            StoreFloorModel(
                              storeName: assignNewStoreWatch.selectedStore?.name,
                              storeUuid: assignNewStoreWatch.selectedStore?.uuid,
                              floorNumber: assignNewStoreWatch.selectedFloor,
                            ),
                            context,
                          );

                          // Clear selected data
                          assignNewStoreWatch.clearStoreFloor();
                        }
                      }
                    },
                    buttonText: LocaleKeys.keyAdd.localized,

                  ),
                )
              ],
            ),
          ),
          SizedBox(height: context.height * 0.025),

          ///Table
          Expanded(
            child: CommonTableGenerator(
              // Header widgets for the table
              headerContent: [
                CommonHeader(title: LocaleKeys.keySerialNo.localized),
                CommonHeader(title: LocaleKeys.keyFloorNo.localized, flex: 2),
              ],
              // Data list from ads controller
              childrenHeader: assignNewStoreWatch.addedStoreList,

              // Row builder for each data row
              childrenContent: (index) {
                final item = assignNewStoreWatch.addedStoreList[index];
                return [CommonRow(title: item.storeName ?? ''), CommonRow(title: item.floorNumber ?? '', flex: 2)];
              },
              // Feature toggles
              isDeleteAvailable: true,
              isStatusAvailable: false,
              // Delete callback (unused for now)
              canDeletePermission: true,
              isDeleteVisible: (index) => true,
              onDelete: (index) {
                assignNewStoreWatch.removeAddedStore(index);
              },
              // Call pagination api method here
              onScrollListener: () {
                print('Api method called');
              },
              // Take reference from api loading variables
              isLoading: false,
            ),
          ),

          ///Buttons tab
          SizedBox(height: context.height * 0.025),
          Row(
            children: [
              CommonButton(
                buttonText: LocaleKeys.keySave.localized,
                width: context.width * 0.124,
                // isLoading: assignNewStoreWatch.assignStoreApiState.isLoading,
                onTap: () async {
                  // if (assignNewStoreWatch.addedStoreList.isNotEmpty) {
                  // await assignNewStoreWatch.assignStoreApi(context, destinationDetailWatch.currentDestinationUuid ?? '').then((
                  //     value,
                  //     ) async {
                  //   if (value.success?.status == ApiEndPoints.apiStatus_200) {
                  //     destinationDetailWatch.storeDestinationListApi(context);
                  //     ref.read(navigationStackController).pop();
                  //   }
                  // });
                  // }


                  final hasExistingStores = destinationDetailWatch.storeList.isNotEmpty;
                  final hasAddedStores = assignNewStoreWatch.addedStoreList.isNotEmpty;

                  /// If neither existing nor new stores are available, show error toast and return
                  if (!hasExistingStores && !hasAddedStores) {
                    showToast(context: context, title: LocaleKeys.keyPleaseSelectAStoreNameAndFloor.localized, isSuccess: false,);
                    return;
                  }

                  await assignNewStoreWatch.assignStoreApi(context, destinationDetailWatch.currentDestinationUuid ?? '',).then((value) async {
                    if (value.success?.status == ApiEndPoints.apiStatus_200) {
                      destinationDetailWatch.storeDestinationListApi(context);
                      ref.read(navigationStackController).pop();
                    }
                  });

                },
              ),
              SizedBox(width: context.width * 0.020),
              CommonButton(
                buttonText: LocaleKeys.keyCancel.localized,
                onTap: () {
                  ref.read(navigationStackController).pop();
                },
                width: context.width * 0.124,
                backgroundColor: AppColors.white,
                buttonTextColor: AppColors.clr787575,
                borderColor: AppColors.clr787575,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
