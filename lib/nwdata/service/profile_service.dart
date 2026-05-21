import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sahajghara/screens/profile/model/ProfileResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/custom_toast.dart';
import '../../helpers/utillls.dart';
import '../../screens/profile/vendor/vendor_enquiry_details.dart';
import '../../screens/vendor/EnquiryDetailResponse.dart';
import '../api/api_contants.dart';
import '../api/api_helper.dart';
import '../model/EnquiryResponse.dart';

class ProfileService {
  APIHelper api = APIHelper();

  submitRequest(type) async {

    String url = "${APIConstants.baseUrl}/userRequest";
   // Utills.customPrint('inquirySubmit data ${json.encode(data)}');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String companyId = preferences.getString(APIConstants.companyId) ?? "";
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    Utills.customPrint('inquirySubmit type $type');
    try {
      //for contractor 2
      var data={
        "user_id":customerId,
        "request_vendor": type == 1 ? 1:0 ,
        "request_contractor":type == 2 ?1:0,
      };
      Utills.customPrint('inquirySubmit data $data');

      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        EnquiryResponse homePageResponse = EnquiryResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['message'] ??
            "Server error. Please try again.",
      };
    }
  }
  getProfileData() async {

    String url = "${APIConstants.baseUrl}/viewprofile";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    try {
      //for contractor 2
      var data={
        "user_id":customerId,

      };
      Utills.customPrint('inquirySubmit data $data');

      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        ProfileResponse homePageResponse = ProfileResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['message'] ??
            "Server error. Please try again.",
      };
    }
  }
  Future<EnquiryDetailResponse> getEnquiryDetailsData(ids) async {

    String url = "${APIConstants.baseUrl}/inquiryDetails";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    try {
      //for contractor 2
      var data={
        "_id":ids,
     //   "listfor":"vendor"

      };
      Utills.customPrint('inquirySubmit data $data');

      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');

        EnquiryDetailResponse homePageResponse = EnquiryDetailResponse.fromJson(response.data);

        return homePageResponse;

    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return EnquiryDetailResponse();
    }
  }
  Future<EnquiryDetailResponse> getContractorEnquiryDetailsData(ids) async {

    String url = "${APIConstants.baseUrl}/inquiryContactorDetails";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    try {
      //for contractor 2
      var data={
        "_id":ids,
     //   "listfor":"vendor"

      };
      Utills.customPrint('inquirySubmit data $data');

      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');

        EnquiryDetailResponse homePageResponse = EnquiryDetailResponse.fromJson(response.data);

        return homePageResponse;

    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return EnquiryDetailResponse();
    }
  }
  addVendorQuotation(body) async {

    String url = "${APIConstants.baseUrl}/inquirySubmitUpdate";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    try {
      //for contractor 2

      Utills.customPrint('inquirySubmit data $body');

      Response response = await api.postMethod(url: url, body: body);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
       // ProfileResponse homePageResponse = ProfileResponse.fromJson(response.data);

        return result;
      }
    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['message'] ??
            "Server error. Please try again.",
      };
    }
  }
  addContractorQuotation() async {

    String url = "${APIConstants.baseUrl}/inquirySubmitUpdate";
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String customerId = preferences.getString(APIConstants.userId) ?? "";
    Utills.customPrint('inquirySubmit url $url');
    try {
      //for contractor 2
      var data={
        "user_id":customerId,

      };
      Utills.customPrint('inquirySubmit data $data');

      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('submitEnquiry $result');

      Utills.customPrint('Home service response $result');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        ProfileResponse homePageResponse = ProfileResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
      CustomToast.displayErrorToast(content: "Unable to Proceed");
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['message'] ??
            "Server error. Please try again.",
      };
    }
  }

}