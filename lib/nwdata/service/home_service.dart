import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sahajghara/nwdata/model/EnquiryResponse.dart';
import 'package:sahajghara/nwdata/model/brand_response.dart';
import 'package:sahajghara/screens/contractor/portfolio_list.dart';
import 'package:sahajghara/screens/home/HomePageResponse.dart';
import 'package:sahajghara/screens/profile/model/ContractorEnquiryListResponse.dart';
import 'package:sahajghara/screens/profile/model/EnquireyListResponse.dart';
import 'package:sahajghara/screens/vendor/VendorListResponse.dart';
import 'package:share_plus/share_plus.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/custom_toast.dart';
import '../../helpers/utillls.dart';
import '../../screens/contractor/ContractorReposne.dart';
import '../../screens/contractor/model/PortfolioData.dart';
import '../api/api_contants.dart';
import '../api/api_helper.dart';
import '../api/exceptions.dart';
import '../model/notification_model.dart';

class HomeService {
  APIHelper api = APIHelper();

  getHomeData({latitude, longitude}) async {
    Utills.customPrint('home servie getHomeData');

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // int companyId = prefs.getInt(APIConstants.companyId) ?? 0;
    // Utills.customPrint('home companyId $companyId');
    //
    // int userType = prefs.getInt(APIConstants.userType) ?? 0;
    // String useType = "";
    // Utills.customPrint('home userType $userType');
    //
    // int userid = prefs.getInt(APIConstants.userId) ?? 0;
    // Utills.customPrint('home userid $userid');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberid = pref.getString(APIConstants.userId);
    String url = "${APIConstants.baseUrl}/homepage";
    String? fcm = pref.getString(APIConstants.fcmToken);
    Utills.customPrint('url $url');
    Utills.customPrint('memberid $memberid');
    //http://api.zingara.club/api/Home/GetAllBanner?Longitude=21&Latitude=2313

    try {
      Response response = await api.postMethod(
        url: url,
        body: {"lat": latitude, "long": longitude, "user_id": memberid ?? 0,"fcm_id":fcm},
      );
      var result = response.data;

      Utills.customPrint('Home bannerdata $result');
      Utills.customPrint('Home bannerdata $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      //print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);
      Utills.customPrint('Home service response $result');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        HomePageResponse homePageResponse = HomePageResponse.fromJson(
          response.data,
        );
        // HomeResult homePageResponse = HomeResult.fromJson(json.decode(json.encode(response.data['result'])));
        // Utills.customPrint('Home service  ${homePageResponse.primumProperty!.length}');

        return homePageResponse;
      }
    } on DioException catch (dioError) {
      Utills.customPrint('DioException: ${dioError.error}');
      Utills.customPrint('DioException: ${dioError.response?.data}');
      throw CustomException.fromDioError(dioError);
    }
  }

  getCategoryListItem({latitude, longitude, categoryid}) async {
    String url =
        "${APIConstants.baseUrl}/api/Home/GetAllPropertyCategoryID?CatagoryId=$categoryid&Longitude=$longitude&Latitude=$latitude";
    Utills.customPrint('url $url');

    try {
      Response response = await api.postMethod(url: url);
      var result = response.data;

      Utills.customPrint('Home service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);
      Utills.customPrint('Home service response $result');
      //Utills.customPrint('Home service response ${result[0]}');
      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        var homePageResponse = response.data;
        // HomeResult homePageResponse = HomeResult.fromJson(json.decode(json.encode(response.data['result'])));
        Utills.customPrint('CategoryListData  ${homePageResponse}');
        Utills.customPrint(
          'Home service banner ${homePageResponse.primumProperty!.length}',
        );


        return homePageResponse;
      }
    } on DioException catch (dioError) {
      Utills.customPrint('DioException: ${dioError.error}');
      Utills.customPrint('DioException: ${dioError.response?.data}');
      throw CustomException.fromDioError(dioError);
    }
  }

