import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

class CommonDashboardTabBar extends StatelessWidget {
  final List<String> tabList;
  final String? selectedTab;
  final Function(String tab) onTabSelect;

  const CommonDashboardTabBar({super.key, required this.tabList, required this.selectedTab, required this.onTabSelect});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(tabList.length, (index) {
        String tab = tabList[index];
        return InkWell(
          onTap: () {
            onTabSelect.call(tab);
          },
          child: Column(
            children: [
              CommonText(
                title: tab.localized,
                style: selectedTab == tab ? TextStyles.semiBold.copyWith(color: AppColors.clr2997FC, fontSize: 10) : TextStyles.semiBold.copyWith(color: AppColors.clr878787, fontSize: 10),
              ),
              SizedBox(height: context.height * 0.005),
              Container(height: context.height * 0.002, width: tab.localized.length * 7.0, color: (selectedTab == tab) ? AppColors.clr2997FC : AppColors.transparent),
            ],
          ),
        ).paddingOnly(right: index != (tabList.length - 1) ? context.width * 0.005 : 0);
      }),
    );
  }
}
