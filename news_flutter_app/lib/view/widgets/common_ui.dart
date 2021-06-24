import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:news_flutter_app/view/shared/app_colors.dart';
import 'package:news_flutter_app/view/shared/app_styles.dart';
import 'package:shimmer/shimmer.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final int? maxLines;
  final TextAlign? align;
  final double? size;
  final TextOverflow? overflow;
  // const AppText({Key? key, required this.text, required this.style})
  //     : super(key: key);
  const AppText.h1(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = h1Style;
  const AppText.h2(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = h2Style;
  const AppText.h3(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = h3Style;
  const AppText.headline(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = headlineStyle;
  const AppText.subheading(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = subheadingStyle;
  AppText.caption(this.text,
      {Color color = kcLightGreyColor, this.maxLines, this.align, this.size, this.overflow})
      : style = captionStyle.copyWith(color: color);

  AppText.body(this.text,
      {Color color = kcMediumGreyColor, this.maxLines, this.align, this.size, this.overflow})
      : style = bodyStyle.copyWith(color: color, fontSize: size);

  AppText.h2Bitter(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = h2StyleBitter;
  AppText.headlineBitter(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = headlineStyleBitter;
  AppText.subheadingBitter(this.text, {this.maxLines, this.align, this.size, this.overflow})
      : style = subheadingStyleBitter;
  AppText.captionBitter(this.text,
      {Color color = kcMediumGreyColor, this.maxLines, this.align, this.size, this.overflow})
      : style = captionStyleBitter.copyWith(color: color).merge(TextStyle(wordSpacing: 2));

  AppText.bodyBitter(this.text,
      {Color color = kcMediumGreyColor, this.maxLines, this.align, this.size, this.overflow})
      : style = bodyStyleBitter.copyWith(color: color, fontSize: size).merge(TextStyle(wordSpacing: 2, height: 1.5));

  @override
  Widget build(BuildContext context) {
    return Text(text, overflow: overflow,
        style: style, maxLines: maxLines ?? null, textAlign: align ?? null);
  }
}

class CustomCachedNetworkImage extends StatelessWidget {
  final String url;
  final BoxFit? fit;
  final double? radius;
  const CustomCachedNetworkImage({Key? key, required this.url, this.fit, this.radius = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      fit: fit,
      imageUrl: url,
      imageBuilder: (context, image) {
        return Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius!),
              color: Colors.transparent,
              image: DecorationImage(
                  image: image, fit: BoxFit.cover)
          ),

        );
      },
      placeholder: (context, url) => Shimmer.fromColors(
          child: Container(
            height: double.infinity,
            width: double.infinity,
          ),
          baseColor: Colors.red,
          highlightColor: Colors.yellow),
      errorWidget: (context, url, error) => Container(
        child: AppText.subheading('Not available'),
      ),
    );
  }
}

class TextInputView extends StatelessWidget {
  final String? label;
  final int? maxLines;
  final bool? autoFocus;
  final bool? isPassword;
  final String? placeHolder;
  final bool? enabled;
  final Function? validator;
  final TextEditingController? textController;
  final List<TextInputFormatter>? formatters;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputType? keyboardType;
  final EdgeInsetsGeometry? titlePadding;
  const TextInputView(
      {Key? key,
      this.contentPadding,
      this.keyboardType,
      this.isPassword = false,
      this.titlePadding = EdgeInsets.zero,
      this.label,
      this.maxLines,
      this.autoFocus = false,
      this.placeHolder,
      this.enabled = true,
      this.validator,
      this.textController,
      this.formatters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label != null
              ? Padding(
                  // padding: EdgeInsets.only(left: 10),
                  padding: titlePadding!,
                  child: AppText.subheading(label!),
                )
              : SizedBox(),
          Container(
            padding: contentPadding ?? EdgeInsets.zero,
            margin: EdgeInsets.only(top: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey, width: 0.5),
                borderRadius: BorderRadius.circular(20)),
            child: TextFormField(
              obscureText: isPassword!,
              keyboardType: keyboardType ?? null,
              decoration: InputDecoration(
                focusColor: Colors.black,
                border: InputBorder.none,
                hintText: placeHolder,
                fillColor: Colors.white,
                filled: true,
                hoverColor: Colors.transparent,
              ),
              inputFormatters: formatters ?? null,
              maxLines: maxLines != null ? maxLines : 1,
              controller: textController,
              autofocus: autoFocus!,
              enabled: enabled,
            ),
          )
        ],
      ),
    );
  }
}


class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5, color: Colors.black),
      ),
    );
  }
}
