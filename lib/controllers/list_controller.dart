import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/controllers/vendor_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/CommonResponse.dart';
import '../helpers/utillls.dart';
import '../nwdata/service/home_service.dart';
import '../screens/contractor/ContractorReposne.dart';
import '../screens/profile/model/ContractorEnquiryListResponse.dart';
import '../screens/profile/model/EnquireyListResponse.dart';



final listControllerProvider = ChangeNotifierProvider((ref) => ListController());
enum EnquiryListStatus {  loading, loaded, error }
enum ContractorListStatus {  loading, loaded, error }
enum ContractorEnquiryListStatus {  loading, loaded, error }
enum BookPreStatus {  loading, loaded, error }
enum EventDetailStatus {  loading, loaded, error }

class ListController extends ChangeNotifier{

  EnquiryListStatus getEnquiryStatus = EnquiryListStatus.loading;
  ContractorEnquiryListStatus contractorEnquiryStatus = ContractorEnquiryListStatus.loading;
  BookPreStatus preBookStatus = BookPreStatus.loading;
  EventDetailStatus getEventDataStatus = EventDetailStatus.loading;
  ContractorListStatus getContractorListDataStatus = ContractorListStatus.loading;
  List<Contractorlist>? contractorlist;



  bool isCreatingOrder = false;

