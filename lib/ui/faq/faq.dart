import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/drawer/drawer_controller.dart';
import 'package:odigov3/framework/controller/faq/faq_controller.dart';
import 'package:odigov3/framework/repository/dashboard/model/sidemenu_list_response_model.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/faq/mobile/faq_mobile.dart';
import 'package:odigov3/ui/faq/web/faq_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class Faq extends ConsumerStatefulWidget {
  const Faq({super.key});

  @override
  ConsumerState<Faq> createState() => _FaqState();
}

class _FaqState extends ConsumerState<Faq> with WidgetsBindingObserver, ZoomAwareMixin {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SidebarModel? selectedMainScreen = ref.read(drawerController).selectedMainScreen;
    if(selectedMainScreen?.canViewSidebar == true && selectedMainScreen?.canView == true) {
      final faqRead = ref.read(faqController);
      faqRead.disposeController();
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
        final faqWatch = ref.watch(faqController);
        faqRead.faqListApi(context);

        faqWatch.faqListScrollCtr.addListener(() async {
          if (faqWatch.faqListScrollCtr.position.maxScrollExtent == faqWatch.faqListScrollCtr.position.pixels) {
            if (faqWatch.faqListState.success?.hasNextPage == true && !faqWatch.faqListState.isLoadMore) {
              await faqWatch.faqListApi(context, isForPagination: true);
            }
          }
        });
      });
    }
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return const FaqWeb();
        },
        tablet: (BuildContext context) {
          return const FaqWeb();
        },
        desktop: (BuildContext context) {
          return const FaqWeb();
        },
    );
  }
}

