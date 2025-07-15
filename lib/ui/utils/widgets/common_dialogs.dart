import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:odigov3/framework/utils/extension/extension.dart';
import 'package:odigov3/framework/utils/extension/string_extension.dart';
import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:odigov3/ui/utils/theme/theme.dart';
import 'package:odigov3/ui/utils/widgets/common_button.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';
import 'package:odigov3/ui/utils/widgets/common_text.dart';

void showSuccessDialogue({
  required BuildContext context,
  required String animation,
  required String successMessage,
  String? successDescription,
  String? buttonText,
  bool? dismissble,
  bool? showButton,
  void Function()? onTap,
  double? height,
  double? width,
}) {
  showDialog(
    context: context,
    barrierDismissible: dismissble ?? false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        backgroundColor: AppColors.white,
        child: SizedBox(
          height: height ?? MediaQuery.sizeOf(context).height * 0.6,
          width: width ?? MediaQuery.sizeOf(context).width * 0.3,
          child: Consumer(builder: (context, ref, child) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
              
                    Lottie.asset(
                      animation,
                      height: MediaQuery.sizeOf(context).height * 0.25,
                      width: MediaQuery.sizeOf(context).width * 0.25,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                    CommonText(
                      title: successMessage,
                      textAlign: TextAlign.center,
                      style: TextStyles.bold.copyWith(
                        fontSize: 24,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (successDescription?.isNotEmpty ?? false)
                      CommonText(
                        title: successDescription!,
                        textAlign: TextAlign.center,
                        style: TextStyles.regular.copyWith(
                          fontSize: 16,
                          color: AppColors.black,
                        ),
                      ),
                    //const Spacer(),
                     SizedBox(height: MediaQuery.sizeOf(context).height * 0.024),
                    if (showButton ?? true)
                      CommonButton(
                        buttonText: buttonText,
                        borderRadius: BorderRadius.circular(12),
                        buttonTextStyle: TextStyles.regular.copyWith(
                          color: AppColors.white,
                        ),
                        onTap: onTap,
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      );
    },
  );
}
void commonImportDialog({
  required BuildContext context,
  required String title,
  String? description,
  String? fileName,
  bool? isSampleLoading,
  bool? isSaveLoading,
  bool? dismissble,
  void Function()? onTap,
  Future<bool?> Function()? onSaveTap,
  Future<bool?> Function()? onSampleTap,
  Future<String?> Function()? onBrowseTap,
  double? height,
  double? width,
}) {
  // Create ValueNotifiers for all mutable states
  final fileNameNotifier = ValueNotifier<String?>(fileName);
  final sampleLoadingNotifier = ValueNotifier<bool>(isSampleLoading ?? false);
  final saveLoadingNotifier = ValueNotifier<bool>(isSaveLoading ?? false);

  showDialog(
    context: context,
    barrierDismissible: dismissble ?? false,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        backgroundColor: AppColors.white,
        child: SizedBox(
          height: height ?? MediaQuery.sizeOf(context).height * 0.6,
          width: width ?? MediaQuery.sizeOf(context).width * 0.3,
          child: ValueListenableBuilder3<String?, bool, bool>(
            valueListenable1: fileNameNotifier,
            valueListenable2: sampleLoadingNotifier,
            valueListenable3: saveLoadingNotifier,
            builder: (context, currentFileName, currentSampleLoading, currentSaveLoading, _) {
              return Padding(
                padding: const EdgeInsets.all(36.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText(
                          title: title,
                          style: TextStyles.bold.copyWith(
                            fontSize: 24,
                            color: AppColors.black,
                          )
                      ),
                      const SizedBox(height: 16),
                      CommonText(
                          title: description??'',
                          style: TextStyles.regular.copyWith(
                            fontSize: 16,
                            color: AppColors.black,
                          )
                      ),
                      const SizedBox(height: 24),
                      DottedBorder(
                        options: RectDottedBorderOptions(
                          color: AppColors.clr2997FC,
                          dashPattern: [5, 3],
                          strokeWidth: 1,
                        ),
                        child: InkWell(
                          onTap: () async {
                            final selectedFile = await onBrowseTap?.call();
                            if (selectedFile != null) {
                              fileNameNotifier.value = selectedFile;
                            }
                          },
                          child: Container(
                            height: 164,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                    visible: (currentFileName??'').isEmpty,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        CommonSVG(strIcon: Assets.svgs.svgImportFile.path),
                                        SizedBox(height: 6),
                                        CommonText(
                                            title: LocaleKeys.keyBrowseFileMsg.localized,
                                            maxLines: 2,
                                            style: TextStyles.regular.copyWith(
                                              fontSize: 11,
                                              color: AppColors.black,
                                            )
                                        ),
                                        CommonText(
                                            title: LocaleKeys.keyOnlyXlsxSupported.localized,
                                            style: TextStyles.regular.copyWith(
                                              fontSize: 11,
                                              color: AppColors.black9F9F9F,
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: (currentFileName??'').isNotEmpty,
                                    child: Column(
                                      children: [
                                        CommonSVG(strIcon: Assets.svgs.svgSelectedFile.path),
                                        SizedBox(height: 6),
                                        CommonText(
                                            title: currentFileName??'',
                                            maxLines: 2,
                                            style: TextStyles.regular.copyWith(
                                              fontSize: 11,
                                              color: AppColors.black,
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Buttons row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CommonButton(
                              buttonText: LocaleKeys.keyCancel.localized,
                              borderRadius: BorderRadius.circular(8),
                              borderColor: AppColors.clr9E9E9E,
                              backgroundColor: AppColors.transparent,
                              buttonTextStyle: TextStyles.regular.copyWith(
                                color: AppColors.black,
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: CommonButton(
                              buttonText: LocaleKeys.keySave.localized,
                              borderRadius: BorderRadius.circular(8),
                              backgroundColor: AppColors.black,
                              isLoading: currentSaveLoading,
                              buttonTextStyle: TextStyles.regular.copyWith(
                                color: AppColors.white,
                              ),
                              onTap: () async {
                                saveLoadingNotifier.value = true;
                                try {
                                  final shouldContinue = await onSaveTap?.call();
                                  if (shouldContinue == false) {
                                    saveLoadingNotifier.value = false;
                                  }
                                } catch (e) {
                                  saveLoadingNotifier.value = false;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 24),
                      // Download sample
                      CommonButton(
                        buttonText: LocaleKeys.keyDownloadSample.localized,
                        borderRadius: BorderRadius.circular(8),
                        borderColor: AppColors.clr9E9E9E,
                        isLoading: currentSampleLoading,
                        loadingAnimationColor: AppColors.black,
                        backgroundColor: AppColors.clrD9D9D9,
                        buttonTextStyle: TextStyles.regular.copyWith(
                          color: AppColors.black,
                        ),
                        onTap: () async {
                          sampleLoadingNotifier.value = true;
                          try {
                            final shouldContinue = await onSampleTap?.call();
                            if (shouldContinue == false) {
                              sampleLoadingNotifier.value = false;
                            }
                          } catch (e) {
                            sampleLoadingNotifier.value = false;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

// Helper class for listening to three ValueNotifiers
class ValueListenableBuilder3<T1, T2, T3> extends StatelessWidget {
  final ValueListenable<T1> valueListenable1;
  final ValueListenable<T2> valueListenable2;
  final ValueListenable<T3> valueListenable3;
  final Widget Function(BuildContext, T1, T2, T3, Widget?) builder;

  const ValueListenableBuilder3({
    Key? key,
    required this.valueListenable1,
    required this.valueListenable2,
    required this.valueListenable3,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<T1>(
      valueListenable: valueListenable1,
      builder: (context, value1, child) {
        return ValueListenableBuilder<T2>(
          valueListenable: valueListenable2,
          builder: (context, value2, child) {
            return ValueListenableBuilder<T3>(
              valueListenable: valueListenable3,
              builder: (context, value3, child) {
                return builder(context, value1, value2, value3, child);
              },
            );
          },
        );
      },
    );
  }
}


void showErrorDialogue({
  required BuildContext context,
  required String animation,
  required String successMessage,
  String? successDescription,
  String? buttonText,
  bool? dismissble,
  bool? showButton,
  void Function()? onTap,
  double? height,
  double? width,
}) {
  showDialog(
    context: context,
    barrierDismissible: dismissble ?? false,
    builder: (context) {
      final media = MediaQuery.of(context).size;

      return Dialog(
        elevation: 0.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        backgroundColor: AppColors.white,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: height ?? media.height *0.6,
            maxWidth: width ?? media.width * 0.4,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      animation,
                      height: media.height * 0.2,
                      width: media.width * 0.2,
                      fit: BoxFit.contain,
                      repeat: true,
                    ),
                  //  const SizedBox(height: 20),
                    CommonText(
                      title: successMessage,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      style: TextStyles.bold.copyWith(
                        fontSize: 24,
                        color: AppColors.black,
                      ),
                    ).paddingSymmetric(horizontal: 15),
                 //   const SizedBox(height: 0),
                    if (showButton ?? true)
                      CommonButton(
                        buttonText: buttonText,
                        width: media.height * 0.25,
                        borderRadius: BorderRadius.circular(12),
                        buttonTextStyle: TextStyles.regular.copyWith(
                          color: AppColors.white,
                        ),
                        onTap: onTap,
                      ).paddingSymmetric(horizontal: 36, vertical: 15),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}



//
//  showErrorDialogue({
//   required BuildContext context,
//   required String animation,
//   required String successMessage,
//   String? successDescription,
//   String? buttonText,
//   bool? dismissble,
//   bool? showButton,
//   void Function()? onTap,
//   double? height,
//   double? width,
// }) {
//   showDialog(
//     context: context,
//     barrierDismissible: dismissble??false,
//     builder: (context) {
//       return Dialog(
//         elevation: 0.0,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
//         backgroundColor: AppColors.white,
//         child: SizedBox(
//           height: height ?? MediaQuery.sizeOf(context).height * 0.45,
//           width: width ?? MediaQuery.sizeOf(context).width * 0.3,
//           child: Consumer(
//               builder: (context, ref, child) {
//             return Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                // const Spacer(),
//                 Lottie.asset(
//                   animation,
//                   height: MediaQuery.sizeOf(context).height * 0.2,
//                   width: MediaQuery.sizeOf(context).width * 0.2,
//                   fit: BoxFit.contain,
//                   repeat: true,
//                 ),
//                 CommonText(
//                   title:successMessage,
//                   textAlign: TextAlign.center,
//                   maxLines: 2,
//                   style: TextStyles.bold.copyWith(
//                     fontSize: 24,
//                     color: AppColors.black,
//                   ),
//                 ).paddingSymmetric(horizontal: 15),
//                const Spacer(),
//                 Visibility(
//                   visible: showButton ?? true,
//                   child: CommonButton(
//                     buttonText: buttonText,
//                     width: MediaQuery.sizeOf(context).height * 0.25,
//                     borderRadius: BorderRadius.circular(12),
//                     buttonTextStyle: TextStyles.regular.copyWith(
//                       color: AppColors.white,
//                     ),
//                     // height: 50,
//                     // width: 200,
//                     onTap: onTap,
//                   ).paddingSymmetric(horizontal: 36,vertical: 25),
//                 ),
//                 // const Spacer(),
//               ],
//             );
//           }),
//         ),
//       );
//     },
//   );
// }