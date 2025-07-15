import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/store/store_detail_controller.dart';
import 'package:odigov3/framework/repository/store/model/store_language_detail_api.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/cache_image.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';
import 'package:shimmer/shimmer.dart';

class StoreDetailsTopWidget extends ConsumerWidget {
  final String storeUuid;

  const StoreDetailsTopWidget({super.key, required this.storeUuid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storeDetailWatch = ref.watch(storeDetailController);
    StoreLanguageDetailData? storeData = storeDetailWatch.storeLanguageDetailState.success?.data;
    return /*storeDetailWatch.storeLanguageDetailState.isLoading
        ? _topShimmer(context)
        : */Row(
      children: [
        CacheImage(
          imageURL: storeData?.storeImageUrl ?? '',
          placeholderName: 'store image',
          height: context.height * 0.18,
          width: context.height * 0.18,
          bottomLeftRadius: context.height * 0.2,
          bottomRightRadius: context.height * 0.2,
          topLeftRadius: context.height * 0.2,
          topRightRadius: context.height * 0.2,
        ).paddingOnly(right: context.width * 0.020),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText(
                title: storeData?.name ?? '',
                style: TextStyles.semiBold.copyWith(fontSize: 18, color: AppColors.black),
                maxLines: 4,
              ).paddingOnly(bottom: context.height * 0.010),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CommonText(
                    title: '${LocaleKeys.keyCategory.localized}:',
                    style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr7C7474),
                    maxLines: 4,
                  ).paddingOnly(right: context.width * 0.01),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...List.generate(
                            storeData?.businessCategories?.length ?? 0,
                                (index) => Container(
                              decoration: BoxDecoration(
                                color: AppColors.clr2997FC.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(context.width * 0.007),
                              child: CommonText(title: storeData?.businessCategories?[index].name??'', style: TextStyles.regular.copyWith(fontSize: 14, color: AppColors.clr2997FC), maxLines: 4),
                            ).paddingOnly(right: context.width*0.01),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    ).paddingOnly(left: context.width * 0.02);
  }

  Widget _topShimmer(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Shimmer.fromColors(
        baseColor: AppColors.shimmerBaseColor,
        highlightColor: AppColors.white,
        child: Row(
          children: [
            Container(
              height: context.height * 0.18,
              width: context.height * 0.18,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white
              ),
            ).paddingOnly(right: context.width * 0.020),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: context.height * 0.04,
                  width: context.width * 0.15,
                  decoration: BoxDecoration(
                      color: AppColors.white
                  ),
                ).paddingOnly(bottom: context.height * 0.010),
                Container(
                  height: context.height * 0.04,
                  width: context.width * 0.3,
                  decoration: BoxDecoration(
                      color: AppColors.white
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
