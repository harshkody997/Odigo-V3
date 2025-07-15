import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/category_data_list_response_model.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_form_field.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CategorySelectionWidget extends ConsumerStatefulWidget {
  const CategorySelectionWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<CategorySelectionWidget> createState() => _MultiSelectionDialogState();
}

class _MultiSelectionDialogState extends ConsumerState<CategorySelectionWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final addEditStoreWatch = ref.watch(addEditStoreController);
    return CommonInputFormField(
      textEditingController: TextEditingController(),
      isEnable: true,
      borderRadius: BorderRadius.circular(6),
      validator: (value) {
        if(addEditStoreWatch.selectedBusinessCategories.isNotEmpty){
          return null;
        }else{
          return LocaleKeys.keyCategoryShouldBeRequired.localized;
        }
      },
      prefixWidget: InkWell(
        onTap: (){
          _showOverlay();
        },
        child: Row(
          children: [
            Expanded(
              child: addEditStoreWatch.selectedBusinessCategories.isEmpty
                  ? CommonText(
                title: LocaleKeys.keySelectCategory.localized,
                style: TextStyles.medium.copyWith(color: AppColors.textFieldBorderColor, fontSize: 14),
              )
                  :
              SizedBox(
                height: context.height * 0.06,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  // shrinkWrap: true,
                  itemCount: addEditStoreWatch.selectedBusinessCategories.length,
                  itemBuilder: (BuildContext context, int index) {
                    CategoryDataListDto item = addEditStoreWatch.selectedBusinessCategories[index];
                    return Container(
                      height: context.height * 0.05,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: AppColors.whiteEAEAEA,
                        ),
                      ),
                      child: Row(
                        children: [
                          CommonText(
                            title: item.name ?? '',
                            style: TextStyles.medium.copyWith(color: AppColors.textFieldBorderColor, fontSize: 14),
                          ),
                          SizedBox(width: context.width * 0.005),
                          InkWell(
                            onTap: () {
                              addEditStoreWatch.updateSelectedCategory(item, false);
                            },
                            child:  CommonSVG(
                              strIcon: Assets.svgs.svgCrossRounded.keyName,
                              height: context.height * 0.03,
                              width: context.height * 0.03,
                            ).paddingAll(5),
                          ),
                        ],
                      ).paddingOnly(left: context.width * 0.01, right: context.width * 0.005),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(width: context.width * 0.01);
                  },
                ).paddingSymmetric(vertical: context.height * 0.005),
              ),
            ),
            SizedBox(width: context.width * 0.005),
            CommonSVG(
              strIcon: Assets.svgs.svgDropDown.keyName,
              height: context.height * 0.03,
              width: context.height * 0.03,
            ),
          ],
        ).paddingOnly(right: context.width * 0.006, left: context.width * 0.01),
      ),
    );
  }

  /// for overlay selection

  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showOverlay() {
    if(_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    }
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    Offset offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              _hideOverlay();
              FocusScope.of(context).unfocus();
            },
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: offset.dx,
            top: offset.dy + size.height,
            width: /*widget.fieldWidth ?? */size.width,
            child: Consumer(
                builder: (context,ref, child) {
                  final addEditStoreWatch = ref.watch(addEditStoreController);
                  return CompositedTransformFollower(
                    link: _layerLink,
                    showWhenUnlinked: true,
                    offset: Offset(0.0, (/*widget.fieldHeight ??*/ size.height) + 10),
                    child: Material(
                      elevation: 4.0,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        color: AppColors.white,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxHeight: context.height * 0.4, maxWidth: context.width *0.2),
                          child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    CheckboxListTile(
                                      title: CommonText(
                                        title: LocaleKeys.keySelectAll.localized,
                                        style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 12),
                                      ),
                                      value: (addEditStoreWatch.categoryList.every(addEditStoreWatch.selectedBusinessCategories.contains)) && addEditStoreWatch.categoryList.isNotEmpty,
                                      onChanged: (checked) {
                                        addEditStoreWatch.addAllCategory(checked, addEditStoreWatch.categoryList);

                                      },
                                      controlAffinity: ListTileControlAffinity.leading,
                                      activeColor: AppColors.green35C658,
                                      checkboxScaleFactor: 0.8,
                                    ),
                                    const Divider(color: AppColors.dividerColor),
                                    ...addEditStoreWatch.categoryList.map((category) {
                                      return Column(
                                        children: [
                                          CheckboxListTile(
                                            title: CommonText(
                                              title: category.name ?? '',
                                              style: TextStyles.regular.copyWith(color: AppColors.black, fontSize: 12),
                                            ),
                                            value: addEditStoreWatch.selectedBusinessCategories.contains(category),
                                            onChanged: (checked) {
                                              addEditStoreWatch.updateSelectedCategory(category, checked);
                                            },
                                            controlAffinity: ListTileControlAffinity.leading,
                                            activeColor: AppColors.green35C658,
                                            checkboxScaleFactor: 0.8,
                                          ),
                                          if(category != addEditStoreWatch.categoryList.last)
                                            const Divider(color: AppColors.dividerColor),
                                        ],
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}
