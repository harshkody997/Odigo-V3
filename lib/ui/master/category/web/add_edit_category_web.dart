import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/category/add_edit_category_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/category/web/helper/add_edit_category_form_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditCategoryWeb extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditCategoryWeb({Key? key,this.isEdit, this.uuid,}) : super(key: key);

  @override
  ConsumerState<AddEditCategoryWeb> createState() => _AddEditCategoryWebState();
}

class _AddEditCategoryWebState extends ConsumerState<AddEditCategoryWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final addEditStateWatch = ref.watch(addEditCategoryController);
    return BaseDrawerPageWidget(
      body: addEditStateWatch.categoryDetailsState.isLoading
          ? CommonAnimLoader()
          : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.6), blurRadius: 2, offset: Offset(0, 1)),
            BoxShadow(color: AppColors.clr101828.withValues(alpha: 0.1), blurRadius: 3, offset: Offset(0, 1)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// add/edit category text
              CommonText(title: widget.isEdit == true ? LocaleKeys.keyEditCategory.localized : LocaleKeys.keyAddCategory.localized,
                  fontWeight: TextStyles.fwSemiBold
              ).paddingOnly(bottom: 24),

              /// category textFields
              AddEditCategoryFormWidget(isEdit: widget.isEdit,uuid: widget.uuid)
            ],
          ).paddingAll(context.height * 0.025),
        ).paddingAll(context.height * 0.01),
      ),
    );
  }
}
