import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/city/add_edit_city_controller.dart';
import 'package:odigov3/framework/controller/master/country/country_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/master/city/web/add_edit_city_form_widget.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/app_strings.g.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class AddEditCityWeb extends ConsumerStatefulWidget {
  final bool? isEdit;
  final String? uuid;
  const AddEditCityWeb({Key? key,this.isEdit,this.uuid}) : super(key: key);

  @override
  ConsumerState<AddEditCityWeb> createState() => _AddEditCityWebState();
}

class _AddEditCityWebState extends ConsumerState<AddEditCityWeb> {

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    final addEditCityWatch = ref.watch(addEditCityController);
    final countryListWatch = ref.watch(countryListController);
    return BaseDrawerPageWidget(
      body: addEditCityWatch.cityDetailsState.isLoading || countryListWatch.countryListState.isLoading
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
          child: Container(
            decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// add city text
                CommonText(title: widget.isEdit == true ? LocaleKeys.keyEditCity.localized : LocaleKeys.keyAddCity.localized, fontWeight: TextStyles.fwSemiBold).paddingOnly(bottom: 24),

                /// city textField form widget
                AddEditCityFormWidget(isEdit: widget.isEdit,uuid: widget.uuid,),
              ],
            ).paddingAll(context.height * 0.025),
          ).paddingAll(context.height * 0.01),
        ),
      ),
    );
  }

}
