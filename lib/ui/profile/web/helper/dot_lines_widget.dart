import 'package:odigov3/ui/utils/theme/theme.dart';

///Common Edit Information Row Tile
class DotLinesWidget extends StatelessWidget {
  const DotLinesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        150 ~/ 1,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? AppColors.transparent : AppColors.clrE4E4E4,
            height: 1,
          ),
        ),
      ),
    );
  }
}
