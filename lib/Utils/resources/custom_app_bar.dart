import 'package:flutter/material.dart';

class CustomAppBar {
  static PreferredSizeWidget appBar(
      {String titleText = "",
      Color? shadowColor,
      Color? backgroundColor,
      TextStyle? titleTextStyle,
      double? leadingWidth,
      double? titleSpacing,
      double? elevation,
      Widget? leading,
      List<Widget>? actions,
      PreferredSizeWidget? bottom,
      ShapeBorder? shape,
      bool? centerTitle}) {
    return AppBar(
      toolbarHeight: 50,
      title: Text(titleText),
      shadowColor: shadowColor,
      leading: leading,
      leadingWidth: leadingWidth,
      titleTextStyle: titleTextStyle,
      titleSpacing: titleSpacing,
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      centerTitle: centerTitle,
    );
  }
}
