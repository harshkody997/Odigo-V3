import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/destination_details_controller.dart';
import 'package:odigov3/framework/controller/device/device_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/repository/destination/model/floor_list_response_model.dart';
import 'package:odigov3/framework/repository/device/model/device_list_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_table_generator.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:odigov3/framework/controller/assign_new_robot/assign_new_robot_controller.dart';

class AssignNewRobotWeb extends ConsumerStatefulWidget {
  const AssignNewRobotWeb({Key? key}) : super(key: key);

  @override
  ConsumerState<AssignNewRobotWeb> createState() => _AssignNewRobotWebState();
}

class _AssignNewRobotWebState extends ConsumerState<AssignNewRobotWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    final assignNewRobotWatch = ref.watch(assignNewRobotController);

    return BaseDrawerPageWidget(
      body: Stack(
        children: [
          _bodyWidget(),
          assignNewRobotWatch.assignRobotApiState.isLoading ? Container(color: AppColors.white.withValues(alpha: 0.8), child: CommonAnimLoader()) : Offstage(),
        ],
      ),
      isApiLoading: assignNewRobotWatch.assignRobotApiState.isLoading,
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: AppColors.white),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            title: LocaleKeys.keyAssignNewRobot.localized,
            style: TextStyles.bold.copyWith(color: AppColors.black, fontSize: 14),
          ),

          ///Dropdowns and table contents
          _contentData(),
        ],
      ).paddingSymmetric(vertical: context.height * 0.025, horizontal: context.height * 0.025),
    );
  }

  ///Dropdowns and table contents
  _contentData() {
    final assignNewRobotWatch = ref.watch(assignNewRobotController);
    final destinationDetailsWatch = ref.watch(destinationDetailsController);
    final deviceWatch = ref.watch(deviceController);
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: context.height * 0.025),
          Form(
            key: assignNewRobotWatch.formKey,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Select robot dropdown
                Expanded(
                  flex: 4,
                  child: CommonSearchableDropdown(
                    hintText: LocaleKeys.keySelectRobot.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    onSelected: (value) {
                      assignNewRobotWatch.updateRobotDropdown(value);
                    },
                    textEditingController: assignNewRobotWatch.robotSelectionCtr,
                    items: assignNewRobotWatch.devicesList,
                    validator: (value) {
                      return assignNewRobotWatch.validateRobotDrop();
                    },
                    title: (DeviceData? str) {
                      return "${str?.hostName ?? ''} - ${str?.serialNumber ?? ''}";
                    },
                    onScrollListener: () {
                      assignNewRobotWatch.deviceGlobalListApi(true).then((value) {
                        if (value.success?.status == ApiEndPoints.apiStatus_200) {
                          ref.read(searchController).notifyListeners();
                        }
                      });
                    },
                  ).paddingOnly(bottom: context.height * 0.025),
                ),
                SizedBox(width: context.height * 0.025),
                Expanded(
                  flex: 4,
                  child: CommonSearchableDropdown<FloorListDto>(
                    hintText: LocaleKeys.keyFloor.localized,
                    hintTextStyle: TextStyles.regular.copyWith(fontSize: 12, color: AppColors.clr8D8D8D),
                    onSelected: (value) {
                      assignNewRobotWatch.updateFloorDropdown(value);
                      // if (assignNewRobotWatch.selectedRobot == null) {
                      //   assignNewRobotWatch.validateRobotDrop();
                      // } else {
                      //   assignNewRobotWatch.updateRobotList(
                      //     RobotFloorModel(
                      //       robotHostName: assignNewRobotWatch.selectedRobot?.hostName,
                      //       robotSerialName: assignNewRobotWatch.selectedRobot?.serialNumber,
                      //       robotUuid: assignNewRobotWatch.selectedRobot?.uuid,
                      //       floorNumber: assignNewRobotWatch.selectedFloor,
                      //     ),
                      //     context,
                      //   );
                      //   // assignNewRobotWatch.clearRobotFloor();
                      // }
                    },
                    textEditingController: assignNewRobotWatch.floorSelectionCtr,
                    items: destinationDetailsWatch.floorList ?? [],
                    validator: (value) {
                      return assignNewRobotWatch.validateFloorDrop();
                    },
                    title: (FloorListDto item) {
                      return item.floorNumber.toString();
                    },
                  ).paddingOnly(bottom: context.height * 0.025),
                ),
                SizedBox(width: context.height * 0.025),
                Flexible(
                  child: CommonButton(
                    onTap: (){
                      if(assignNewRobotWatch.formKey.currentState!.validate()) {
                        if (assignNewRobotWatch.selectedRobot != null &&
                            assignNewRobotWatch.selectedFloor != null) {
                          assignNewRobotWatch.updateRobotList(
                            RobotFloorModel(
                              robotHostName: assignNewRobotWatch.selectedRobot?.hostName,
                              robotSerialName: assignNewRobotWatch.selectedRobot?.serialNumber,
                              robotUuid: assignNewRobotWatch.selectedRobot?.uuid,
                              floorNumber: assignNewRobotWatch.selectedFloor?.floorNumber.toString(),
                              floorUuid: assignNewRobotWatch.selectedFloor?.uuid
                            ),
                            context,
                          );

                          // Clear selections
                          assignNewRobotWatch.clearRobotFloorControllers();
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
                CommonHeader(title: LocaleKeys.keySerialNumber.localized),

                CommonHeader(title: LocaleKeys.keyFloorNo.localized, flex: 2),
              ],

              // Data list from ads controller
              childrenHeader: assignNewRobotWatch.addedRobotList,

              // Row builder for each data row
              childrenContent: (index) {
                final item = assignNewRobotWatch.addedRobotList[index];
                return [
                  CommonRow(title: "${item.robotHostName ?? ''} - ${item.robotSerialName ?? ''}"),
                  CommonRow(title: item.floorNumber ?? '', flex: 2),
                ];
              },
              // Feature toggles
              isDeleteAvailable: true,
              isStatusAvailable: false,
              // Delete callback (unused for now)
              onDelete: (index) {
                assignNewRobotWatch.removeAddedRobot(index);
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
                // isLoading: assignNewRobotWatch.assignRobotApiState.isLoading,
                onTap: () async {
                  // if (assignNewRobotWatch.addedRobotList.isNotEmpty) {
                  await assignNewRobotWatch.assignRobotApi(context, destinationDetailsWatch.currentDestinationUuid ?? '').then((
                    value,
                  ) async {
                    if (value.success?.status == ApiEndPoints.apiStatus_200) {
                      // assignNewRobotWatch.disposeController(isNotify: true);
                      await deviceWatch.deviceListApi(false, destinationUuid: destinationDetailsWatch.currentDestinationUuid ?? '');
                      ref.read(navigationStackController).pop();
                    }
                  });
                  // } else {
                  //   assignNewRobotWatch.disposeController(isNotify: true);
                  //   ref.read(navigationStackController).pop();
                  // }
                },
              ),
              SizedBox(width: context.width * 0.020),
              CommonButton(
                buttonText: LocaleKeys.keyCancel.localized,
                onTap: () {
                  assignNewRobotWatch.disposeController(isNotify: true);
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
