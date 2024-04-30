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
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final String? errorStyle;
  final InputBorder? focusedErrorBorder;
  final InputBorder? errorBorder;

  const CustomAppFormField({
    super.key,
    this.containerBorderCondition = false,
    required this.texthint,
    required this.controller,
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
    this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
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
  });

  @override
  State<CustomAppFormField> createState() => _CustomAppFormFieldState();
}

class _CustomAppFormFieldState extends State<CustomAppFormField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xff464646)),
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(15)),
      child: TextField(
        controller: widget.controller,
        cursorColor: AppTheme.white,
        cursorHeight: 20,
        cursorWidth: 2,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
            prefixIcon: widget.prefixIcon,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 50,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(15),
            hintText: widget.texthint,
            hintStyle: const TextStyle(
                color: Color.fromARGB(255, 181, 169, 169),
                fontSize: 16,
                fontWeight: FontWeight.w400),
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
      this.focusedErrorBorder});

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
        height: 60,
        color: Colors.red,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onChanged: widget.onChanged,
          onTap: widget.onTap,
          onTapOutside: widget.onTapOutside,
          onFieldSubmitted: widget.onFieldSubmitted,
          cursorHeight: widget.cursorHeight,
          textAlign: widget.textAlign,
          key: widget.key,
          obscureText: _obscureText,
          validator: widget.validator,
          controller: widget.controller,
          cursorColor: widget.cursorColor,
          style: widget.style,
          decoration: InputDecoration(
              errorText: widget.errorText,
              errorStyle: widget.errorStyle,
              errorBorder: widget.errorBorder,
              focusedErrorBorder: widget.focusedErrorBorder,
              prefixIconColor: widget.prefixIconColor,
              suffixIconColor: widget.suffixIconColor,
              prefix: widget.prefix,
              suffix: widget.suffix,
              prefixIcon: widget.prefixIcon,
              contentPadding: const EdgeInsets.only(
                top: 20,
                left: 5,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.appColor)),
              disabledBorder:
                  const UnderlineInputBorder(borderSide: BorderSide.none),
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: AppTheme.appColor,
              )),
              border: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppTheme.appColor)),
              hintText: widget.texthint,
              hintStyle: widget.hintStyle,
              suffixIcon: InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Icon(
                    _obscureText
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppTheme.appColor,
                  ),
                ),
              )),
        ));
  }
}
