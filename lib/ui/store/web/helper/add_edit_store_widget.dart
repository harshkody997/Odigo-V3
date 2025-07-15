import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/master/category/category_list_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/store/web/helper/category_selection_widget.dart';
import 'package:odigov3/ui/utils/app_enums.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/framework/controller/store/add_edit_store_controller.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';
import 'package:odigov3/ui/utils/widgets/common_image_upload_form_field.dart';
import 'package:odigov3/ui/utils/widgets/dynamic_lang_form_widget.dart';

class AddEditStoreWidget extends ConsumerStatefulWidget {
  final String? uuid;
  const AddEditStoreWidget({super.key, this.uuid});

  @override
  ConsumerState<AddEditStoreWidget> createState() => _AddEditStoreWidgetState();
}

class _AddEditStoreWidgetState extends ConsumerState<AddEditStoreWidget> {

  ///Build
  @override
  Widget build(BuildContext context) {
    final addEditStoreWatch = ref.watch(addEditStoreController);
    final categoryListWatch = ref.watch(categoryListController);
    return categoryListWatch.categoryListState.isLoading || ((widget.uuid != null) && addEditStoreWatch.storeDetailState.isLoading)
        ? SizedBox(
      height: context.height * 0.25,
        child: CommonAnimLoader(),
    )
      : Form(
      key: addEditStoreWatch.addEditStoreFormKey,
      child: Column(
        children: [
          DynamicLangFormManager.instance.dynamicWidget(
            addEditStoreWatch.listForTextField,
            DynamicFormEnum.STORE,
            onFieldSubmitted: (value) {
              addEditStoreWatch.addEditStoreApiCall(context, ref, storeUuid: widget.uuid);
            },
          ),
          SizedBox(height: context.height * 0.02),
          CategorySelectionWidget(),
          SizedBox(height: context.height * 0.02),
          /// upload image textField
          CommonImageUploadFormField(
            labelText: LocaleKeys.keyStoreImage.localized,
            selectedImage: addEditStoreWatch.selectedImage,
            cacheImage: addEditStoreWatch.storeDetailState.success?.data?.storeImageUrl,
            onImageSelected: (image) {
              addEditStoreWatch.selectedImage = image;
              addEditStoreWatch.notifyListeners();
            },
            onImageRemoved: () {
              addEditStoreWatch.selectedImage = null;
              addEditStoreWatch.storeDetailState.success?.data?.storeImageUrl = null;
              addEditStoreWatch.notifyListeners();
            },
          ),
        ],
      ),
    );
  }
}
