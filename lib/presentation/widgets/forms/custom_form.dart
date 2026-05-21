import 'package:flutter/material.dart';

// import 'package:ecommerce/src/theme/theme.dart';

import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomForm extends StatefulWidget {
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
  const CustomForm(
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
  State<CustomForm> createState() => _CustomFormState();
}

class _CustomFormState extends State<CustomForm> {
  // _CustomFormFieldState({this.onSaved, this.inputTextFontWeight, this.onTap, this.prefixText, this.prefixIcon, this.textCapitalization, this.maxLines, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.maxlength, this.focusNode, this.onFieldSubmitted, this.obscuringCharacter, this.key, this.suffix});
  @override
  Widget build(BuildContext context) {
    // final ThemeData theme = AppTheme.customTheme();
    return Container(
        margin: EdgeInsets.only(top: 8.0, left: 0.w, right: 0.w, bottom: 8),
        height: widget.height ?? 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: widget.borderColor ?? Colors.transparent),
            color: widget.bgColor ?? Colors.white,
            borderRadius: BorderRadius.circular(2)),
        child: TextFormField(
          // key: widget.key,
          cursorColor: Colors.black,
          controller: widget.controller,
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
              contentPadding: widget.contentPadding,
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
      labelText: labelText,
      contentPadding: contentPadding ?? EdgeInsets.only(left: 1.w),
      fillColor: Colors.blueGrey.shade400,
      border: OutlineInputBorder(
          borderSide: BorderSide.none,
          // BorderSide(width: 2, color: Colors.blueGrey),
          borderRadius: BorderRadius.circular(2)),
    );
  }

  // border() => OutlineInputBorder(
  //     borderSide: BorderSide(color: AppTheme().primaryTextColor()),
  //     borderRadius: BorderRadius.circular(10.0));
}
