import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';
import '../../../framework/controller/ads_sequence_preview/ads_sequence_preview_controller.dart';

class AdsSequencePreviewMobile extends ConsumerStatefulWidget {
  const AdsSequencePreviewMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<AdsSequencePreviewMobile> createState() => _AdsSequencePreviewMobileState();
}

class _AdsSequencePreviewMobileState extends ConsumerState<AdsSequencePreviewMobile> {

  ///Init:- This method will trigger when widget will initialized.
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final adsSequencePreviewWatch = ref.watch(adsSequencePreviewController);
      //adsSequencePreviewWatch.disposeController(isNotify : true);
    });
  }

  ///Dispose:- This method will trigger when widget about to remove from navigation stack.
  @override
  void dispose() {
    super.dispose();
  }

  ///Build:- This method will trigger when widget is build.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///This method is responsible for returning the body widget
  Widget _bodyWidget() {
    return Container();
  }


}
