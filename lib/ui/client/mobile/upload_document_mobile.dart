import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/scheduler.dart';

class UploadDocumentMobile extends ConsumerStatefulWidget {
  const UploadDocumentMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<UploadDocumentMobile> createState() =>
      _UploadDocumentMobileState();
}

class _UploadDocumentMobileState extends ConsumerState<UploadDocumentMobile> {

  ///Init Override
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }

  ///Dispose Override
  @override
  void dispose() {
    super.dispose();
  }

  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _bodyWidget(),
    );
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }


}
