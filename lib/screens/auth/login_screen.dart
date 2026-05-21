import 'package:animate_do/animate_do.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:sahajghara/helpers/hexcolor.dart';
import 'package:sahajghara/presentation/theme/app_colors.dart';



import '../../controllers/auth_controller.dart';
import '../../helpers/custom_toast.dart';
import '../../helpers/navigation.dart';
import '../../helpers/utillls.dart';
import '../../helpers/validators.dart';
import '../../presentation/theme/app_constants.dart';
import '../../presentation/theme/app_images.dart';
import '../../presentation/widgets/button/login_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TextEditingController phoneController = TextEditingController();

  bool _isSubmitted = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    phoneController.addListener(() {
      if (phoneController.text.length == 10 && !_isSubmitted) {
        _isSubmitted = true;
        FocusScope.of(context).unfocus(); // hides keyboard
        _handleSubmit(ref.read(authControllerProvider), context);
      } else if (phoneController.text.length < 10) {
        _isSubmitted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authRead = ref.read(authControllerProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 168,
              ),

                Center(
                  child: Image.asset(
                    AppImages.logo_blue,
                    // 'assets/images/SahajLogoWhite1.png',
                    //C:\DEV\flutter_ws\sahajaghara\assets\images\SahajLogoWhite.svg
                    width: 100,
                    height: 100,
                   // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                   // placeholderBuilder: (context) => const Icon(Icons.error),
                  ),
                ),

              SizedBox(
                height: 24,
              ),


              Text(
                'Login',
                textAlign: TextAlign.start,
                style: GoogleFonts.anuphan(
                  fontSize: 28,

                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 6,
              ),

              Text(
                'Find reliable experts for every build',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: HexColor("#717171")
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Column(
                children: <Widget>[
                  FadeInUp(
                      duration: Duration(milliseconds: 1800),
                      child: Container(
                        //padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.phone,
                                maxLength: 10,

                                controller: phoneController,
                                textInputAction: TextInputAction.done,
                                onSubmitted: (value) =>
                                    _handleSubmit(authRead, context),
                                style: nunitoItalic15,

                                decoration: InputDecoration(
                                  fillColor: AppColors.txtBgColor,
                                  hintText: "Enter mobile number", // Add hint text
                                  hintStyle: TextStyle(
                                    color: Colors.grey, // Hint text color
                                    fontSize: 15,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: AppColors.btnColor),
                                      borderRadius: BorderRadius.circular(
                                          10)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black12),
                                      borderRadius: BorderRadius.circular(
                                          10)),
                                  prefix: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      '(+91)',
                                      style: nunitoItalic14,
                                    ),
                                  ),

                                  // suffixIcon: phoneController.length == 10?Icon(
                                  //   Icons.check_circle,
                                  //   color: Colors.green,
                                  //   size: 32,
                                  // ):Container(),
                                ),
                                inputFormatters: [
                                  // ✅ restrict only digits
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                              ),
                              //const SizedBox(height: 12),
                              GestureDetector(
                                  onTap: () {
                                    _handleSubmit(authRead, context);
                                  },
                                  child: LoginButton(
                                    labeltext: "Signin",
                                  )

                              ),
                              //
                              // InkWell(
                              //     onTap: (){
                              //      Navigation.sideNavigation(context, SignUpScreen(mobile: phoneController.text.toString()));
                              //     },
                              //     child: Text("New Here? Signup",style: nunitoItalic14,)),
                            ]),



                      )),
                  // SizedBox(height: 30),

                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit(AuthController authRead, BuildContext context) {
   // Navigation.sideNavigation(context, OtpVerify("","",""));

    if (Validators.isValidMobile(
        phoneController.text)) {
      authRead.setUserName(phoneController.text);
      authRead.generateOtp(
          context, phoneController.text);
    } else {
      CustomToast.displayErrorToast(
          content: "Enter valid mobile number.");
    }
  }
}