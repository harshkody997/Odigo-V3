import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';

class ProfileMobile extends ConsumerStatefulWidget {
  const ProfileMobile({super.key});

  @override
  ConsumerState<ProfileMobile> createState() => _ProfileMobileState();
}

class _ProfileMobileState extends ConsumerState<ProfileMobile> {
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
