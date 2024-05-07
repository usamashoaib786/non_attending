import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';

class AppText {
  static Widget appText(String text,
      {TextAlign? textAlign,
      Color? textColor,
      double? fontSize,
      FontWeight? fontWeight,
      FontStyle? fontStyle,
      TextBaseline? textBaseline,
      TextOverflow? overflow,
      int? maxlines,
      bool? shadow,
      Color? bgcolor,
      Color? shadowColor,
      double? letterSpacing,
      bool underLine = false,
      bool fontFamily = false}) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxlines,
      style: TextStyle(
          shadows: [
            Shadow(
                color: shadow == true
                    ? shadowColor ?? AppTheme.whiteColor
                    : Colors.transparent,
                offset: const Offset(2, 2)),
          ],
          color: textColor ?? AppTheme.blackColor,
          fontSize: fontSize,
          fontFamily: fontFamily == false ? 'Roboto' : "Inter",
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          overflow: overflow,
          fontStyle: fontStyle,
          textBaseline: textBaseline,
          decorationColor: AppTheme.appColor,
          decoration: underLine == false
              ? TextDecoration.none
              : TextDecoration.underline),
    );
  }
}
