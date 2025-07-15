

import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';


class Error404Mobile extends StatelessWidget {
  const Error404Mobile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Text('404 Not Found'),
      ),
    );
  }
}

