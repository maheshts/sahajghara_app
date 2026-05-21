import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../helpers/CommonResponse.dart';
import '../helpers/custom_toast.dart';
import '../helpers/utillls.dart';
import '../nwdata/api/api_contants.dart';
import '../nwdata/api/api_helper.dart';

import '../nwdata/service/home_service.dart';
import '../presentation/widgets/load_state/loader/popup_loader.dart';

enum PreOrderStatus { loading, loaded, error }

enum OrderDataStatus { intial, loading, loaded, error }

enum OrderDetailDataStatus { intial, loading, loaded, error }

enum OrderHistoryStatus { intial, loading, loaded, error }

enum PaymentConfirmStatus { intial, loading, loaded, error }

enum RatingStatus { intial, loading, loaded, error }

final orderControllerProvider =
    ChangeNotifierProvider((ref) => OrderController());

class OrderController extends ChangeNotifier {
  APIHelper api = APIHelper();
  OrderDataStatus getHomeDataStatus = OrderDataStatus.intial;
  PreOrderStatus preOrderStatus = PreOrderStatus.loading;
  OrderHistoryStatus orderHistoryStatus = OrderHistoryStatus.loading;
  OrderDetailDataStatus orderDetailStatus = OrderDetailDataStatus.loading;
  PaymentConfirmStatus paymentStatus = PaymentConfirmStatus.intial;
  RatingStatus ratingStatus = RatingStatus.intial;
  HomeService homeService = HomeService();
  // PreOrderResponse _preOrderResponse = PreOrderResponse();
  //
  // PreOrderResponse get preOrderResponse => _preOrderResponse;

  String orderNumber = "";
  String accessCode = "";
  String encRequest = "";
  String successUrl = "";
  String cancelUrl = "";
  String PgType = "";
  String rzKey = "";
  bool isCreatingOrder = false; // 👈 new flag

  Future<CommonResponse> createOrder(
      context, orderamount, propertyid) async {
    try {
      if (isCreatingOrder) {
        // already processing
        return CommonResponse(
            isSuccess: false, message: "Already processing...");
      }
      getHomeDataStatus = OrderDataStatus.loading;
      isCreatingOrder = true; // set the flag to true
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      var memberid = pref.getString(APIConstants.userId);

      Utills.customPrint("controller $orderamount");
      var response = await homeService.createPaymentkey(
          orderAmount: orderamount,
          memberId: memberid,
          propertyId: propertyid,
         );
      // if (data['status_Code'] == 200) {
      Utills.customPrint("controller ${json.encode(response)}");

      Utills.customPrint('Order api  response: ${response}');
      // orderNumber = response['order_id'];
      final decodedResponse = jsonDecode(response);
      print(decodedResponse);
      print(decodedResponse['result']);
      print(decodedResponse['result']['paymentdetails']);

      orderNumber = decodedResponse['result']['paymentdetails']['order_id'];
    //  accessCode = response['accessCode'];
     // encRequest = response['encRequest'];
     // successUrl = response['succesurl'];
      //cancelUrl = response['cancelurl'];
      //PgType = response['pgType'];
      rzKey =  decodedResponse['result']['paymentdetails']['key'];
      //
      Utills.customPrint('Home rzKey  $rzKey');
      Utills.customPrint('Home orderNumber  $orderNumber');
      Utills.customPrint('Home successUrl  $successUrl');
      Utills.customPrint('Home cancelUrl  $cancelUrl');
      getHomeDataStatus = OrderDataStatus.loaded;
      isCreatingOrder = false;
      notifyListeners();
      return CommonResponse(
          isSuccess: true, message: "Order Created", data: response);
    } catch (error, stacktrace) {
      Utills.customPrint('preorder error: |$error');
      Utills.customPrint('preorder stacktrace: |${stacktrace}');
      PopupLoader().hideLoader();
      isCreatingOrder = false;
      getHomeDataStatus = OrderDataStatus.error;
      notifyListeners();
      //.replace(context, const LoginPage());
      return CommonResponse(isSuccess: false, message: "Server error.");

      //throw Exception(error.toString());
    }
  }

