import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/destination/store_mapping/store_mapping_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_confirmation_dialog.dart';
import 'package:odigov3/ui/utils/widgets/common_searchable_dropdown.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class StoreMappingWeb extends ConsumerStatefulWidget {
  const StoreMappingWeb({super.key});

  @override
  ConsumerState<StoreMappingWeb> createState() => _StoreMappingMobileState();
}

class _StoreMappingMobileState extends ConsumerState<StoreMappingWeb> {
  @override
  Widget build(BuildContext context) {
    final storeMappingWatch = ref.watch(storeMappingController);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: storeMappingWatch.storeMappingFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(title: LocaleKeys.keyAssignStore.localized, style: TextStyles.regular.copyWith(fontSize: 22)),
              const SizedBox(height: 30),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  /// Store Dropdown
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: AppColors.clrEAEAEA),
                          bottom: BorderSide(color: AppColors.clrEAEAEA),
                          left: BorderSide(color: AppColors.clrEAEAEA),
                          right: BorderSide.none,
                        ),
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                      ),
                      child: CommonSearchableDropdown(
                        textEditingController: storeMappingWatch.selectStoreController,
                        items: storeMappingWatch.storeList,
                        hintText: LocaleKeys.keySelectStore.localized,
                        fieldHeight: 60,
                        suffixWidget: CommonSVG(strIcon: Assets.svgs.svgDropDown.keyName, height: 24, width: 24),
                        borderColor: AppColors.transparent,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.keyErrorSelectStore.localized;
                          }
                          return null;
                        },
                        onSelected: (value) {
                          storeMappingWatch.updateSelectedStore(value);
                        },
                        title: (store) {
                          return store;
                        },
                      ),
                    ),
                  ),

                  /// Floor Dropdown
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.clrEAEAEA),
                        borderRadius: const BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                      ),
                      child: CommonSearchableDropdown(
                        textEditingController: storeMappingWatch.selectFloorController,
                        items: storeMappingWatch.floorList,
                        hintText: LocaleKeys.keySelectFloor.localized,
                        fieldHeight: 60,
                        suffixWidget: CommonSVG(strIcon: Assets.svgs.svgDropDown.keyName, height: 24, width: 24),
                        borderColor: AppColors.transparent,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return LocaleKeys.keyErrorSelectFloor.localized;
                          }
                          return null;
                        },
                        onSelected: (value) {
                          storeMappingWatch.updateSelectedFloor(int.parse(value));
                        },
                        title: (floor) {
                          return floor;
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  /// +Add Button
                  CommonButton(
                    height: context.width * 0.035,
                    width: context.width * 0.07,
                    backgroundColor: AppColors.clr009AF1,
                    onTap: () {
                      final isValid = storeMappingWatch.storeMappingFormKey.currentState!.validate();
                      if (isValid) {
                        storeMappingWatch.addStore();
                        storeMappingWatch.clearDropdownsData();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          storeMappingWatch.storeMappingFormKey.currentState!.reset();
                        });
                      }
                    },
                    buttonText: '+${LocaleKeys.keyAdd.localized}',
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Store Assignment Table
              storeMappingWatch.assignedStores.isNotEmpty
                  ? Flexible(
                      child: Container(
                        width: context.width,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DataTable(
                          columns: [
                            DataColumn(label: CommonText(title: LocaleKeys.keySrNo.localized, clrFont: AppColors.clr8D8D8D)),
                            DataColumn(label: CommonText(title: LocaleKeys.keyStore.localized, clrFont: AppColors.clr8D8D8D)),
                            DataColumn(label: CommonText(title: LocaleKeys.keyFloorNo.localized, clrFont: AppColors.clr8D8D8D)),
                            DataColumn(label: CommonText(title: LocaleKeys.keyAction.localized, clrFont: AppColors.clr8D8D8D)),
                          ],
                          rows: List.generate(storeMappingWatch.assignedStores.length, (index) {
                            final item = storeMappingWatch.assignedStores[index];
                            return DataRow(
                              cells: [
                                DataCell(CommonText(title: '${index + 1}', fontSize: 16,)),
                                DataCell(CommonText(title: item.store, fontSize: 16,)),
                                DataCell(CommonText(title: '${item.floor}', fontSize: 16,)),
                                DataCell(
                                  /// Delete confirmation Dialog overlay
                                  CommonConfirmationOverlayWidget(
                                    title: LocaleKeys.keyDelete.localized,
                                    description: LocaleKeys.keyDeleteConfirmationMsg.localized,
                                    positiveButtonText: LocaleKeys.keyDelete.localized,
                                    negativeButtonText: LocaleKeys.keyCancel.localized,
                                    onButtonTap: (isPositive) {
                                      if (isPositive) {
                                        storeMappingWatch.removeStore(index);
                                      }
                                    },
                                    child: CommonText(title: LocaleKeys.keyDelete.localized, clrFont: AppColors.clrDC3545, fontSize: 16),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    )
                  : const Offstage(),
            ],
          ),
        ),
      ),
    );
  }
}
