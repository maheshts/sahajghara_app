import 'package:flutter/material.dart';

// import 'package:ecommerce/src/theme/theme.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_constants.dart';
import '../../theme/app_theme.dart';

class OutlineForm extends StatefulWidget {
  // Hint text for text field
  final String? hintText;
  final String? labelText;

  // Callback functions
  final Function(String)? onChanged;
  final Function(String)? onSaved;
  final Function(String)? onFieldSubmitted;

  // Other properties
  final TextInputType? keyboardType;
  final double? height;
  final String? prefixText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Icon? prefixIcon;
  final FontWeight? inputTextFontWeight;
  final Widget? suffixIcon;
  final Widget? suffix;
  final Function()? onTap;
  final String? initialText;
  final bool? readOnly;
  final int? maxLines;
  final int? maxlength;
  final TextCapitalization? textCapitalization;
  final bool? autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final String? obscuringCharacter;
  final bool? obscureText;
  final Color? bgColor;
  final Color? borderColor;
  final EdgeInsetsGeometry? contentPadding;

  // Constructor of text field
  const OutlineForm(
      {Key? key,
      this.labelText,
      this.obscureText,
      this.onSaved,
      this.inputTextFontWeight,
      this.onTap,
      this.prefixText,
      this.prefixIcon,
      this.textCapitalization,
      this.maxLines,
      this.controller,
      this.height,
      this.readOnly,
      this.suffixIcon,
      this.initialText,
      this.inputFormatters,
      this.onChanged,
      this.hintText,
      this.keyboardType,
      this.autofocus,
      this.maxlength,
      this.focusNode,
      this.onFieldSubmitted,
      this.obscuringCharacter,
      this.suffix,
      this.bgColor,
      this.borderColor,
      this.contentPadding})
      : super(key: key);

  @override
  State<OutlineForm> createState() => _OutlineFormState();
}

class _OutlineFormState extends State<OutlineForm> {
  // _OutlineFormFieldState({this.onSaved, this.inputTextFontWeight, this.onTap, this.prefixText, this.prefixIcon, this.textCapitalization, this.maxLines, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.maxlength, this.focusNode, this.onFieldSubmitted, this.obscuringCharacter, this.key, this.suffix});
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = AppTheme.run();
    return Container(
        margin: EdgeInsets.only(top: 8.0, left: 0.w, right: 0.w, bottom: 8),
        height: widget.height ?? 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(
                color: widget.borderColor ?? Colors.transparent, width: 0.7),
            color: widget.bgColor ?? Colors.white,
            borderRadius: BorderRadius.circular(10.sp)),
        child: TextFormField(
          // key: widget.key,
          cursorColor: Colors.black54,
          controller: widget.controller,
          style: nunito14.copyWith(color: Colors.black87),
          // style: textFieldInputStyle(context, widget.inputTextFontWeight),
          keyboardType: widget.keyboardType ?? TextInputType.text,
          textCapitalization:
              widget.textCapitalization ?? TextCapitalization.none,
          obscureText: widget.obscureText ?? false,
          autofocus: widget.autofocus ?? false,
          readOnly: widget.readOnly ?? false,
          maxLines: widget.maxLines ?? 1,
          initialValue: widget.initialText,
          maxLength: widget.maxlength,
          onTap: widget.onTap,
          focusNode: widget.focusNode,
          obscuringCharacter: '*',
          inputFormatters: widget.inputFormatters ?? [],
          decoration: fieldDecoration(context,
              contentPadding:
                  widget.contentPadding ?? EdgeInsets.only(left: 10.w),
              hintText: widget.hintText,


              labelText: widget.labelText,
              suffixIcon: widget.suffixIcon),

          onFieldSubmitted: widget.onFieldSubmitted != null
              ? (val) => widget.onFieldSubmitted!(val)
              : null,
          onChanged: widget.onChanged != null
              ? (value) => widget.onChanged!(value)
              : null,
          onSaved: (value) => widget.onSaved!(value!),
        ));
  }

  InputDecoration fieldDecoration(context,
      {String? hintText,
      String? labelText,
      Widget? suffixIcon,
      EdgeInsetsGeometry? contentPadding}) {
    // ThemeData theme = Theme.of(context);
    return InputDecoration(
      alignLabelWithHint: true,
      suffixIcon: suffixIcon,
      hintText: hintText,
      hintStyle: nunito14.copyWith(color: Colors.grey),
      labelText: labelText,
      labelStyle: nunitoItalic15.copyWith(color: Colors.black),
      contentPadding: contentPadding ?? EdgeInsets.only(left: 1.w),
      fillColor: Colors.blueGrey.shade400,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          // BorderSide(width: 2, color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(10.sp)),
    );
  }

  // border() => OutlineInputBorder(
  //     borderSide: BorderSide(color: AppTheme().primaryTextColor()),
  //     borderRadius: BorderRadius.circular(10.0));
}
