import 'package:odigov3/ui/utils/theme/app_colors.dart';
import 'package:odigov3/ui/utils/theme/assets.gen.dart';
import 'package:odigov3/ui/utils/theme/text_style.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:odigov3/ui/utils/widgets/common_svg.dart';

/// If Url Contains Svg image

class CacheImage extends StatelessWidget {
  final String imageURL;
  final double? height;
  final double? topLeftRadius;
  final double? topRightRadius;
  final double? bottomLeftRadius;
  final double? bottomRightRadius;
  final double? width;
  final bool? setPlaceHolder;
  final String? placeholderImage;
  final BoxFit? contentMode;
  final BoxShape? shape;
  final String? placeholderName;

  const CacheImage(
      {super.key,
      required this.imageURL,
      this.height,
      this.width,
      this.setPlaceHolder = true,
      this.placeholderImage,
      this.contentMode,
      this.bottomLeftRadius,
      this.bottomRightRadius,
      this.topLeftRadius,
      this.topRightRadius,
      this.shape,
      this.placeholderName});

  @override
  Widget build(BuildContext context) {
    return (imageURL == '')
        ? placeHolderWidget()
        : CachedNetworkImage(
            imageUrl: imageURL,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(topLeftRadius ?? 0.0),
                    topRight: Radius.circular(topRightRadius ?? 0.0),
                    bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
                    bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: contentMode ?? BoxFit.fill,
                  // colorFilter:ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                ),
              ),
            ),
            placeholder: (context, url) {
              return placeHolderWidget();
            },
            errorWidget: (context, url, error) => placeHolderWidget(),
          );
  }

  /// Place Holder Widget
  Widget placeHolderWidget() {
    return CommonSVG(
      height: height,
      width: width,
      strIcon: placeholderImage??Assets.svgs.svgImagePlaceholder.keyName,
    );
  }

  /*Widget placeHolderWidget() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(topLeftRadius ?? 0.0),
            topRight: Radius.circular(topRightRadius ?? 0.0),
            bottomRight: Radius.circular(bottomRightRadius ?? 0.0),
            bottomLeft: Radius.circular(bottomLeftRadius ?? 0.0)),
      ),
      child:


      Center(
        child: (placeholderName != '' && placeholderName != null)?
        ClipOval(

          child: Container(
            alignment: Alignment.center,
            color: AppColors.black,
            height: height,
            width: width,
            child: Text(
              placeholderName?[0].toUpperCase() ?? appName[0].toUpperCase() ,
              style: TextStyles.semiBold.copyWith(fontSize: 25.sp,color: AppColors.white),
            ),
          ),
        ) :
        placeholderImage == ''
            ? Text(
          appName[0],
          style: TextStyles.semiBold.copyWith(fontSize: 25.sp),
        )
            : SizedBox(
          height: height,
          width: width,
          child: CommonSVG(
            strIcon: placeholderImage ?? Assets.svgs.svgPlaceholder.keyName,
            boxFit: BoxFit.fill,
          ),
        ),
      ),
    );
  }*/
}
