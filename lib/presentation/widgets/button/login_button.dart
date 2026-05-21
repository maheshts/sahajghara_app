import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_strings.dart';
import '../../theme/app_theme.dart';

class LoginButton extends StatelessWidget {
  final String labeltext;
  const LoginButton({Key? key,required this.labeltext}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   // ThemeData theme = AppTheme.run();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),

      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.btnColor),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Text(
          labeltext,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
