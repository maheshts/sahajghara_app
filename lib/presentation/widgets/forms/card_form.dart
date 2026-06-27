import 'package:flutter/material.dart';

// import 'package:ecommerce/src/theme/theme.dart';

import 'package:flutter/services.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';




class CardForm extends StatefulWidget {
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
  const CardForm(
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
  State<CardForm> createState() => _CardFormState();
}

class _CardFormState extends State<CardForm> {
  // _CardFormFieldState({this.onSaved, this.inputTextFontWeight, this.onTap, this.prefixText, this.prefixIcon, this.textCapitalization, this.maxLines, this.controller, this.height, this.readOnly, this.suffixIcon, this.initialText, this.inputFormatters, this.onChanged, this.hintText, this.keyboardType, this.autofocus, this.obscureText, this.maxlength, this.focusNode, this.onFieldSubmitted, this.obscuringCharacter, this.key, this.suffix});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 4.0, left: 0, right: 0, bottom: 2),
        height: widget.height ?? 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            // boxShadow: const [
            //   BoxShadow(
            //     offset: Offset(2, 2),
            //     blurRadius: 12,
            //    // color: Color.fromRGBO(0, 0, 0, 0.16),
            //   )
            //
            //   // BoxShadow(
            //   //   color: Colors.grey.withOpacity(0.5),
            //   //   spreadRadius: 1,
            //   //   blurRadius: 2,
            //   //   offset: const Offset(0.2, 0.8),
            //   // ),
            // ],
            //border: Border.all(color: widget.borderColor ?? Colors.transparent),
           // color: widget.bgColor ?? AppColors.txtBgColor,
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8)),
        child: TextFormField(
          // key: widget.key,
          cursorColor: Colors.grey,
          controller: widget.controller,

          style: nunito16,
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
          enabled: true,

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
    ThemeData theme = Theme.of(context);
    return InputDecoration(
      alignLabelWithHint: true,
      suffixIcon: suffixIcon,
      hintText: hintText,
      labelText: labelText,
      labelStyle: nunitoItalic14.copyWith(color: Colors.black54),
      contentPadding: contentPadding ??
          const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      filled: true,
      fillColor: const Color.fromRGBO(249, 249, 249, 1),
      focusedBorder:OutlineInputBorder(
        //borderSide: BorderSide.none,
          borderSide: const BorderSide(
            color: Color.fromRGBO(225, 225, 225, 1), // border color
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8)),
      // Normal border
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Color.fromRGBO(225, 225, 225, 1), // border color
          width: 0.5,
        ),
      ),
      //hintStyle: theme.textTheme.bodyLarge!.copyWith(color: Colors.grey),
      hintStyle: nunito14.copyWith(color: Colors.blueGrey),

      //hintStyle: TextStyle(color: Colors.grey),
      floatingLabelStyle: TextStyle(color: AppColors.deepBlue),
      // style: textFieldInputStyle(context, widget.inputTextFontWeight),,
      border: OutlineInputBorder(
          //borderSide: BorderSide.none,
          borderSide: const BorderSide(
            color: Color.fromRGBO(225, 225, 225, 1), // border color
            width: 0.5,
          ),
          borderRadius: BorderRadius.circular(8)),
    );
  }

  // border() => OutlineInputBorder(
  //     borderSide: BorderSide(color: AppTheme().primaryTextColor()),
  //     borderRadius: BorderRadius.circular(10.0));
}
