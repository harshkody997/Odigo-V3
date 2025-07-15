// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:odigov3/framework/controller/auth/login_controller.dart';
// import 'package:odigov3/framework/utils/extension/string_extension.dart';
// import 'package:odigov3/ui/utils/theme/assets.gen.dart';
// import 'package:odigov3/ui/utils/theme/theme.dart';
// import 'package:odigov3/ui/utils/widgets/common_button.dart';
// import 'package:odigov3/ui/utils/widgets/common_svg.dart';
// import 'package:odigov3/ui/utils/widgets/common_text.dart';
//
// //class CommonImportFile extends ConsumerStatefulWidget {
//
//
//   class CommonImportFile extends ConsumerStatefulWidget {
//
//     final  BuildContext context;
//     final  String title;
//     final  String? description;
//     final  String? fileName;
//     final  bool? isSampleLoading;
//     final  bool? isSaveLoading;
//     final  bool? dismissble;
//     final  void Function()? onTap;
//     final  void Function()? onSaveTap;
//     final  void Function()? onSampleTap;
//     final  void Function()? onBrowseTap;
//     final double? height;
//     final double? width;
//
//     const CommonImportFile({
//       Key? key,
//       this.description, this.fileName, this.isSampleLoading, this.isSaveLoading, this.dismissble, this.onTap, this.onSaveTap, this.onSampleTap, this.onBrowseTap, this.height, this.width, required this.context, required this.title
//
//     }) : super(key: key);
//   @override
//   ConsumerState<CommonImportFile> createState() => _CommonImportFileState();
//   }
//
//
//   class _CommonImportFileState extends ConsumerState<CommonImportFile>{
//
//
// @override
//   void initState() {
//   final loginWatch = ref.read(loginController);
//
//   super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(36.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: [
//           CommonText(
//               title: widget.title,
//               style:
//               TextStyles.bold.copyWith(
//                 fontSize: 24,
//                 color: AppColors.black,
//               )
//           ),
//           const SizedBox(height: 16),
//           CommonText(
//               title: widget.description??'',
//               style:  TextStyles.regular.copyWith(
//                 fontSize: 16,
//                 color: AppColors.black,
//               )
//           ),
//           const SizedBox(height: 24),
//           DottedBorder(
//             options: RectDottedBorderOptions(
//               color: AppColors.clr2997FC,
//               dashPattern: [5, 3],
//               strokeWidth: 1,
//             ),
//             child: InkWell(
//               onTap: widget.onBrowseTap,
//               child: Container(
//                 height: 164,
//                 decoration: BoxDecoration(
//
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child:  Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//
//                       Visibility(
//                         visible: (widget.fileName??'').isEmpty,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CommonSVG(  strIcon: Assets.svgs.svgImportFile.path),
//                             SizedBox(height: 6),
//                             CommonText(
//                                 title: LocaleKeys.keyBrowseFileMsg.localized,
//                                 maxLines: 2,
//                                 style:  TextStyles.regular.copyWith(
//                                   fontSize: 11,
//                                   color: AppColors.black,
//                                 )
//                             ),
//                             CommonText(
//                                 title: LocaleKeys.keyOnlyXlsxSupported.localized,
//                                 style:  TextStyles.regular.copyWith(
//                                   fontSize: 11,
//                                   color: AppColors.black9F9F9F,
//                                 )
//                             ),
//                           ],
//                         ),
//                       ),
//                       Visibility(
//                         visible: (widget.fileName??'').isNotEmpty,
//                         child: Column(
//                           children: [
//                             // Align(child: CommonSVG(  strIcon: Assets.svgs.svgCloseImport.path),alignment: Alignment.topRight),
//
//                             CommonSVG(  strIcon: Assets.svgs.svgSelectedFile.path),
//                             SizedBox(height: 6),
//                             CommonText(
//                                 title:widget.fileName??'',
//                                 maxLines: 2,
//                                 style:  TextStyles.regular.copyWith(
//                                   fontSize: 11,
//                                   color: AppColors.black,
//                                 )
//                             ),
//
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           // Buttons row
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 child: CommonButton(
//                   buttonText: LocaleKeys.keyCancel.localized,
//                   borderRadius: BorderRadius.circular(8),
//                   borderColor: AppColors.clr9E9E9E,
//
//                   backgroundColor: AppColors.transparent,
//                   buttonTextStyle: TextStyles.regular.copyWith(
//                     color: AppColors.black,
//                   ),
//                   onTap: ()
//                   {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ),
//               const SizedBox(width: 24),
//               Expanded(
//                 child: CommonButton(
//                   buttonText: LocaleKeys.keySave.localized,
//                   borderRadius: BorderRadius.circular(8),
//                   backgroundColor: AppColors.black,
//                   isLoading: widget.isSaveLoading??false,
//                   buttonTextStyle: TextStyles.regular.copyWith(
//                     color: AppColors.white,
//                   ),
//                   onTap: widget.onSaveTap,
//                 ),
//               )
//             ],
//           ),
//           const SizedBox(height: 24),
//           // Download sample
//           CommonButton(
//             buttonText: LocaleKeys.keyDownloadSample.localized,
//             borderRadius: BorderRadius.circular(8),
//             borderColor: AppColors.clr9E9E9E,
//             isLoading: widget.isSampleLoading,
//             backgroundColor: AppColors.clrD9D9D9,
//             buttonTextStyle: TextStyles.regular.copyWith(
//               color: AppColors.black,
//             ),
//             onTap: widget.onSampleTap,
//           ),
//         ],
//       ),
//     );
//   }
// }
//