  List<EnquiryData>? enquiryList;
  List<CList>? contractorEnquiryList;
  Future<CommonResponse> getEnquiryList() async {
    Utills.customPrint("inside getEnquiryList");

    try {
      getEnquiryStatus = EnquiryListStatus.loading;
      notifyListeners();

      EnquireyListResponse vendorListResponse = await HomeService()
          .enquirylists();
      if (vendorListResponse.hasError == true) {
        getEnquiryStatus = EnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        enquiryList = vendorListResponse.result!.list!;

        Utills.customPrint('enquiryList  response: ${enquiryList!.length}');

        getEnquiryStatus = EnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error,stacktrace) {
      Utills.customPrint('EnquiryList error: |$error');
      Utills.customPrint('EnquiryList error: |$stacktrace');
      //  PopupLoader().hideLoader();
      getEnquiryStatus = EnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> getVendorMyEnquiryList() async {
    Utills.customPrint("inside getVendorMyEnquiryList");
    try {
      getEnquiryStatus = EnquiryListStatus.loading;
      notifyListeners();

      EnquireyListResponse vendorListResponse = await HomeService()
          .vendormyenquirylists();
      if (vendorListResponse.hasError == true) {
        getEnquiryStatus = EnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        enquiryList = vendorListResponse.result!.list!;

        Utills.customPrint('enquiryList  response: ${enquiryList!.length}');

        getEnquiryStatus = EnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error,stacktrace) {
      Utills.customPrint('EnquiryList error: |$error');
      Utills.customPrint('EnquiryList error: |$stacktrace');

      //  PopupLoader().hideLoader();
      getEnquiryStatus = EnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> getContractorEnquiryList() async {
    try {
      contractorEnquiryStatus = ContractorEnquiryListStatus.loading;
      notifyListeners();

      ContractorEnquiryListResponse vendorListResponse = await HomeService().contractorenquirylists();
      if (vendorListResponse.hasError == true) {
        contractorEnquiryStatus = ContractorEnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        contractorEnquiryList = vendorListResponse.result!.list!;

        Utills.customPrint('_contractorEnquiryList  response: ${contractorEnquiryList!.length}');

        contractorEnquiryStatus = ContractorEnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error,stacktrace) {
      Utills.customPrint('Contractor enquiry stacktrace: |$stacktrace');
      Utills.customPrint('Contractor enquiry error: |$error');
      //  PopupLoader().hideLoader();
      contractorEnquiryStatus = ContractorEnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> getContractorMyEnquiryList() async {
    try {
      contractorEnquiryStatus = ContractorEnquiryListStatus.loading;
      notifyListeners();

      ContractorEnquiryListResponse vendorListResponse = await HomeService().contractormyenquirylists();
      if (vendorListResponse.hasError == true) {
        contractorEnquiryStatus = ContractorEnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        contractorEnquiryList = vendorListResponse.result!.list!;

        Utills.customPrint('_contractorEnquiryList  response: ${contractorEnquiryList!.length}');

        contractorEnquiryStatus = ContractorEnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('EnquiryList error: |$error');
      //  PopupLoader().hideLoader();
      contractorEnquiryStatus = ContractorEnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> getContractorList() async {
    try {
      getContractorListDataStatus = ContractorListStatus.loading;
      notifyListeners();

      ContractorResponse vendorListResponse = await HomeService().contractorlist();
      if (vendorListResponse.hasError == true) {
        getContractorListDataStatus = ContractorListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        contractorlist = vendorListResponse.result!.contractorlist!;
        //
         Utills.customPrint('contractorlist  response: ${contractorlist!.length}');

        getContractorListDataStatus = ContractorListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error,stacktrace) {
      Utills.customPrint('EnquiryList error: |$error');
      Utills.customPrint('EnquiryList stacktrace: |$stacktrace');
      //  PopupLoader().hideLoader();
      getContractorListDataStatus = ContractorListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }

  // Future<CommonResponse> getEventLists(propertyid,int? propertyId,int? categoryId) async{
  //   try {
  //     getDataStatus = DetailStatus.loading;
  //     notifyListeners();
  //     // SharedPreferences pref = await SharedPreferences.getInstance();
  //     // var memberid = pref.getString(APIConstants.userId);
  //     Utills.customPrint("controller");
  //     eventList = await bookingService.getEventList(propertyId);
  //     // faqList = response;
  //
  //
  //
  //     Utills.customPrint('eventList  response: ${eventList.length}');
  //
  //     getDataStatus = DetailStatus.loaded;
  //
  //     notifyListeners();
  //     return CommonResponse(isSuccess: true, message: "response['message']");
  //
  //   } catch (error) {
  //     Utills.customPrint('homeData error: |$error');
  //     //  PopupLoader().hideLoader();
  //     getDataStatus = DetailStatus.error;
  //     notifyListeners();
  //     return CommonResponse(isSuccess: false, message: "Server error.");
  //
  //   }
  //
  //
  // }
  // Future<CommonResponse> getEventDetail(int? eventid) async{
  //   try {
  //     getEventDataStatus = EventDetailStatus.loading;
  //     notifyListeners();
  //
  //     eventDetailList = await bookingService.getEventDetail(eventid);
  //
  //     Utills.customPrint('eventList  response: ${eventList.length}');
  //
  //     getEventDataStatus = EventDetailStatus.loaded;
  //
  //     notifyListeners();
  //     return CommonResponse(isSuccess: true, message: "response['message']");
  //
  //   } catch (error) {
  //     Utills.customPrint('homeData error: |$error');
  //     //  PopupLoader().hideLoader();
  //     getEventDataStatus = EventDetailStatus.error;
  //     notifyListeners();
  //     return CommonResponse(isSuccess: false, message: "Server error.");
  //
  //   }
  //
  //
  // }
  //
  //
  // prebookTickets(List<Map<String, dynamic>> payload) async {
  //   try {
  //     preBookStatus = BookPreStatus.loading;
  //     notifyListeners();
  //
  //     preOrderResponse = await bookingService.getPreEventbook(payload);
  //
  //     Utills.customPrint('eventList  preOrderResponse: ${preOrderResponse.totalAmount}');
  //
  //     preBookStatus = BookPreStatus.loaded;
  //
  //     notifyListeners();
  //     return CommonResponse(isSuccess: true, message: "response['message']");
  //
  //   } catch (error) {
  //     Utills.customPrint('homeData error: |$error');
  //     //  PopupLoader().hideLoader();
  //     preBookStatus = BookPreStatus.error;
  //     notifyListeners();
  //     return CommonResponse(isSuccess: false, message: "Server error.");
  //
  //   }
  //
  // }
}