  createPaymentkey({
    orderAmount,
    memberId,
    propertyId,
    useWallet,
    useBonus,
    ticketno,
  }) async {
    Utills.customPrint('orderConfirm');

    String url = "${APIConstants.baseUrl}/packagepaymentkey";
    Utills.customPrint('url $url');
    var data = {
      "amount": orderAmount,
      "user_id": memberId,
      "id": propertyId,

    };
    Utills.customPrint('Data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('Home service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);
      Utills.customPrint('Home service response $result');
      // Map<String, dynamic> data = json.decode(json.encode(response.data));
      var jsonResponse = response.data;
      if (response.statusCode != 200) {
        Utills.customPrint(
          'Order service response if ${response.statusMessage}',
        );
        CustomToast.displayErrorToast(content: response.statusMessage);
        return {
          "status_Code": response.statusCode,
          "msg": response.statusMessage ?? "Server error",
        };
      } else {
        //Map<String, dynamic> jsonResponse = jsonDecode(response.data);
        //HomeResponse homePageResponse = HomeResponse.fromJson(jsonResponse);
        // ItemListData homePageResponse = ItemListData.fromJson(response.data);
        // // HomeResult homePageResponse = HomeResult.fromJson(json.decode(json.encode(response.data['result'])));
        Utills.customPrint('ORder service  ${jsonResponse}');
        //  Utills.customPrint('Home service banner ${homePageResponse.primumProperty}');

        // HomePageResponse homePageResponse = HomePageResponse.fromJson(jsonDecode(response.data));
        // Utills.customPrint('Home service response ${homePageResponse.tabview!.length}');
        //return await parseWorkData(json.decode(json.encode(result)));

        return jsonResponse;
      }
    } on DioException catch (dioError) {
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
  paymentConfirm({orderid, transactionid, paymentstatus, statusmsg}) async {
    Utills.customPrint('paymentConfirm');
    String url = "${APIConstants.baseUrl}/paymentSuccess";
    Utills.customPrint('paymentConfirm url $url');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberid = pref.getString(APIConstants.userId);
    var data = {
      "orderId": orderid,
      "user_id": memberid,
      "bankTransactionId": transactionid,
      "id": transactionid,
      "paymentStatus": paymentstatus,
      "remarks": statusmsg,
      "order_status": statusmsg
    };
    Utills.customPrint('paymentConfirm data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);

      Utills.customPrint('paymentConfirm statusCode ${response.statusCode}');
      Utills.customPrint('paymentConfirm result ${response.data}');

      if (response.statusCode == 200) {
        var result = response.data;

        // API may still return error text even with 200
        if (result is Map && result.containsKey("message")) {
          if (result["message"].toString().toLowerCase().contains("error")) {
            CustomToast.displayErrorToast(content: result["message"]);
            return null;
          }
        }

        return result; // success
      } else {
        CustomToast.displayErrorToast(content: response.statusMessage ?? "Unknown error");
        return {
          "status_Code": response.statusCode ?? 400,
          "msg": response.data?['message'] ?? "Server error. Please try again."
        };
      }
    } on DioException catch (dioError) {
      final errMessage = dioError.response?.data?["message"] ??
          dioError.message ??
          "Something went wrong!";
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg": dioError.response?.data?['message'] ?? "Server error. Please try again."
      };
    } catch (e) {
      Utills.customPrint('Unexpected error: $e');
      CustomToast.displayErrorToast(content: "Unexpected error occurred.");
      return null;
    }
  }
submitEnquiry(data) async {

  String url = "${APIConstants.baseUrl}/inquirySubmit";
  Utills.customPrint('inquirySubmit data ${json.encode(data)}');

  Utills.customPrint('inquirySubmit url $url');
  try {
    Response response = await api.postMethod(url: url, body: data);
    var result = response.data;

    Utills.customPrint('submitEnquiry $result');

    Utills.customPrint('Home service response $result');
    if (response.statusCode != 200) {
      CustomToast.displayErrorToast(content: response.statusMessage);
    } else {
      EnquiryResponse homePageResponse =
      EnquiryResponse.fromJson(response.data);

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
submitContractor(data) async {

  String url = "${APIConstants.baseUrl}/inquiryContractorSubmit";
  Utills.customPrint('inquirySubmit data ${json.encode(data)}');

  Utills.customPrint('inquirySubmit url $url');
  try {
    Response response = await api.postMethod(url: url, body: data);
    var result = response.data;

    Utills.customPrint('submitEnquiry $result');

    Utills.customPrint('Home service response $result');
    if (response.statusCode != 200) {
      CustomToast.displayErrorToast(content: response.statusMessage);
    } else {
      EnquiryResponse homePageResponse =
      EnquiryResponse.fromJson(response.data);

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


  enquirylists({memberId}) async {
    Utills.customPrint('orderConfirm');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/inquiriesList";
    Utills.customPrint('url $url');
    var data = {
      "customer": userid,

    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        EnquireyListResponse homePageResponse =
        EnquireyListResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
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
  Future<List<NotificationModel>> getNotifications() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    try {
      String url =
          "${APIConstants.baseUrl}/notificationList?user_id=$userid";
      Utills.customPrint('url $url');
      Response response = await api.getMethod(url: url);
      var result = response.data;
      Utills.customPrint("result $result");

      // final response = await http.get(
      //   Uri.parse(
      //     "https://sahajaapp-cv53.onrender.com/api/notificationList",
      //   ),
      //   headers: {
      //     "Authorization": "Bearer $token",
      //     "Accept": "application/json",
      //   },
      // );

      if (response.statusCode == 200) {
        final jsonData = response.data;

        if(jsonData['success']) {
          List<dynamic> list =
              jsonData['data']['data'] ?? [];

          return list
              .map((e) => NotificationModel.fromJson(e))
              .toList();
        }
      }

      return [];
    } catch (e) {

      throw Exception(e.toString());
    }
  }


  vendormyenquirylists({memberId}) async {
    Utills.customPrint('orderConfirm');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/inquiriesList";
    Utills.customPrint('url $url');
    var data = {
      "vendor": userid,
      "listfor":"vendor"

    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        EnquireyListResponse homePageResponse =
        EnquireyListResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
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
  contractorenquirylists({memberId}) async {
    Utills.customPrint('orderConfirm');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/inquiryContractorList";
    Utills.customPrint('url $url');
    var data = {
      "customer": userid,

    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        ContractorEnquiryListResponse homePageResponse =
        ContractorEnquiryListResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
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
  contractormyenquirylists({memberId}) async {
    Utills.customPrint('orderConfirm');
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/inquiryContractorList";
    Utills.customPrint('url $url');
    var data = {
      "vendor": userid,    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        ContractorEnquiryListResponse homePageResponse =
        ContractorEnquiryListResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
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
  contractorlist({memberId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/contractorlist";
    Utills.customPrint('url $url');
    var data = {
      "customer": userid,

    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {
        ContractorResponse homePageResponse =
        ContractorResponse.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
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
 Future<PortfolioData> getportFoliolist({memberId}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);

    String url =
        "${APIConstants.baseUrl}/myportfolioList";
    Utills.customPrint('url $url');
    var data = {
      "user_id": userid,

    };
    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
        return PortfolioData();

      } else {
        PortfolioData homePageResponse =
        PortfolioData.fromJson(response.data);

        return homePageResponse;
      }
    } on DioException catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return PortfolioData();
    }
  }

  Future getVendorList(
    String? categoryId,
    String? brandId,
    String? subcategory,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);
    var url = "${APIConstants.baseUrl}/getVendor";
    Utills.customPrint(url);
    var dd ={
      "lat": "",
      "long": "",
      "brand": brandId,
      "category": categoryId,
      "subcategory": subcategory,
      "user_id": userid,
    };
    Response response = await api.postMethod(
      url: url,
      body: dd
    );
    Utills.customPrint('vendor dd${dd}');

    if (response.statusCode == 200) {
      // Parse the response body
     // List<dynamic> data = response.data;
      VendorListResponse vendorListResponse = VendorListResponse.fromJson(response.data);
      Utills.customPrint('vendor service  ${json.encode(vendorListResponse.result)}');
      return vendorListResponse;
    } else {
      throw Exception();
    }
  }

  Future getBrandList(
    String? categoryId,
    String? subcategory,
  ) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var userid = pref.getString(APIConstants.userId);
    var url = "${APIConstants.baseUrl}/getCategoryBrand";
    Utills.customPrint(url);
    var dd = {
      "lat": "",
      "long": "",
      "category": categoryId,
      "subcategory": subcategory,
      "user_id": userid,
    };
    Response response = await api.postMethod(
      url: url,
      body:dd,
    );
    Utills.customPrint("response data ${dd}");
    Utills.customPrint("response data ${json.encode(response.data)}");
    if (response.statusCode == 200) {
      // Parse the response body
     // List<dynamic> data = response.data;
      BrandResponse vendorListResponse = BrandResponse.fromJson(response.data);
      Utills.customPrint('vendor service  ${vendorListResponse.hasError}');
      return vendorListResponse;
    } else {
      throw Exception();
    }
  }

  addPortfolio(data) async {
    Utills.customPrint('addmyportfolio');


    String url =
        "${APIConstants.baseUrl}/addmyportfolio";
    Utills.customPrint('url $url');

    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');
      // final List<dynamic> jsonData = json.decode(response.data);
      print('Response data type: ${response.data.runtimeType}');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {


        return response.data;
      }
    } on DioException catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['Message'] ??
            "Server error. Please try again.",
      };
    }
  }
  updateProfile(data) async {
    Utills.customPrint('addmyportfolio $data');


    String url =
        "${APIConstants.baseUrl}/updateprofile";
    Utills.customPrint('url $url');

    Utills.customPrint('data $data');

    try {
      Response response = await api.postMethod(url: url, body: data);
      var result = response.data;

      Utills.customPrint('PreOrder service response $result');

      // var jsonResponse = jsonDecode(response.data);

      if (response.statusCode != 200) {
        CustomToast.displayErrorToast(content: response.statusMessage);
      } else {


        return response.data;
      }
    } on DioException catch (dioError) {
      Utills.customPrint("DioException: ${dioError.message}");
      Utills.customPrint("Response: ${dioError.response?.data}");

      // return safe map instead of throwing
      return {
        "status_Code": dioError.response?.statusCode ?? 500,
        "msg":
        dioError.response?.data?['Message'] ??
            "Server error. Please try again.",
      };
    }
  }


  // Future<List<Categories>> fetchCategories() async {
  //   String url = "${APIConstants.baseUrl}/api/Home/GetAllCategory";
  //   Utills.customPrint('url $url');
  //   //final response = await http.get(Uri.parse('https://your-api-endpoint.com'));
  //   Response response = await api.getMethod(
  //     url: url,
  //   );
  //   if (response.statusCode == 200) {
  //     // Parse the response body
  //     List<dynamic> data = response.data;
  //     Utills.customPrint('Categories service  ${data}');
  //
  //     // Map each JSON object to a Category and return as a list
  //     return data.map((json) => Categories.fromJson(json)).toList();
  //   } else {
  //     throw Exception('Failed to load categories');
  //   }
  // }
}
