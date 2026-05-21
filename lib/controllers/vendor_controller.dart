
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sahajghara/nwdata/service/home_service.dart';
import 'package:sahajghara/nwdata/service/profile_service.dart';
import 'package:sahajghara/screens/profile/model/ProfileResponse.dart';

import '../helpers/CommonResponse.dart';
import '../helpers/utillls.dart';
import '../nwdata/model/EnquiryResponse.dart' hide Result;
import '../screens/vendor/VendorListResponse.dart' hide Result;

final vendorControllerProvider = ChangeNotifierProvider((ref) => VendorController());
enum VendorListStatus {  loading, loaded, error }
enum EnquiryListStatus {  loading, loaded, error }
enum SubmitListStatus {  loading, loaded, error }
enum ProfileDataStatus {  loading, loaded, error }

class VendorController extends ChangeNotifier {

  VendorListStatus vendorListStatus = VendorListStatus.loading;
  EnquiryListStatus enquiryListStatus = EnquiryListStatus.loading;
  SubmitListStatus submitListStatus = SubmitListStatus.loading;
  ProfileDataStatus profileDataStatus = ProfileDataStatus.loading;
  Result? profileData;

  List<Vendorlist>? vendorList;
  Future<CommonResponse> getVendorList(String? categoryId, String? brandId, String? subcategory) async {
    try {
      vendorListStatus = VendorListStatus.loading;
      notifyListeners();

      VendorListResponse vendorListResponse = await new HomeService()
          .getVendorList(categoryId, brandId, subcategory);
      if (vendorListResponse.hasError == true) {
        vendorListStatus = VendorListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        vendorList = vendorListResponse.result!.vendorlist;

        Utills.customPrint('eventList  response: ${vendorList!.length}');

        vendorListStatus = VendorListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      vendorListStatus = VendorListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> submitVendorData(Map<String, String>? data) async {
    try {
      enquiryListStatus = EnquiryListStatus.loading;
      notifyListeners();
      Utills.customPrint('inquirySubmit data ${json.encode(data)}');
      EnquiryResponse vendorListResponse = await HomeService()
          .submitEnquiry(data);
      if (vendorListResponse.hasError == true) {
        enquiryListStatus = EnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        //vendorList = vendorListResponse.result!.vendorlist;

       // Utills.customPrint('eventList  response: ${vendorList!.length}');

        enquiryListStatus = EnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error,stackTrace) {
      Utills.customPrint('enquirylist stackTrace: |$stackTrace');
      Utills.customPrint('enquirylist error: |$error');
      //  PopupLoader().hideLoader();
      enquiryListStatus = EnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> submitContractorData(Map<String, String>? data) async {
    try {
      enquiryListStatus = EnquiryListStatus.loading;
      notifyListeners();
      Utills.customPrint('inquirySubmit data ${json.encode(data)}');
      EnquiryResponse vendorListResponse = await HomeService()
          .submitContractor(data);
      if (vendorListResponse.hasError == true) {
        enquiryListStatus = EnquiryListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        //vendorList = vendorListResponse.result!.vendorlist;

       // Utills.customPrint('eventList  response: ${vendorList!.length}');

        enquiryListStatus = EnquiryListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('submitVendorData error: |$error');
      //  PopupLoader().hideLoader();
      enquiryListStatus = EnquiryListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<CommonResponse> submitRequest(int type) async {
    try {
      submitListStatus = SubmitListStatus.loading;
      notifyListeners();
     // Utills.customPrint('inquirySubmit data ${json.encode(data)}');
      EnquiryResponse vendorListResponse = await ProfileService()
          .submitRequest(type);
      if (vendorListResponse.hasError == true) {
        submitListStatus = SubmitListStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        //vendorList = vendorListResponse.result!.vendorlist;

       // Utills.customPrint('eventList  response: ${vendorList!.length}');

        submitListStatus = SubmitListStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message ?? "");
      }
    } catch (error) {
      Utills.customPrint('submitVendorData error: |$error');
      //  PopupLoader().hideLoader();
      submitListStatus = SubmitListStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }
  Future<ProfileResponse> getProfile() async {
    try {
      profileDataStatus = ProfileDataStatus.loading;
      notifyListeners();
     // Utills.customPrint('inquirySubmit data ${json.encode(data)}');
      ProfileResponse vendorListResponse = await ProfileService()
          .getProfileData();
      if (vendorListResponse.hasError == true) {
        profileDataStatus = ProfileDataStatus.error;
        notifyListeners();
        return ProfileResponse();
      } else {
        //vendorList = vendorListResponse.result!.vendorlist;

       // Utills.customPrint('eventList  response: ${vendorList!.length}');
        profileData = vendorListResponse.result;
        profileDataStatus = ProfileDataStatus.loaded;

        notifyListeners();
        return ProfileResponse();
      }
    } catch (error,stackTrace) {
      Utills.customPrint('profile stackTrace: |$stackTrace');
      Utills.customPrint('profile error: |$error');
      //  PopupLoader().hideLoader();
      profileDataStatus = ProfileDataStatus.error;
      notifyListeners();
      return ProfileResponse();
    }
  }
}