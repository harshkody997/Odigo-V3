import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/auth/login_controller.dart';
import 'package:odigov3/framework/controller/profile/profile_controller.dart';
import 'package:odigov3/framework/provider/network/api_end_points.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/profile/web/profile_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    final profileWatch = ref.read(profileController);
    profileWatch.disposeController();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async{
      final loginWatch = ref.read(loginController);
      await loginWatch.getLanguageListAPI(context,ref).then((value) async {
        if(loginWatch.languageListState.success?.status == ApiEndPoints.apiStatus_200){
          await profileWatch.getProfileDetail(context, ref);
        }
      });


    });
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) {
        return const ProfileWeb();
      },
      tablet: (BuildContext context) {
        return const ProfileWeb();
      },
      desktop: (BuildContext context) {
        return const ProfileWeb();
      },
    );
  }
}
