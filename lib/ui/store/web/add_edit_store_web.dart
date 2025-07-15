
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/routing/stack.dart';
import 'package:odigov3/ui/store/web/helper/add_edit_store_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_empty_state_widget.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditStoreWeb extends ConsumerStatefulWidget {
  final String? storeUuid;
  const AddEditStoreWeb({super.key, this.storeUuid});

  @override
  ConsumerState<AddEditStoreWeb> createState() => _AddEditStoreWebState();
}

class _AddEditStoreWebState extends ConsumerState<AddEditStoreWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final addEditStoreWatch = ref.watch(addEditStoreController);
    final categoryListWatch = ref.watch(categoryListController);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
          BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
        ],
      ),
      child: categoryListWatch.categoryListState.isLoading || ((widget.storeUuid != null) && addEditStoreWatch.storeDetailState.isLoading)
          ? CommonAnimLoader()
          : ((widget.storeUuid != null) && addEditStoreWatch.storeDetailState.success?.data == null)
            ? Center(child: CommonEmptyStateWidget(title: LocaleKeys.keySomeThingWentWrong.localized,))
            : Stack(
              children: [
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonText(
                        title: (widget.storeUuid == null) ? LocaleKeys.keyAddStore.localized : LocaleKeys.keyEditStore.localized,
                        style: TextStyles.semiBold.copyWith(fontSize: 14, color: AppColors.black),
                      ).paddingOnly(bottom: context.height * 0.034),
                      /// main form widget
                      AddEditStoreWidget(uuid: widget.storeUuid).paddingOnly(bottom: context.height * 0.03),
                      /// save and back button
                      Consumer(
                        builder: (context, ref, child) {
                          final addEditStoreWatch = ref.watch(addEditStoreController);
                          final categoryListWatch = ref.watch(categoryListController);
                          return Row(
                            children: [
                              Visibility(
                                visible: !(categoryListWatch.categoryListState.isLoading || ((widget.storeUuid != null) && addEditStoreWatch.storeDetailState.isLoading)),
                                child: CommonButton(
                                  buttonText: LocaleKeys.keySave.localized,
                                  buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.white),
                                  borderRadius: BorderRadius.circular(6),
                                  width: context.width * 0.1,
                                  height: context.height * 0.06,
                                  isLoading: addEditStoreWatch.addEditStoreState.isLoading || addEditStoreWatch.uploadStoreImageState.isLoading,
                                  onTap: () async {
                                    addEditStoreWatch.addEditStoreApiCall(context, ref, storeUuid: widget.storeUuid);
                                  },
                                ).paddingOnly(right: context.width * 0.015),
                              ),
                              CommonButton(
                                buttonText: LocaleKeys.keyBack.localized,
                                buttonTextStyle : TextStyles.medium.copyWith(fontSize: 14, color: AppColors.clr787575),
                                backgroundColor: AppColors.transparent,
                                borderColor: AppColors.clr9E9E9E,
                                borderRadius: BorderRadius.circular(6),
                                width: context.width * 0.1,
                                height: context.height * 0.06,
                                onTap: () {
                                  ref.read(navigationStackController).pop();
                                },
                              ),
                            ],
                          );
                        }
                      ),
                    ],
                  ).paddingSymmetric(horizontal: context.width * 0.020, vertical: context.height * 0.030),
                /// Loader on add/update api call
                if(addEditStoreWatch.addEditStoreState.isLoading)
                  Container(color: AppColors.white.withValues(alpha: 0.8),child: CommonAnimLoader()),
              ],
            ),
    );
  }

}
