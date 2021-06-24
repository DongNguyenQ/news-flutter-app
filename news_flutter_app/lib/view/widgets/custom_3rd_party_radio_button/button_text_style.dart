import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_flutter_app/view/shared/app_styles.dart';

class ButtonTextStyle {
  ///Selected color of Text
  final Color? selectedColor;

  ///Unselected color of Text
  final Color? unSelectedColor;
  final TextStyle? textStyle;

  const ButtonTextStyle({
    this.selectedColor = Colors.white,
    this.unSelectedColor = Colors.black,
    this.textStyle = const TextStyle(
        fontWeight: FontWeight.w400, fontSize: 14, fontFamily: 'bitter'),
  });
}
