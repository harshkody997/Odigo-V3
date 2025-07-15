import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/profile/web/helper/dot_lines_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:shimmer/shimmer.dart';

class ProfileDetailShimmer extends ConsumerWidget {
  const ProfileDetailShimmer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            ///left information widget
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  // color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                  shape: BoxShape.rectangle,
                ),
                child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ///language widget here
                        Container(
                          width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(10),
                            shape: BoxShape.rectangle,
                          ),
                        ).alignAtCenterRight(),

                        SizedBox(height: context.height * 0.05),

                        ///Display Profile Image
                        Container(
                          height: context.height * 0.220,
                          width: context.height * 0.220,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: BoxShape.circle,
                          ),
                        ),

                        ///Company name
                        Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).paddingSymmetric(vertical: context.height * 0.035),
                        Spacer(),

                        ///Common Personal information Tile - Email Id
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ).paddingSymmetric(vertical: context.height * 0.015),
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ).paddingSymmetric(
                      vertical: context.height * 0.020,
                      horizontal: context.width * 0.02,
                    ),
              ),
            ),
            SizedBox(width: context.height * 0.02),

            ///Right edit data widget
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  shape: BoxShape.rectangle,
                ),
                child:
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ///Title
                        Container(
                          width: 150,
                          height: 20,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: context.height * 0.03),

                        Container(
                          // width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: context.height * 0.03),

                        Container(
                          // width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        SizedBox(height: context.height * 0.03),

                        Container(
                          // width: 150,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        Spacer(),

                        ///Dot lines widget
                        DotLinesWidget(),

                        SizedBox(height: context.height * 0.03),

                        Row(
                          children: [
                            ///change password button
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(width: context.width * 0.023),

                            ///Back button
                            Container(
                              width: 150,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ).paddingSymmetric(
                      horizontal: context.width * 0.025,
                      vertical: context.width * 0.025,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
