import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pinput/pinput.dart';
import 'package:sahajghara/helpers/utillls.dart';
import '../../controllers/auth_controller.dart';
import '../../helpers/custom_toast.dart';
import '../../helpers/navigation.dart';
import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../../presentation/theme/app_images.dart';
import '../../presentation/widgets/button/login_button.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import your dependencies like CustomToast, LoginButton, etc.

class OtpVerify extends ConsumerStatefulWidget {
  final int otp;
  final String token;
  final String phoneno;
  final bool isRegister;
  const OtpVerify(this.otp, this.token, this.phoneno, this.isRegister,{Key? key}) : super(key: key);

  @override
  ConsumerState<OtpVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends ConsumerState<OtpVerify> {
  var mpin = "";
  var formatPhone = "";

  int _secondsRemaining = 30;
  bool _enableResend = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    formatPhone = formatPhoneNumber(widget.phoneno);

    Future.delayed(const Duration(seconds: 2), () {
      CustomToast.displaySuccessToast(content: "Login Otp is ${widget.otp}");
    });

    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      _secondsRemaining = 30;
      _enableResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _enableResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _resendOtp() {
    final authRead = ref.read(authControllerProvider);
    authRead.resendOtp(context, widget.phoneno);
    CustomToast.displaySuccessToast(content: "OTP resent successfully");
    _startTimer(); // restart countdown
  }

  String formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.length != 10) return phoneNumber; // Ensure it's 10 digits
    return "+91 ${phoneNumber.substring(0, 5)}XXX${phoneNumber.substring(8)}";
  }

  @override
  Widget build(BuildContext context) {
    final authRead = ref.read(authControllerProvider);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20, color: Colors.black87, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(225, 225, 225, 1),),
        color: AppColors.txtBgColor,
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border:  Border.all(color: Color.fromRGBO(225, 225, 225, 1),),
      borderRadius: BorderRadius.circular(8),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xfff7f6fb),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 66,
                ),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.white, // background color
                    shape: BoxShape.rectangle, // circular shape
                    border: Border.all(
                      color: AppColors.primary, // border color
                      width: 0.5, // border thickness
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueGrey.withOpacity(0.3),
                        blurRadius: 4,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero, //
                    icon: Icon(Icons.arrow_back_ios_new, size:16,color: AppColors.primary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 66,
                ),
                Text("OTP Verification",
                    style: nunito16.copyWith(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Enter the verification code we just sent on your mobile  $formatPhone",
                    style: nunitoItalic15.copyWith(
                        color: AppColors.btnColor),
                    textAlign: TextAlign.start),
                const SizedBox(height: 30),
                Column(
                  children: [
                    Pinput(
                      length: 4,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      showCursor: true,
                      onCompleted: (pin) {
                        mpin = pin;
                      },
                      validator: (pin) {
                        if (pin == widget.otp.toString()) {
                          return null;
                        } else {
                          return 'Otp is incorrect';
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    InkWell(
                        onTap: () {
                          Utills.customPrint('mpin $mpin');
                          Utills.customPrint('otp ${widget.otp}');
                          if (mpin == widget.otp.toString()) {
                            CustomToast.displaySuccessToast(
                                content: "Otp is verified");
                            authRead.verifyOtp(context, widget.phoneno, mpin);
                          } else {
                            CustomToast.displayErrorToast(
                                content: "Invalid otp ");
                          }
                        },
                        child: LoginButton(labeltext: "Verify")),
                  ],
                ),
                const SizedBox(height: 18),

                /// Resend OTP Section
                _enableResend
                    ? Center(
                      child: TextButton(
                                        onPressed: _resendOtp,
                                        child:  Text(
                      "Didn’t received code? Resend",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                                        ),
                                      ),
                    )
                    : Center(
                      child: Text(
                                        "Resend in $_secondsRemaining sec",
                                        style: const TextStyle(
                        fontSize: 15, color: Colors.black54),
                                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
