import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key, required this.text, this.bgColor, this.textColor})
      : super(key: key);
  final String text;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.sp),
          border: Border.all(color: AppColors.btnColor),
          color: bgColor ?? AppColors.black),
      child: Text(
        text,
        style: theme.textTheme.bodyLarge?.copyWith(
            color: textColor ?? Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
