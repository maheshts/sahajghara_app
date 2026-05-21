
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/screens/auth/model/OtpResponse.dart';
import 'package:sahajghara/screens/auth/model/RegisterResponse.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/CommonResponse.dart';
import '../helpers/custom_toast.dart';
import '../helpers/navigation.dart';
import '../helpers/utillls.dart';
import '../nwdata/api/api_contants.dart';
import '../nwdata/api/api_helper.dart';
import '../nwdata/service/auth_service.dart';
import '../presentation/widgets/load_state/loader/popup_loader.dart';
import '../screens/location.dart';
import '../screens/auth/otp_verify.dart';
import '../screens/auth/signup_screen.dart';

// enum AuthStatus { initial, authenticated, unAutheticated, loading, error }

enum LoginWithCredStatus {
  initial,
  authenticated,
  unAutheticated,
  loading,
  error
}

enum ForgotPasswordStatus {
  initial,
  authenticated,
  unAutheticated,
  loading,
  error
}

enum VerifyOTPStatus { initial, authenticated, unAutheticated, loading, error }
enum ResendOTPStatus { initial, loading,loaded, error }

enum ChangePasswordStatus {
  initial,
  authenticated,
  unAutheticated,
  loading,
  error
}

final authControllerProvider =
    ChangeNotifierProvider((ref) => AuthController());

class AuthController extends ChangeNotifier {
  APIHelper api = APIHelper();
  // AuthService authService = AuthService();
  LoginWithCredStatus loginWithCredStatus = LoginWithCredStatus.initial;
  ForgotPasswordStatus forgotPasswordStatus = ForgotPasswordStatus.initial;
  VerifyOTPStatus verifyOTPStatus = VerifyOTPStatus.initial;
  ChangePasswordStatus changePasswordStatus = ChangePasswordStatus.initial;
  ResendOTPStatus resendOtpStatus = ResendOTPStatus.initial;
  OtpResponse? otpResponse;

  String mobile = "";
  int otp = 0;
  String token = "";
  String message = "";
  String password = "";
  String confPass = "";

  setUserName(value) {
    mobile = value;
    notifyListeners();
  }

  setPass(value) {
    password = value;
    notifyListeners();
  }

  setConfPass(value) {
    confPass = value;
    notifyListeners();
  }

  bool showPass = false;

  passVisible() {
    showPass = !showPass;
    notifyListeners();
  }

  AuthService authService = AuthService();

