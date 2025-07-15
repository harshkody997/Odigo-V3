import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class EditCompanyDetailsMobile extends ConsumerStatefulWidget {
  const EditCompanyDetailsMobile({super.key});

  @override
  ConsumerState<EditCompanyDetailsMobile> createState() => _CompanyDetailsMobileState();
}

class _CompanyDetailsMobileState extends ConsumerState<EditCompanyDetailsMobile> {
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
