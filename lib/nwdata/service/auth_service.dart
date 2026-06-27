import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sahajghara/nwdata/service/push_notification_service.dart';
import 'package:sahajghara/screens/auth/model/OtpResponse.dart';
import 'package:sahajghara/screens/auth/model/RegisterResponse.dart';
import 'package:sahajghara/service/NotificationService.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../../helpers/custom_toast.dart';
import '../../helpers/utillls.dart';
import '../api/api_contants.dart';
import '../api/api_helper.dart';
import '../api/exceptions.dart';

// class UtillService {

// }

class AuthService {
  APIHelper api = APIHelper();

  registerWithCred({
    required String name,
    required String phone,
    required String email,

    required String code,
  }) async {
    String url = "${APIConstants.baseUrl}/registation";

    var data = {
      "name": name,
      "referalCode": code,
      "gender": "",
      "phone": phone,
      "memberWhatsUp": "",
      "email": email,
      // "memberState": state,
      // "memberCity": city,
      "password": "12345",
    };

    Utills.customPrint('register url $url');
    Utills.customPrint('register input $data');

    try {
      Response response = await api.postMethod(url: url, body: data);

      var result = response.data;
      Utills.customPrint('register $result');
      Utills.customPrint('register service ${result['HasError']}');
      Utills.customPrint('HasError value: ${result['HasError']}');
      Utills.customPrint('HasError type: ${result['HasError'].runtimeType}');
      final hasError = result['HasError'];
      if (hasError == false|| hasError.toString().toLowerCase() == 'false') {
        RegisterResponse response = RegisterResponse.fromJson(result);
        CustomToast.displaySuccessToast(content: "Registration successful");
        return response;
      } else {
        CustomToast.displayErrorToast(content: result['Message'] ?? "Something went wrong");
        return {
          "status_Code": result['status_Code'],
          "msg": result['Message'] ?? "Something went wrong"
        };
      }
    } on DioException catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg": dioError.response?.data?['message'] ?? "Server error. Please try again."
      };
    }
  }


  createUser(
      {required String blockId,
      required String laneId,
      required String lat,
      required String long}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String companyId = preferences.getString(APIConstants.companyId) ?? "";
    String customerId = preferences.getString(APIConstants.userId) ?? "";

    String url =
        "${APIConstants.baseUrl}//swm/rest/customer/createUser/$companyId/$customerId/$blockId/$laneId/$lat/$long";

    Utills.customPrint('createUser|$url');

    try {   
      Response response = await api.getMethod(
        url: url,
      );

      var result = response.data;
      Utills.customPrint('createUser|$url');

      return result;
    } on DioError catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg": dioError.response?.data?['message'] ?? "Server error. Please try again."
      };
    }
  }

  loginWithCred({username, password}) async {
    // String fcmToken = await PushNotificationService().getFcmToken();
    String fcmToken = await PushNotificationService().storeFcmTokenToDB();
    String url =
        "${APIConstants.baseUrl}/swm/rest/user/login/$username/$password/android/$fcmToken";
    try {
      print('getlogin|$url');
      Response response = await api.withOutTokenGetMethod(
        url: url,
      );

      var result = response.data;

      return result;
    } on DioException catch (dioError) {
      throw CustomException.fromDioError(dioError);
    }
  }

  storeCreateUserData(data) async {
    //  "userId": 181,
    // "userType": "7",
    // "name": "Shreyas R",
    // "companyId": "1020",
    // "accountId": "bccp",
    // "gpsUserId": "ward-2",
    // "accountPsswd": "@Ward2",
    // "gpsUrl": "http://optrack.in/track/Track",
    // "gpsEventUrl": "http://optrack.in:38081/events/data.json",
    // "priority": 0,
    // "accessLevel": 0,
    // "levelId": 0,
    // "stakeholderId": 2
    //
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(APIConstants.authenticated, true);
    await pref.setString(APIConstants.username, data?['name']);
    await pref.setString(APIConstants.userType, data?['userType']);
    await pref.setString(APIConstants.accountId, data?['accountId']);
    await pref.setString(APIConstants.gpsUserId,
        data?['gpsUserId'] == "" ? "0" : data?['gpsUserId']);
    // await pref.setString(APIConstants.userId, data?['customerId'] ?? "");

    await pref.setString(APIConstants.userId, data['userId'].toString());
    await pref.setString(APIConstants.acPass, data?['accountPsswd']);
    await pref.setString(APIConstants.gpsEventUrl, data?['gpsEventUrl']);
    await pref.setString(APIConstants.companyId, data?['companyId']);
    await pref.setInt(APIConstants.accessLevel, data?['accessLevel'] ?? 0);
    await pref.setInt(APIConstants.levelId, data?['levelId'] ?? 0);
    await pref.setInt(APIConstants.stakeholderId, data?['stakeholderId'] ?? 0);
    await pref.setInt(APIConstants.manager, data?['isManager'] ?? 0);
  }

  storeLogindata(loginData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool(APIConstants.authenticated, true);
    await pref.setString(APIConstants.username, loginData?['name']);
    await pref.setString(APIConstants.userType, loginData?['userType']);
    await pref.setString(APIConstants.accountId, loginData?['accountId']);
    await pref.setString(APIConstants.gpsUserId,
        loginData?['gpsUserId'] == "" ? "0" : loginData?['gpsUserId']);
    await pref.setString(APIConstants.userId, loginData?['customerId'] ?? "");
    await pref.setString(APIConstants.userId, loginData['userId'].toString());
    await pref.setString(APIConstants.acPass, loginData?['accountPsswd']);
    await pref.setString(APIConstants.gpsEventUrl, loginData?['gpsEventUrl']);
    await pref.setString(APIConstants.companyId, loginData?['companyId']);
    await pref.setInt(APIConstants.accessLevel, loginData?['accessLevel'] ?? 0);
    await pref.setInt(APIConstants.levelId, loginData?['levelId'] ?? 0);
    await pref.setInt(APIConstants.manager, loginData?['isManager'] ?? 0);
    await pref.setInt(
        APIConstants.stakeholderId, loginData?['stakeholderId'] ?? 0);
  }

  Future forgotPassword(context, {username}) async {
    String url =
        "${APIConstants.baseUrl}//swm/rest/user/forgotPassword/$username";

    try {
      Response response = await api.getMethod(
        url: url,
      );
      var result = await response.data;
      Utills.customPrint('omgcheck$result');
      return result;
    } on DioError catch (dioError) {
      throw CustomException.fromDioError(dioError);
    }
  }

  verifyOTP(context, {userName, otp, status}) async {
    // String url =
    //     "${APIConstants.baseUrl}/swm/rest/user/verifyOtp/$userName/$otp";
    String params = "";
    if (status == "register") {
      params = "customer/verifyOtp/$userName/$otp";
    } else {
      params = "user/verifyOtp/$userName/$otp";
    }
    String url = "${APIConstants.baseUrl}/swm/rest/$params";

    Utills.customPrint('loginapi 1 $url');
    try {
      Response response = await api.getMethod(
        url: url,
      );

      var result = response.data;

      return result;
    } on DioError catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg": dioError.response?.data?['message'] ?? "Server error. Please try again."
      };
    }
  }

  changePassword(context, {username, pass}) async {
    String url =
        "${APIConstants.baseUrl}/swm/rest/user/changePassword/$username/$pass";

    Utills.customPrint('changePassword 1 $url');
    try {
      Response response = await api.getMethod(
        url: url,
      );

      var result = response.data;
      return result;
    } on DioError catch (dioError) {
      throw CustomException.fromDioError(dioError);
    }
  }
  otpgenerate1(context, phone) async {

    var data1 = json.encode({
      "phone": phone,
      "otp": "",
      "token": ""
    });
    try{
    var dio = Dio();
    print("url '${APIConstants.baseUrl}/generateOTP");
    Utills.customPrint("data1 $data1");
    dio.interceptors.add(LogInterceptor(responseBody: true, requestBody: true));
    var response = await dio.request(
      '${APIConstants.baseUrl}/generateOTP',
      options: Options(
        method: 'POST',
        headers:{
          'Content-Type': 'application/json'
        },
      ),
      data: data1,
    );
    print(json.encode(response.data));

    if (response.statusCode == 200) {
      var result = response.data;
      OtpResponse otpResponse = OtpResponse.fromJson(response.data);
      Utills.customPrint('OTP response $result');
           return otpResponse;
    }
    else {
      print(response.statusMessage);
      CustomToast.displayErrorToast(content:response.statusMessage);
    }
  } on DioException catch (dioError) {
       Utills.customPrint('response dioError -  $dioError');
       Utills.customPrint('response dioError -  ${dioError.message}');
       CustomToast.displayErrorToast(content: dioError.message);

       throw CustomException.fromDioError(dioError);
     }
 //    try {
 //      //http://api.zingara.club/Member/generateotp
 //      Response response = await api.postMethod(
 //        url: url,
 //          body: data
 //
 //      );
 //      Utills.customPrint('response statusCode ${json.encode(response)}');
 //      Utills.customPrint('response statusCode ${response.statusCode}');
 //
 //      var result = response.data;
 // Utills.customPrint('response $result');
 //      return result;
 //    } on DioException catch (dioError) {
 //      Utills.customPrint('response dioError -  $dioError');
 //      Utills.customPrint('response dioError -  ${dioError.message}');
 //      CustomToast.displayErrorToast(content: dioError.message);
 //
 //      throw CustomException.fromDioError(dioError);
 //    }
  }
  otpverify(context, phone,otp,uid) async {
    String url =
        "${APIConstants.baseUrl}/updateFcmToken";
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberid = pref.getString(APIConstants.userId);
    // String url = "${APIConstants.baseUrl}/homepage";
    String? fcm = pref.getString(APIConstants.fcmToken);
    debugPrint(
        "Firebase Apps => ${Firebase.apps.length}"
    );
    Utills.customPrint('otps  $url');


    Utills.customPrint('otps  ${FirebaseMessaging.instance.getToken()}');
    if(fcm == null || fcm.isEmpty){
      fcm = await NotificationService.inittoken();
    }
    Utills.customPrint('fcm  $fcm');




    var headers = {
      'Content-Type': 'application/json'
    };
    var data = {
      "user_id":uid,
      "fcm_token": fcm,
      // "token": token,
    };
    Utills.customPrint('otps  phone$data');

    try{
    var dio = Dio();
    var response = await dio.request(
      url,
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      print(json.encode(response.data));
      var result = response.data;
      Utills.customPrint('response $result');
           return result;
    }
    else {
      print(response.statusMessage);
      CustomToast.displayErrorToast(content:response.statusMessage);
    }
  } on DioException catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg": dioError.response?.data?['message'] ?? "Server error. Please try again."
      };
     }
 //    try {
 //      //http://api.zingara.club/Member/generateotp
 //      Response response = await api.postMethod(
 //        url: url,
 //          body: data
 //
 //      );
 //      Utills.customPrint('response statusCode ${json.encode(response)}');
 //      Utills.customPrint('response statusCode ${response.statusCode}');
 //
 //      var result = response.data;
 // Utills.customPrint('response $result');
 //      return result;
 //    } on DioException catch (dioError) {
 //      Utills.customPrint('response dioError -  $dioError');
 //      Utills.customPrint('response dioError -  ${dioError.message}');
 //      CustomToast.displayErrorToast(content: dioError.message);
 //
 //      throw CustomException.fromDioError(dioError);
 //    }
  }



 //  otpgenerate(context, phone) async {
 //    String url =
 //        "${APIConstants.baseUrl}generateotp";
 //
 //    Utills.customPrint('otps  $url');
 //
 //
 //    var data1 = json.encode({
 //      "memberMobile": "8270951636",
 //      "otp": "",
 //      "token": ""
 //    });
 //    Utills.customPrint('otps data1 $data1');
 //
 //    //
 //    // if (response.statusCode == 200) {
 //    //   print(json.encode(response.data));
 //    // }
 //    // else {
 //    //   print(response.statusMessage);
 //    // }
 //    try {
 //      Response response = await api.postRequest(
 //        url: url,
 //          body: data1
 //      );
 //      Utills.customPrint('response statusCode ${json.encode(response)}');
 //      Utills.customPrint('response statusCode ${response.statusCode}');
 //
 //      var result = response.data;
 // Utills.customPrint('response $result');
 //      return result;
 //    } on DioException catch (dioError) {
 //      Utills.customPrint('response dioError -  $dioError');
 //      Utills.customPrint('response dioError -  ${dioError.message}');
 //      CustomToast.displayErrorToast(content: dioError.message);
 //
 //      throw CustomException.fromDioError(dioError);
 //    }
 //  }


}
