import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientAdsMobile extends ConsumerStatefulWidget {
  const ClientAdsMobile({Key? key}) : super(key: key);

  @override
  ConsumerState<ClientAdsMobile> createState() => _ClientAdsMobileState();
}

class _ClientAdsMobileState extends ConsumerState<ClientAdsMobile> {
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
