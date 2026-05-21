import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../helpers/CommonResponse.dart';
import '../helpers/custom_toast.dart';
import '../helpers/navigation.dart';
import '../helpers/utillls.dart';

import '../nwdata/api/api_helper.dart';

import '../nwdata/model/brand_response.dart';
import '../nwdata/service/home_service.dart';
import '../presentation/widgets/load_state/loader/popup_loader.dart';
import '../screens/home/HomePageResponse.dart';
import '../screens/auth/login_screen.dart';


enum GetHomeDataStatus { initial, loading, loaded, error, unAutheticated }
enum GetCategoryListStatus {  loading, loaded, error }
enum GetDetailStatus {  loading, loaded, error }
enum GetCategoryList {  loading, loaded, error }
enum SeacrhList {  loading, loaded, error }
enum SeacrhFilterList {  loading, loaded, error }

final homeControllerProvider =
    ChangeNotifierProvider((ref) => HomeController());


class HomeController extends ChangeNotifier {
  APIHelper api = APIHelper();
  GetHomeDataStatus getHomeDataStatus = GetHomeDataStatus.loading;
  GetCategoryListStatus getCategoryListStatus = GetCategoryListStatus.loading;
  GetDetailStatus detailStatus = GetDetailStatus.loading;
  GetCategoryList getCategoryStatus = GetCategoryList.loading;
  SeacrhList searchStatus = SeacrhList.loading;
  SeacrhFilterList searchFilterStatus = SeacrhFilterList.loading;

  // List<Map<String, dynamic>> =

  String? selectedCompany = "Select Company";
  String homeImage ="";
  bool? dailyProductionStatus;
   var bannerList = <ImagegalleryList>[];
   var categoryList = <Category>[];
   var brandList = <Brand>[];
   var brandLists = <Brands>[];

   //PrimumPropertyDetails? propertyDetailsData;
  List<Map<String, Object?>> tabList = [];
   late double latitude;
    late double longitude;
    String mediaType="";
  bool _isHomeDataFetched = false;

  // List<Map<String, dynamic>> tabList = [];

  HomeService homeService = HomeService();
  Result? homeResult;



  setLatitude(value) {
    latitude = value;
    notifyListeners();
  }

  setLongitude(value) {
    longitude = value;
    notifyListeners();
  }
setFetch(value) {
  _isHomeDataFetched = value;
    notifyListeners();
  }

  Future<void> refreshHomeData(BuildContext context) async {
    _isHomeDataFetched = false;
    await getHomeData(context);
  }
  Future getHomeData(context) async {
    getHomeDataStatus = GetHomeDataStatus.loading;
    //PopupLoader().showLoader(context);
    // if (_isHomeDataFetched) {
    //   // Skip fetching again if already fetched
    //   return;
    // }

    try {
      Utills.customPrint("controller");

      HomePageResponse homePageResponse = await homeService.getHomeData(latitude: latitude,longitude: longitude);
      // Utills.customPrint('Home api controler response: ${data.hasError}');
      Utills.customPrint('Home controler response ${homePageResponse.result!.imagegalleryList!.length}');
      getHomeDataStatus = GetHomeDataStatus.loaded;
     bannerList = homePageResponse.result!.imagegalleryList!;
      categoryList = homePageResponse.result!.category!;
      brandList = homePageResponse.result!.brand!;
      homeResult = homePageResponse.result;
     // homeImage = homePageResponse.homeImage!;
      //mediaType = homePageResponse.mediaType!;
      //premiumPropertyList = homePageResponse.primumProperty!;
      //adminOfferList = homePageResponse.adminOffer!;
      _isHomeDataFetched = true;
      getHomeDataStatus = GetHomeDataStatus.loaded;

      notifyListeners();
    } catch (error,stackTrace) {
      Utills.customPrint('homeData stackTrace: |$stackTrace');
      Utills.customPrint('homeData error: |$error');
      PopupLoader().hideLoader();
      _isHomeDataFetched = false;

      getHomeDataStatus = GetHomeDataStatus.error;
      notifyListeners();

      //.replace(context, const LoginPage());
      throw Exception(error.toString());
    }
    notifyListeners();
  }
  Future<CommonResponse> getbrandList(String? categoryId,String? subcategory) async {
    try {
      detailStatus = GetDetailStatus.loading;
      notifyListeners();

      BrandResponse vendorListResponse = await new HomeService()
          .getBrandList(categoryId, subcategory);
      if (vendorListResponse.hasError == true) {
        detailStatus = GetDetailStatus.error;
        notifyListeners();
        return CommonResponse(
            isSuccess: false, message: vendorListResponse.message ?? "");
      } else {
        brandLists = vendorListResponse.data ?? [];

        Utills.customPrint('brandLists  response: ${brandLists!.length}');

        detailStatus = GetDetailStatus.loaded;

        notifyListeners();
        return CommonResponse(
            isSuccess: true, message: vendorListResponse.message??"",data: brandLists);
      }
    } catch (error) {
      Utills.customPrint('homeData error: |$error');
      //  PopupLoader().hideLoader();
      detailStatus = GetDetailStatus.error;
      notifyListeners();
      return CommonResponse(isSuccess: false, message: "Server error.");
    }
  }


}
