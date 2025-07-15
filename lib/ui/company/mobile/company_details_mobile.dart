import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class CompanyDetailsMobile extends ConsumerStatefulWidget {
  const CompanyDetailsMobile({super.key});

  @override
  ConsumerState<CompanyDetailsMobile> createState() => _CompanyDetailsMobileState();
}

class _CompanyDetailsMobileState extends ConsumerState<CompanyDetailsMobile> {
  ///Build Override
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _bodyWidget());
  }

  ///Body Widget
  Widget _bodyWidget() {
    return Container(color: AppColors.red);
  }
}
