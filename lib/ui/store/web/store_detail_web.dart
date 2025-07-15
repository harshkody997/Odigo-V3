import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/store/store_detail_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/store/web/helper/store_destination_list.dart';
import 'package:odigov3/ui/store/web/helper/store_details_top_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class StoreDetailWeb extends ConsumerStatefulWidget {
  final String storeUuid;
  const StoreDetailWeb({super.key, required this.storeUuid});

  @override
  ConsumerState<StoreDetailWeb> createState() => _StoreDetailWebState();
}

class _StoreDetailWebState extends ConsumerState<StoreDetailWeb> {

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return BaseDrawerPageWidget(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    final storeDetailWatch = ref.watch(storeDetailController);

    return storeDetailWatch.storeLanguageDetailState.isLoading
        ? CommonAnimLoader()
        : Column(
      children: [
        /// store detail top widget
        StoreDetailsTopWidget(storeUuid: widget.storeUuid),

        SizedBox(
          height: context.height * 0.030,
        ),

        /// destination list
        Expanded(
          child: StoreDestinationList(storeUuid: widget.storeUuid),
        ),
      ],
    );
  }

}
