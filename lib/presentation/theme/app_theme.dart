import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../helpers/hexcolor.dart';
import 'app_colors.dart';

class AppTheme {
  // //fontFamily
  static const poppinsRegular = "Roboto-regular";
  static const poppinsMedium = "Roboto-medium";
  static const poppinsBold = "Roboto-bold";

  static primaryFont(TextStyle? style) =>
      GoogleFonts.poppins(textStyle: style!);

  // execute
  static ThemeData run() => 1 == 1 ? lightTheme : lightTheme;

  // light theme..........

  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: HexColor("#E5E5E5"),
    brightness: Brightness.light,
    primaryColor: Colors.white,
    cardColor: Colors.white,
    unselectedWidgetColor: Colors.grey,

    bottomSheetTheme:
        const BottomSheetThemeData(backgroundColor: AppColors.white),
    iconTheme: IconThemeData(
      color: AppColors.logoYellow,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 1,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.orange,
        selectedIconTheme: IconThemeData(color: Colors.amber)),

    // theme for text

    // textTheme: TextTheme(
    //   bodySmall: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_12.sp,
    //           color: Colors.black,
    //           //fontFamily: poppinsRegular,
    //           fontWeight: FontWeight.w400)),
    //   bodyLarge: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_14.sp,
    //           color: Colors.grey,
    //           //fontFamily: poppinsMedium,
    //           fontWeight: FontWeight.w400)),
    //   bodyMedium: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_16.sp,
    //           color: Colors.black,
    //           //fontFamily: poppinsMedium,
    //           fontWeight: FontWeight.w500)),
    //   titleMedium: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_18.sp,
    //           //fontFamily: poppinsMedium,
    //           color: Colors.black,
    //           fontWeight: FontWeight.w500)),
    //   titleSmall: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_20.sp,
    //           //fontFamily: poppinsMedium,
    //           color: Colors.black,
    //           fontWeight: FontWeight.w600)),
    //   displayLarge: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_22.sp,
    //           //fontFamily: poppinsMedium,
    //           color: Colors.black,
    //           fontWeight: FontWeight.w600)),
    //   displayMedium: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_24.sp,
    //           //fontFamily: poppinsBold,
    //           color: Colors.black,
    //           fontWeight: FontWeight.w700)),
    //   displaySmall: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_25.sp,
    //           color: Colors.grey,
    //           fontWeight: FontWeight.w700)),
    //   headlineMedium: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_28.sp,
    //           //fontFamily: poppinsBold,
    //           color: Colors.black,
    //           fontWeight: FontWeight.w700)),
    //   headlineSmall: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_30.sp,
    //           color: Colors.black,
    //           //fontFamily: poppinsBold,
    //           fontWeight: FontWeight.w700)),
    //   titleLarge: GoogleFonts.poppins(
    //       textStyle: TextStyle(
    //           fontSize: Sizes.dimen_32.sp,
    //           color: Colors.grey,
    //           //fontFamily: poppinsBold,
    //           fontWeight: FontWeight.w700)),
    // ),
    // colorScheme: ColorScheme(background: Colors.grey.shade200), bottomAppBarTheme: const BottomAppBarTheme(color: Colors.white)
  );
}
