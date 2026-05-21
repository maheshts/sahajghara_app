import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../theme/app_colors.dart';

class SpinKits {
  static circle(context) {
    return SpinKitCircle(itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? AppColors.bgColor : Colors.green,
        ),
      );
    });
  }

  static fadeCircle(context) {
    return SpinKitFadingCircle(itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index.isEven ? AppColors.primary : AppColors.primary),
      );
    });
  }

  static spinCircle() {
    return SpinKitSpinningCircle(
      color: AppColors.bgColor,
      size: 50.0,
    );
  }

  static spinLines(context) {
    return SpinKitSpinningLines(
      color: AppColors.primary,
      itemCount: 5,
      lineWidth: 5.sp,
      size: 80.sp,
    );
  }

  static wave(context) {
    return SpinKitWave(itemBuilder: (BuildContext context, int index) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: index.isEven ? Colors.blue : AppColors.primary,
        ),
      );
    });
  }

  static dots(context) {
    return SpinKitThreeBounce(
      color: AppColors.primary,
      size: 30.sp,
    );
  }
}
