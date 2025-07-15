import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:odigov3/framework/utils/extension/context_extension.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';

class CommonAnimLoader extends StatelessWidget {
  const CommonAnimLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset(Assets.anim.animLoaderBlue.keyName, height: context.height * 0.15, width: context.height * 0.15),);
  }
}
