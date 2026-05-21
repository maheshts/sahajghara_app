import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/screens/signup_success.dart';



import '../../controllers/auth_controller.dart';
import '../../helpers/custom_toast.dart';
import '../../helpers/utillls.dart';
import '../../helpers/validators.dart';

import '../../presentation/theme/app_colors.dart';
import '../../presentation/theme/app_constants.dart';
import '../../presentation/theme/app_images.dart';
import '../../presentation/theme/app_theme.dart';
import '../../presentation/widgets/button/custom_arrow_button.dart';
import '../../presentation/widgets/button/login_button.dart';
import '../../presentation/widgets/forms/card_form.dart';
import '../location.dart';


class SignUpScreen extends ConsumerStatefulWidget {
  final String mobile;
  const SignUpScreen({required this.mobile,super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController refCodeController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    phoneController.text = widget.mobile;
    init();


  }
  init() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //// executes after build
      //await ref.read(stateCityControllerProvider).getStateData(context);
    });
    //final code = await ReferralService.getReferralCode();
   // print("Use this referral code for signup: $code");
    //refCodeController.text = code!;

    // final response = await FlutterInstallReferrer.referrer;

  }


  @override
  Widget build(BuildContext context) {

    //ThemeData theme = AppTheme.run();
   final authRead = ref.read(authControllerProvider);
   // final authWatch = ref.watch(stateCityControllerProvider);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xfff7f6fb),
      body:
      SingleChildScrollView(
        child:  Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
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
                    width: 1, // border thickness
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
                height: 64,
              ),

              // Center(child: CircleAvatar(
              //     radius: 80,
              //     backgroundColor: Colors.black,
              //     child: Image.asset(AppImages.splash,height: 100,width:Utills.width(context) ,fit: BoxFit.cover,))),
              // SizedBox(height: 10,),

              Text("Create Account",textAlign: TextAlign.start,
                style: nunito16.copyWith(
                  // color: getColor(),
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,fontSize: 24),),
              SizedBox(height: 6,),
              Text("Find reliable experts for every build",style: nunitoItalic14,),
              SizedBox(height: 26,),
              SingleChildScrollView(
                child: Column(
                  children: [
                    CardForm(
                      hintText: "Name",
                      labelText: "Name*",
                      controller: nameController,
                      keyboardType: TextInputType.text,
                      bgColor: AppColors.txtBgColor,
                    ),
                    CardForm(
                      hintText: "Email*",
                      labelText: "Email ID",
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    // CardForm(
                    //   hintText: "Enter referral code*",
                    //   labelText: "Refer Code",
                    //   controller: refCodeController,
                    //   keyboardType: TextInputType.text,
                    // ),
                    CardForm(
                        hintText: "Phone Number",
                        labelText: "Phone Number*",
                        controller: phoneController,
                        prefixText: "+91",
                        maxlength: 10,
                        readOnly: true,
                        keyboardType: TextInputType.phone,
                        suffixIcon: Icon(
                          Icons.check_circle,
                          color: Colors.green,
                          size: 28,
                        )
                    ),

                    SizedBox(height: 16),
                    InkWell(
                        onTap: (){
                          if(isValid()){
                            authRead.registerWithCred(context,
                              name: nameController.text,
                              phone: phoneController.text,
                              email: emailController.text,
                             // state:_selectedState!.stateID.toString(),
                             // city:_selectedCity!.cityID.toString(),
                              code: refCodeController.text,

                            ).then((response){
                              if(response.isSuccess){
                                //  showDialog(
                                // context: context,
                                // barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
                                // builder: (context) => SignupSuccess(),
                                // );
                                 _showLocationDialog();
                                 //
                              }else{
                                CustomToast.displayWarningToast(content: response.message);
                              }
                            });
                          }
                          //  Navigation.sideNavigation(context, OtpVerify());
                        },
                        child: LoginButton(labeltext: "Submit",)),
                    SizedBox(height: 8),
                  ],
                ),
              ),


              // Center(
              //   child: InkWell(
              //     onTap: (){
              //       Navigation.sideNavigation(context, LoginPage());
              //
              //     },
              //     child: RichText(
              //       text: TextSpan(
              //         text: "Already have an Account? ",
              //         style: nunito14,
              //         children: [
              //           TextSpan(
              //             text: "Login",
              //             style: TextStyle(
              //               color: AppColors.deepBlue1,
              //               fontWeight: FontWeight.bold,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),


              // CustomArrowButton(text: "Submit",bgColor: AppColors.deepBlue,onTap: (){
              //   Navigation.sideNavigation(context,LoginPage());
              // },),

            ],
          ),
        ),
      ),
    );
  }
  void _showLocationDialog() async {
    String? address = await showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => LocationDialog(),
    );

    if (address != null) {
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen(address: address)),
      // );
    }
  }
  bool isValid() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&

        phoneController.text.isNotEmpty) {
      if (!Validators.isValidEmail(emailController.text)) {
        CustomToast.displayErrorToast(content: "Please enter valid email");
        return false;
      }
      if (phoneController.text.length < 10) {
        CustomToast.displayErrorToast(content: "Please enter valid phone no");
        return false;
      }
      // if (_selectedState == null) {
      //   CustomToast.displayErrorToast(content: "Please Select State");
      //   return false;
      // }if (_selectedCity == null) {
      //   CustomToast.displayErrorToast(content: "Please Select City");
      //   return false;
      // }
      return true;
    } else {
      CustomToast.displayErrorToast(content: "Please enter valid details");
      return false;
    }
  }
}
