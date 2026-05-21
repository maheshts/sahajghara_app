import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_theme.dart';

class CustomArrowButton extends StatelessWidget {
  const CustomArrowButton(
      {Key? key, required this.text, this.bgColor, this.textColor, this.onTap})
      : super(key: key);
  final String text;
  final Color? bgColor;
  final Color? textColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = AppTheme.run();
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.sp),
            color: bgColor ?? AppColors.primary),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: textColor ?? Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Icon(
              Icons.arrow_forward,
              color: AppColors.white,
              size: 20.sp,
            )
          ],
        ),
      ),
    );
  }
}
