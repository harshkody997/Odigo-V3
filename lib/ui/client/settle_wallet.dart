import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/framework/controller/client/client_details_controller.dart';
import 'package:odigov3/framework/utils/web_view_ui/zoom_aware_mixin.dart';
import 'package:odigov3/ui/client/web/settle_wallet_web.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SettleWallet extends ConsumerStatefulWidget {
  final String clientUuid;
  const SettleWallet({Key? key,required this.clientUuid}) : super(key: key);

  @override
  ConsumerState<SettleWallet> createState() => _SettleWalletState();
}

class _SettleWalletState extends ConsumerState<SettleWallet> with WidgetsBindingObserver, ZoomAwareMixin{

  @override
  void initState() {
    final clientDetailsRead = ref.read(clientDetailsController);
    clientDetailsRead.clearSettleWalletFormData();
    SchedulerBinding.instance.addPostFrameCallback((_){
      Future.delayed(const Duration(milliseconds: 1200),(){
        clientDetailsRead.updateStaticLoader(false,isNotify: true);
      });
    });
    super.initState();
  }

  ///Build Override
  @override
  Widget buildPage(BuildContext context) {
    return ScreenTypeLayout.builder(
        mobile: (BuildContext context) {
          return SettleWalletWeb(clientUuid:widget.clientUuid);
        },
        tablet: (BuildContext context) {
          return SettleWalletWeb(clientUuid:widget.clientUuid);
        },
        desktop: (BuildContext context) {
          return SettleWalletWeb(clientUuid:widget.clientUuid);
        }
    );
  }
}

