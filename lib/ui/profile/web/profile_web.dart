import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/ui/drawer/web/base_drawer_page_widget.dart';
import 'package:odigov3/ui/profile/web/helper/edit_personal_info_widget.dart';
import 'package:odigov3/ui/profile/web/helper/personal_info_widget.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_anim_loader.dart';

class ProfileWeb extends ConsumerStatefulWidget {
  const ProfileWeb({super.key});

  @override
  ConsumerState<ProfileWeb> createState() => _ProfileWebState();
}

class _ProfileWebState extends ConsumerState<ProfileWeb> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return BaseDrawerPageWidget(
        body: (ref.watch(profileController).profileDetailState.isLoading) ? Center(child: CommonAnimLoader()) : Row(
          children: [
            ///left information widget
            Expanded(
              flex: 2,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                ),
                child:  PersonalInfoWidget(),
              ),
            ),
            SizedBox(width: context.height * 0.02,),
            ///Right edit data widget
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(8),
                  shape: BoxShape.rectangle,
                ),
                child:  EditPersonalInfoWidget().paddingSymmetric( horizontal: context.width * 0.025, vertical: context.width * 0.025),
              ),
            )

          ],
        ));
  }
}
