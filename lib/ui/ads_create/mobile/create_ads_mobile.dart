import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateAdsMobile extends ConsumerStatefulWidget {
  const CreateAdsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateAdsMobile> createState() => _CreateAdsMobileState();
}

class _CreateAdsMobileState extends ConsumerState<CreateAdsMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container();
  }
}
