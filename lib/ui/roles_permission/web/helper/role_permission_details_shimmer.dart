import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class RolePermissionDetailsShimmer extends StatelessWidget {
  const RolePermissionDetailsShimmer({super.key});
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: context.width * 0.1,
            height:context.height * 0.042,
            decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColors.white),
          ).paddingOnly(top: context.height * 0.03),

          Row(
            children: [

              Container(
                width: context.width * 0.15,
                height:context.height * 0.03,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColors.white),
              ),


              SizedBox(
                  height: context.height * 0.02,
                  child: VerticalDivider(color: AppColors.clrE0E0E0,).paddingSymmetric(horizontal: context.width * 0.01)),

              Container(
                width: context.width * 0.1,
                height:context.height * 0.03,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColors.white),
              ),

              SizedBox(
                  height: context.height * 0.02,
                  child: VerticalDivider(color: AppColors.clrE0E0E0,).paddingSymmetric(horizontal: context.width * 0.01)),

              Container(
                width: context.width * 0.1,
                height:context.height * 0.03,
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8)), color: AppColors.white),
              ),
            ],
          ).paddingOnly(top: context.height * 0.02,bottom: context.height * 0.04)
        ],
      )
    );
  }
}
