import 'package:flutter/material.dart';
import 'package:non_attending/Utils/resources/app_theme.dart';

class CustomAppFormField extends StatefulWidget {
  final double? height;
  final double? width;
  final double? fontsize;
  final FontWeight? fontweight;
  final bool containerBorderCondition;
  final String texthint;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final bool obscureText;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final bool? prefixIcon;
  final bool? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorStyle;
  final String? prefixImge;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;
  final bool? readOnly;
  final int? lines;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const CustomAppFormField({
    super.key,
    this.containerBorderCondition = false,
    required this.texthint,
    required this.controller,
    this.prefixImge,
    this.validator,
    this.height,
    this.width,
    this.obscureText = false,
    this.onChanged,
    this.onTap,
    this.onTapOutside,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.cursorHeight,
    this.textAlign = TextAlign.start,
    this.prefix,
    this.suffix,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.keyboardType,
    this.suffixIconColor,
    this.fontweight,
    this.fontsize,
    this.hintStyle,
    this.errorText,
    this.style,
    this.errorStyle,
    this.errorBorder,
    this.focusedErrorBorder,
    this.cursorColor,
    this.readOnly,
    this.lines,
  });

  @override
  State<CustomAppFormField> createState() => _CustomAppFormFieldState();
}

class _CustomAppFormFieldState extends State<CustomAppFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height ?? 45,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff2042F3)),
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8)),
      child: TextField(
        focusNode: widget.focusNode,
        maxLines: widget.lines ?? 1,
        readOnly: widget.readOnly ?? false,
        controller: widget.controller,
        cursorColor: AppTheme.white,
        cursorHeight: 20,
        textAlign: TextAlign.center,
        cursorWidth: 2,
        keyboardType: widget.keyboardType ?? TextInputType.name,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon == true
                ? null
                : Container(
                    width: 50,
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(color: AppTheme.blackColor))),
                    child: Center(
                      child: Image.asset(
                        "${widget.prefixImge}",
                        height: 21,
                      ),
                    ),
                  ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(8),
            hintText: widget.texthint,
            hintStyle: TextStyle(
                color: AppTheme.blackColor,
                fontSize: 19,
                fontWeight: FontWeight.w200),
            isDense: true),
      ),
    );
  }
}

class CustomAppPasswordfield extends StatefulWidget {
  final double? height;
  final double? width;
  final bool containerBorderCondition;
  final String texthint;
  final String? errorText;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final TapRegionCallback? onTapOutside;
  final VoidCallback? onEditingComplete;
  final ValueChanged<String>? onFieldSubmitted;
  final double? cursorHeight;
  final TextAlign textAlign;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? prefixImge;
  final TextStyle? errorStyle;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;

  const CustomAppPasswordfield(
      {super.key,
      this.containerBorderCondition = false,
      required this.texthint,
      required this.controller,
      this.validator,
      this.height,
      this.width,
      this.onChanged,
      this.onTap,
      this.onTapOutside,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.cursorHeight,
      this.textAlign = TextAlign.start,
      this.prefix,
      this.suffix,
      this.prefixIcon,
      this.suffixIcon,
      this.prefixIconColor,
      this.suffixIconColor,
      this.errorText,
      this.hintStyle,
      this.cursorColor,
      this.style,
      this.errorStyle,
      this.errorBorder,
      this.focusedErrorBorder,
      this.prefixImge});

  @override
  State<CustomAppPasswordfield> createState() => _CustomAppPasswordfieldState();
}

class _CustomAppPasswordfieldState extends State<CustomAppPasswordfield> {
  bool _obscureText = true;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 45,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color: const Color(0xff2042F3)),
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          controller: widget.controller,
          cursorColor: AppTheme.white,
          cursorHeight: 20,
          textAlign: TextAlign.center,
          cursorWidth: 2,
          keyboardType: TextInputType.name,
          obscureText: _obscureText,
          decoration: InputDecoration(
              prefixIcon: Container(
                width: 50,
                decoration: BoxDecoration(
                    border:
                        Border(right: BorderSide(color: AppTheme.blackColor))),
                child: Center(
                  child: Image.asset(
                    "${widget.prefixImge}",
                    height: 21,
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 50,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(8),
              hintText: widget.texthint,
              hintStyle: TextStyle(
                  color: AppTheme.blackColor,
                  fontSize: 19,
                  fontWeight: FontWeight.w200),
              isDense: true,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.blue,
                  ),
                ),
              )),
        ));
  }
}
