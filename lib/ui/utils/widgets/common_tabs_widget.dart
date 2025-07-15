


import 'package:flutter/material.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CustomTabBarScreen extends StatelessWidget {
  final int selectedIndex;
  final List<String> items;
  final Function(int selectedInd) onTap;
  final double? width;
  const CustomTabBarScreen({super.key,required this.selectedIndex,required this.items,required this.onTap, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: items.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {

            return InkWell(
              onTap: () => onTap(index),
              child: Container(
                height: 48,
                width: width ?? 155,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: index == selectedIndex ? AppColors.transparent: AppColors.clrE0E0E0 ),
                    color: index == selectedIndex ?  AppColors.clr2997FC : AppColors.white
                ),
                child: Center(
                  child: CommonText(
                    title: items[index].localized,
                      style: TextStyles.regular.copyWith(color: index == selectedIndex ? AppColors.white  : AppColors.clrC1C4D6,fontSize: 12)
                  ),
                ),
              ),
            );

        },
        separatorBuilder: (context,index) {
          return SizedBox(width: 18,);
        },
      ),
    );
  }
}

///How to use
/*
CustomTabBarScreen(selectedIndex:  ref.watch(splashController).selectedIndex,items: ["Bhumit Lukhi","Krishna Trada","Deep Patel"],onTap: (index) {
            ref.watch(splashController).updateSelectedIndex(index);
            },)
 */