  // for register submission
  Future<CommonResponse> registerWithCred1(context,
      {
      required String name,
      required String phone,
      required String email,
      required String state,
      required String city,
      required String code
      }) async {
    PopupLoader().showLoader(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(APIConstants.username, name);

    try {
      var data = await authService.registerWithCred(
          name: name,
          email: email,
          phone: phone,
          // state: state,
          // city: city,
          code: code,
          );
      // var registerData = {};
      Utills.customPrint('register1|$data');
      Utills.customPrint('register1|${data['memberID']}');

      pref.setString(APIConstants.userId, data['memberID'].toString());
      pref.setBool(APIConstants.authenticated, true);
      pref.setString(APIConstants.accountName, data['memberName'].toString());
      pref.setString(APIConstants.mobile, data['memberMobile'].toString());
      pref.setString(APIConstants.email, data['memberEmail'].toString());
      //Navigation.removeAll(context, HomeScreen());
      var userName = pref.getString(APIConstants.accountName);
      Utills.customPrint('register1 userName|$userName');

//       if (data['status'] == 'inserted') {
//         pref.setString(APIConstants.email, email);
//         pref.setString(APIConstants.mobile, phone);
//         pref.setInt(APIConstants.stakeholderId, data['customerId']);
// //         {
// //     "customerId": 38,
// //     "otp": 814043,
// //     "status": "inserted"
// // }
// //         Navigation.sideNavigation(
// //             context,
// //             OtpPage(
// //               userName: data['customerId'].toString(),
// //               pageStatus: 'register',
// //             ));
//       }

      PopupLoader().hideLoader();
      loginWithCredStatus = LoginWithCredStatus.authenticated;
      return CommonResponse(isSuccess: true, message: message);
    } catch (error) {
      PopupLoader().hideLoader();
      CustomToast.displayErrorToast(content: error.toString());
      return CommonResponse(isSuccess: true, message: message);
      //throw Exception(error.toString());
    }
   /// notifyListeners();
  }
  Future<CommonResponse> registerWithCred(
      context, {
        required String name,
        required String phone,
        required String email,

        required String code,
      }) async {
    PopupLoader().showLoader(context);
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(APIConstants.username, name);

    try {
      RegisterResponse data = await authService.registerWithCred(
        name: name,
        email: email,
        phone: phone,

        code: code,
      );

      Utills.customPrint('register1|$data');

      if (data.hasError == false) {
        // save values in pref
        pref.setString(APIConstants.userId, data.result?.user!.sId.toString() ?? "");
        pref.setBool(APIConstants.authenticated, true);
        pref.setString(APIConstants.accountName, data.result!.user!.name.toString() ?? "");
        pref.setString(APIConstants.mobile, data.result!.user!.phone.toString());
        pref.setString(APIConstants.email, data.result!.user!.email.toString());

        PopupLoader().hideLoader();
        loginWithCredStatus = LoginWithCredStatus.authenticated;

        return CommonResponse(isSuccess: true, message: "Registration successful");
      } else {
        PopupLoader().hideLoader();
        CustomToast.displayErrorToast(content: data.message ?? "Registration failed");
        return CommonResponse(isSuccess: false, message: data.message ?? "Registration failed");
      }
    } catch (error) {
      PopupLoader().hideLoader();
      CustomToast.displayErrorToast(content: "Unexpected error occurred");
      return CommonResponse(isSuccess: false, message: "Unexpected error occurred");
    } finally {
      notifyListeners();
    }
  }




  var roleLogin = [];

// for login submission
  Future loginWithCred(context,
      {required String username, required String pass}) async {
    loginWithCredStatus = LoginWithCredStatus.loading;
    PopupLoader().showLoader(context);
    roleLogin = [];
    // SharedPreferences pref = await SharedPreferences.getInstance();
    var loginData = {};
    Utills.customPrint('logindata|username: $username | pass: $pass');
    try {
      var data = await authService.loginWithCred(
        username: username.toString(),
        password: pass.toString(),
      );

      roleLogin = data;

      // if(data[])
      // data.map((element) {
      //   // if (element['priority'] == 0) {
      //   loginData = element;
      Utills.customPrint('loginapi 1 $data');

      //   notifyListeners();
      //   // }
      // }).toList();
      if (data.length > 0) {
        loginData = data[0];
      }

      if (loginData['name'] == 'NoUser') {
        PopupLoader().hideLoader();
        loginWithCredStatus = LoginWithCredStatus.unAutheticated;
        return CustomToast.displayErrorToast(content: "No user!");
      } else if (loginData['name'] == 'Invalid') {
        PopupLoader().hideLoader();
        loginWithCredStatus = LoginWithCredStatus.unAutheticated;
        return CustomToast.displayErrorToast(content: "Invalid user!");
      } else {
        PopupLoader().hideLoader();

      }

      loginWithCredStatus = LoginWithCredStatus.authenticated;
    } catch (error) {
      Utills.customPrint('logindata 1|$error');
      PopupLoader().hideLoader();

      CustomToast.displayErrorToast(content: error.toString());
      loginWithCredStatus = LoginWithCredStatus.error;

      throw Exception(error.toString());
    }
    notifyListeners();
  }

  loginRoleSlectionStep(context, {var loginData}) async {
     Utills.customPrint('loginData|$loginData');
    await AuthService().storeLogindata(loginData);

    PopupLoader().hideLoader();
    loginWithCredStatus = LoginWithCredStatus.authenticated;

  }

  // forgot pass




  changePassword(context, {username, pass}) async {
    changePasswordStatus = ChangePasswordStatus.loading;
    PopupLoader().showLoader(context);
    String url =
        "${APIConstants.baseUrl}/swm/rest/user/changePassword/$username/$pass";

    Utills.customPrint('changePassword 1 $url');
    try {
      var result = await authService.changePassword(context,
          pass: pass, username: username);

      // if (result['status'] == "Success") {
      //   Navigation.removeAll(context, const LoginPage());
      // } else {
      //   CustomToast.displayErrorToast(content: result['status'].toString());
      // }

      Utills.customPrint('changePassword 2 $result');
      PopupLoader().hideLoader();
      changePasswordStatus = ChangePasswordStatus.authenticated;
    } catch (error) {
      Utills.customPrint('changePassword 4 $error');
      PopupLoader().hideLoader();
      CustomToast.displayWarningToast(content: error.toString());
      changePasswordStatus = ChangePasswordStatus.error;

      throw Exception(error.toString());
    }
    notifyListeners();
  }


  generateOtp(context, mobile) async {
    changePasswordStatus = ChangePasswordStatus.loading;
    PopupLoader().showLoader(context);
    try {
      otpResponse = await authService.otpgenerate1(context,
          mobile);

      //
       otp = otpResponse!.result?.otp ?? 0;
      // token = result['token'];
      bool? isRegister = otpResponse!.result?.register;
      if(otpResponse!.hasError == false){
         Navigation.sideNavigation(context, OtpVerify(otp,token,mobile,isRegister!));
       }

      Utills.customPrint('otp hasError ${otpResponse!.hasError}');
      Utills.customPrint('otp 2 $otp');
      Utills.customPrint('otp 2 $token');
    //  Utills.customPrint('otp 2 ${otpResponse!.result?.user?.toJson()}');
       Future.delayed(const Duration(seconds: 1), () {
         CustomToast.displaySuccessToast(content: "Login Otp is ${otp}");
       });
      PopupLoader().hideLoader();
      changePasswordStatus = ChangePasswordStatus.authenticated;
      notifyListeners();
    } catch (error) {
      Utills.customPrint('otp 4 $error');
      PopupLoader().hideLoader();
      CustomToast.displayWarningToast(content: error.toString());
      changePasswordStatus = ChangePasswordStatus.error;

      throw Exception(error.toString());
    }
    notifyListeners();
  }
  resendOtp(context, mobile) async {
    resendOtpStatus = ResendOTPStatus.loading;
    PopupLoader().showLoader(context);
    try {
      var result = await authService.otpgenerate1(context,
          mobile);


      print("controller otp ${json.encode(result.toJson())}");

      print("controller user ${json.encode(result.result?.user?.toJson())}");

      otp = result.result?.otp;
      //token = result.result?.token;
      // if(result['statusCode'] == 1){
      //   Navigation.sideNavigation(context, OtpVerify(otp,token,mobile));
      // }
      //CustomToast.displaySuccessToast(content: "Login Otp $otp");
      Future.delayed(const Duration(seconds: 2), () {
        CustomToast.displaySuccessToast(content: "Login Otp is ${otp}");
      });
      Utills.customPrint('otp 2 $result');
      Utills.customPrint('otp 2 $otp');
     // Utills.customPrint('otp 2 $token');
      PopupLoader().hideLoader();
      resendOtpStatus = ResendOTPStatus.loaded;
    } catch (error) {
      Utills.customPrint('otp 4 $error');
      PopupLoader().hideLoader();
      CustomToast.displayWarningToast(content: error.toString());
      resendOtpStatus = ResendOTPStatus.error;

      throw Exception(error.toString());
    }
    notifyListeners();
  }
  verifyOtp(context, mobile,otp) async {
    verifyOTPStatus = VerifyOTPStatus.loading;
    PopupLoader().showLoader(context);
    try {
      // var result = await authService.otpverify(context,
      //     mobile,otp,token);


      // if(result['statusCode'] == 1){
      //   Navigation.sideNavigation(context, OtpVerify(otp,token));
      // }

      //Utills.customPrint('otp 2 $result');
     // Utills.customPrint('otp memberMobile ${result["memberMobile"]}');
    Utills.customPrint('overidy tp 2 $otp');
    Utills.customPrint('overidy register${otpResponse!.result!.register}');
     // Utills.customPrint('otp 2 $token');
      if(otpResponse!.result!.register == false){

        Navigation.replace(context, SignUpScreen(mobile: mobile));
      }else{
       // Navigation.replace(context, NewHomeScreen(mobile: mobile));
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setBool(APIConstants.authenticated,true);

        pref.setString(APIConstants.userId, otpResponse!.result!.user!.sId.toString());
        pref.setBool(APIConstants.authenticated, true);
        pref.setString(APIConstants.accountName, otpResponse!.result!.user!.name.toString());
        pref.setString(APIConstants.mobile, otpResponse!.result!.user!.phone.toString());
        pref.setString(APIConstants.email, otpResponse!.result!.user!.email.toString());

        _showLocationDialog(context);

      }
      PopupLoader().hideLoader();
      changePasswordStatus = ChangePasswordStatus.authenticated;
    } catch (error) {
      Utills.customPrint('otp 4 $error');
      PopupLoader().hideLoader();
      CustomToast.displayWarningToast(content: error
          .toString());
      changePasswordStatus = ChangePasswordStatus.error;

      throw Exception(error.toString());
    }
    notifyListeners();
  }

  var companyProfileData = {};

  logOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.clear();

   // Navigation.removeAll(context, const LoginPage());
  }
  void _showLocationDialog(context) async {
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

}