  // Future preOrder(context, orderamount, propertyid) async {
  //   try {
  //     preOrderStatus = PreOrderStatus.loading;
  //     notifyListeners();
  //
  //     SharedPreferences pref = await SharedPreferences.getInstance();
  //     var memberid = pref.getString(APIConstants.userId);
  //     Utills.customPrint("controller");
  //     _preOrderResponse = await homeService.preOrder(
  //         orderAmount: orderamount, memberId: memberid, propertyId: propertyid);
  //
  //     Utills.customPrint(
  //         'preOrder api  _preOrderResponse: ${_preOrderResponse}');
  //     // ✅ success response
  //     preOrderStatus = PreOrderStatus.loaded;
  //
  //     notifyListeners();
  //   } catch (error, stacktrace) {
  //     Utills.customPrint('homeData stacktrace: |${stacktrace}');
  //     Utills.customPrint('homeData error: |${error.toString()}');
  //     PopupLoader().hideLoader();
  //
  //     preOrderStatus = PreOrderStatus.error;
  //     notifyListeners();
  //     //.replace(context, const LoginPage());
  //     CustomToast.displayErrorToast(content: error.toString());
  //     throw Exception(error.toString());
  //   }
  // }

  Future<CommonResponse> paymentStatusUpdate(
    BuildContext context,
    String transactionid,
    int status,
    String statusmsg,
  ) async {
    try {
      paymentStatus = PaymentConfirmStatus.loading;
      notifyListeners();

      var response = await homeService.paymentConfirm(
        orderid: orderNumber,
        transactionid: transactionid,
        paymentstatus: status,
        statusmsg: statusmsg,
      );

      Utills.customPrint('paymentRazorpay resp: $response');

      paymentStatus = PaymentConfirmStatus.loaded;
      notifyListeners();
      final decodedResponse = jsonDecode(response);
      print("decodedResponse $decodedResponse");
      if(decodedResponse['HasError'] == false) {
        return CommonResponse(
          isSuccess: true,
          message: decodedResponse['ErrorMessage'] ?? "Payment success",
        );
      }else{

        return CommonResponse(
          isSuccess: false,
          message: "Payment failed",
        );
      }
    } catch (error) {
      Utills.customPrint('paymentRazorpay error: $error');

      paymentStatus = PaymentConfirmStatus.error;
      notifyListeners();

      PopupLoader().hideLoader();

      // ❌ Don't pop UI directly here (controller should not know about UI navigation)
      // Navigator.pop(context);

      return CommonResponse(
        isSuccess: false,
        message: "Payment failed: ${error.toString()}",
      );
    }
  }



  Future updateRating(context, cmnt, proprtyid, rating, oid) async {
    try {
      ratingStatus = RatingStatus.loading;
      notifyListeners();
      SharedPreferences pref = await SharedPreferences.getInstance();
      var memberid = pref.getString(APIConstants.userId);
      var memberName = pref.getString(APIConstants.accountName);
      Utills.customPrint("updateRating controller");
      var response = {

      };
      // var response = await homeService.ratingUpdate(
      //     cmnt: cmnt,
      //     orderid: oid,
      //     propertyid: proprtyid,
      //     rating: rating,
      //     memberid: memberid,
      //     memberName: memberName);
      // Utills.customPrint("updateRating ${response}");

      //Utills.customPrint('preOrder api  orderHistory: ${_preOrderResponse}');

      ratingStatus = RatingStatus.loaded;
      if (response['sucess'] == true) {
        CustomToast.displaySuccessToast(content: "Rating updated successfully");
      } else {
        CustomToast.displayErrorToast(content: response['message']);
      }
      CustomToast.displaySuccessToast(content: "Rating updated successfully");

      notifyListeners();
    } catch (error) {
      Utills.customPrint('homeData error: |${error.toString()}');
      PopupLoader().hideLoader();

      ratingStatus = RatingStatus.error;
      notifyListeners();
      //.replace(context, const LoginPage());
      throw Exception(error.toString());
    }
  }
}
