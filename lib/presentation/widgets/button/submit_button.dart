import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_strings.dart';
import '../../theme/app_theme.dart';

class SubmitButon extends StatelessWidget {
  const SubmitButon({Key? key, this.text, this.bgColor, this.textColor})
      : super(key: key);
  final String? text;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor ?? AppColors.black),
      child: Text(
        text ?? AppStrings.submit,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: textColor ?? Colors.white),
      ),
    );
  }
}
